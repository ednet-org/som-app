import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/application/application.dart';
import '../../domain/model/layout/app_body.dart';
import '../../theme/tokens.dart';
import '../../utils/formatters.dart';
import '../../utils/ui_logger.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/status_badge.dart';

const _apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:8081',
);

class ProvidersAppBody extends StatefulWidget {
  const ProvidersAppBody({Key? key}) : super(key: key);

  @override
  State<ProvidersAppBody> createState() => _ProvidersAppBodyState();
}

class _ProvidersAppBodyState extends State<ProvidersAppBody> {
  Future<List<ProviderSummary>>? _providersFuture;
  List<ProviderSummary> _providers = const [];
  ProviderSummary? _selected;

  String? _branchId;
  String? _companySize;
  String? _providerType;
  String? _zipPrefix;
  String? _status;
  String? _claimed;

  List<Branch> _branches = const [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _providersFuture ??= _loadProviders();
    _loadBranches();
  }

  Future<void> _loadBranches() async {
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final response = await api.getBranchesApi().branchesGet();
      setState(() {
        _branches = response.data?.toList() ?? const [];
      });
    } catch (error, stackTrace) {
      UILogger.silentError('ProvidersAppBody._loadBranches', error, stackTrace);
    }
  }

  Future<List<ProviderSummary>> _loadProviders() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final response = await api.getProvidersApi().providersGet(
          branchId: _branchId,
          companySize: _companySize,
          providerType: _providerType,
          zipPrefix: _zipPrefix,
          status: _status,
          claimed: _claimed,
        );
    _providers = response.data?.toList() ?? const [];
    return _providers;
  }

  Future<void> _refresh() async {
    setState(() {
      _providersFuture = _loadProviders();
    });
  }

  Future<void> _exportCsv() async {
    final uri = Uri.parse(_apiBaseUrl).replace(
      path: '/providers',
      queryParameters: {
        if (_branchId != null) 'branchId': _branchId,
        if (_companySize != null) 'companySize': _companySize,
        if (_providerType != null) 'providerType': _providerType,
        if (_zipPrefix != null && _zipPrefix!.isNotEmpty)
          'zipPrefix': _zipPrefix,
        if (_status != null) 'status': _status,
        if (_claimed != null) 'claimed': _claimed,
        'format': 'csv',
      },
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _approveProvider(ProviderSummary provider) async {
    if (provider.companyId == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final branchIdsToApprove = provider.pendingBranchIds?.toList() ?? [];
      await api.getProvidersApi().providersCompanyIdApprovePost(
        companyId: provider.companyId!,
        providersCompanyIdApprovePostRequest: ProvidersCompanyIdApprovePostRequest((b) {
          b.approvedBranchIds.clear();
          b.approvedBranchIds.addAll(branchIdsToApprove);
        }),
      );
      _showSnackbar('Provider approved successfully.');
      await _refresh();
    } on DioException catch (error) {
      _showSnackbar('Failed to approve: ${_extractError(error)}');
    }
  }

  Future<void> _showDeclineDialog(ProviderSummary provider) async {
    if (provider.companyId == null) return;
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decline Provider'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company: ${provider.companyName ?? provider.companyId}'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for declining',
                hintText: 'Enter the reason...',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Decline'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getProvidersApi().providersCompanyIdDeclinePost(
        companyId: provider.companyId!,
        subscriptionsCancelPostRequest: SubscriptionsCancelPostRequest((b) => b
          ..reason = reasonController.text.trim(),
        ),
      );
      _showSnackbar('Provider declined.');
      await _refresh();
    } on DioException catch (error) {
      _showSnackbar('Failed to decline: ${_extractError(error)}');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _extractError(DioException error) {
    final data = error.response?.data;
    if (data is String) return data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return error.message ?? 'Request failed.';
  }

  void _filterPendingOnly() {
    setState(() {
      _status = 'pending';
      _providersFuture = _loadProviders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    if (appStore.authorization == null ||
        appStore.authorization?.isConsultant != true ||
        appStore.authorization?.isAdmin != true) {
      return const AppBody(
        contextMenu: Text('Consultant admin access required'),
        leftSplit: Center(child: Text('Only consultant admins can manage providers.')),
        rightSplit: SizedBox.shrink(),
      );
    }

    return FutureBuilder<List<ProviderSummary>>(
      future: _providersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppBody(
            contextMenu: Text('Loading'),
            leftSplit: Center(child: CircularProgressIndicator()),
            rightSplit: SizedBox.shrink(),
          );
        }
        if (snapshot.hasError) {
          return AppBody(
            contextMenu: const Text('Error'),
            leftSplit: Center(
              child: Text('Failed to load providers: ${snapshot.error}'),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final providers = snapshot.data ?? const [];
        if (providers.isEmpty) {
          return AppBody(
            contextMenu: AppToolbar(
              title: const Text('Providers'),
              actions: [
                TextButton(onPressed: _refresh, child: const Text('Refresh')),
                TextButton(
                  onPressed: _filterPendingOnly,
                  child: const Text('Pending Approval'),
                ),
                TextButton(onPressed: _exportCsv, child: const Text('Export CSV')),
              ],
            ),
            leftSplit: const EmptyState(
              icon: Icons.apartment_outlined,
              title: 'No providers found',
              message: 'Try adjusting filters or importing providers',
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        return AppBody(
          contextMenu: AppToolbar(
            title: const Text('Providers'),
            actions: [
              TextButton(onPressed: _refresh, child: const Text('Refresh')),
              TextButton(
                onPressed: _filterPendingOnly,
                child: const Text('Pending Approval'),
              ),
              TextButton(onPressed: _exportCsv, child: const Text('Export CSV')),
            ],
          ),
          leftSplit: Column(
            children: [
              _buildFilters(),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: providers.length,
                  itemBuilder: (context, index) {
                    final provider = providers[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: SomSpacing.md,
                        vertical: SomSpacing.xs,
                      ),
                      title: Text(
                        provider.companyName ?? provider.companyId ?? 'Provider',
                      ),
                      subtitle: Text(
                        'Type: ${provider.providerType ?? '-'} | '
                        'Size: ${provider.companySize ?? '-'}',
                      ),
                      selected: _selected?.companyId == provider.companyId,
                      onTap: () => setState(() => _selected = provider),
                      trailing: StatusBadge.provider(
                        status: provider.status ?? 'pending',
                        compact: false,
                        showIcon: false,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          rightSplit: _selected == null
              ? const EmptyState(
                  icon: Icons.touch_app_outlined,
                  title: 'Select a provider',
                  message: 'Choose a provider from the list to view details',
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      Text(_selected!.companyName ?? 'Provider',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: SomSpacing.xs),
                      StatusBadge.provider(status: _selected!.status ?? 'pending'),
                      const SizedBox(height: 8),
                      Text('Company ID: ${SomFormatters.shortId(_selected!.companyId)}'),
                      Text('Size: ${_selected!.companySize ?? '-'}'),
                      Text('Type: ${SomFormatters.capitalize(_selected!.providerType)}'),
                      Text('Postcode: ${_selected!.postcode ?? '-'}'),
                      Text('Branches: ${SomFormatters.list(_selected!.branchIds?.toList())}'),
                      Text(
                        'Pending branches: '
                        '${SomFormatters.list(_selected!.pendingBranchIds?.toList())}',
                      ),
                      Text('Status: ${_selected!.status ?? '-'}'),
                      if (_selected!.rejectionReason != null)
                        Text(
                          'Rejection reason: '
                          '${_selected!.rejectionReason ?? '-'}',
                        ),
                      if (_selected!.rejectedAt != null)
                        Text(
                          'Rejected at: '
                          '${SomFormatters.dateTime(_selected!.rejectedAt)}',
                        ),
                      const Divider(height: 24),
                      Text('Subscription: ${_selected!.subscriptionPlanId ?? '-'}'),
                      Text('Payment interval: ${_selected!.paymentInterval ?? '-'}'),
                      const Divider(height: 24),
                      Text('IBAN: ${_selected!.iban ?? '-'}'),
                      Text('BIC: ${_selected!.bic ?? '-'}'),
                      Text('Account owner: ${_selected!.accountOwner ?? '-'}'),
                      Text('Registration date: ${SomFormatters.dateTime(_selected!.registrationDate)}'),
                      if (_selected!.status == 'pending' ||
                          (_selected!.pendingBranchIds?.isNotEmpty ?? false)) ...[
                        const Divider(height: 24),
                        Text(
                          'Approval Actions',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _approveProvider(_selected!),
                              icon: const Icon(Icons.check),
                              label: const Text('Approve'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () => _showDeclineDialog(_selected!),
                              icon: const Icon(Icons.close),
                              label: const Text('Decline'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildFilters() {
    return ExpansionTile(
      title: const Text('Filters'),
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              DropdownButton<String>(
                hint: const Text('Branch'),
                value: _branchId,
                items: _branches
                    .map((branch) => DropdownMenuItem(
                          value: branch.id,
                          child: Text(branch.name ?? branch.id ?? '-'),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _branchId = value),
              ),
              DropdownButton<String>(
                hint: const Text('Company size'),
                value: _companySize,
                items: const [
                  DropdownMenuItem(value: '0-10', child: Text('0-10')),
                  DropdownMenuItem(value: '11-50', child: Text('11-50')),
                  DropdownMenuItem(value: '51-100', child: Text('51-100')),
                  DropdownMenuItem(value: '101-250', child: Text('101-250')),
                  DropdownMenuItem(value: '251-500', child: Text('251-500')),
                  DropdownMenuItem(value: '500+', child: Text('500+')),
                ],
                onChanged: (value) => setState(() => _companySize = value),
              ),
              DropdownButton<String>(
                hint: const Text('Provider type'),
                value: _providerType,
                items: const [
                  DropdownMenuItem(value: 'haendler', child: Text('Händler')),
                  DropdownMenuItem(value: 'hersteller', child: Text('Hersteller')),
                  DropdownMenuItem(value: 'dienstleister', child: Text('Dienstleister')),
                  DropdownMenuItem(value: 'grosshaendler', child: Text('Großhändler')),
                ],
                onChanged: (value) => setState(() => _providerType = value),
              ),
              SizedBox(
                width: 120,
                child: TextField(
                  decoration: const InputDecoration(labelText: 'ZIP prefix'),
                  onChanged: (value) => setState(() => _zipPrefix = value.trim()),
                ),
              ),
              DropdownButton<String>(
                hint: const Text('Status'),
                value: _status,
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'declined', child: Text('Declined')),
                ],
                onChanged: (value) => setState(() => _status = value),
              ),
              DropdownButton<String>(
                hint: const Text('Claimed'),
                value: _claimed,
                items: const [
                  DropdownMenuItem(value: 'true', child: Text('Claimed')),
                  DropdownMenuItem(value: 'false', child: Text('Unclaimed')),
                ],
                onChanged: (value) => setState(() => _claimed = value),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _branchId = null;
                    _companySize = null;
                    _providerType = null;
                    _zipPrefix = null;
                    _status = null;
                    _claimed = null;
                  });
                  _refresh();
                },
                child: const Text('Clear'),
              ),
              ElevatedButton(
                onPressed: _refresh,
                child: const Text('Apply'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
