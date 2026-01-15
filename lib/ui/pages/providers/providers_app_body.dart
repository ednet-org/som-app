import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/application/application.dart';
import '../../domain/model/layout/app_body.dart';

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
  Map<String, String?> _rejectionReasons = {};
  Map<String, String?> _rejectedAt = {};

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
    } catch (_) {}
  }

  Future<List<ProviderSummary>> _loadProviders() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final query = <String, dynamic>{
      if (_branchId != null) 'branchId': _branchId,
      if (_companySize != null) 'companySize': _companySize,
      if (_providerType != null) 'providerType': _providerType,
      if (_zipPrefix != null && _zipPrefix!.isNotEmpty) 'zipPrefix': _zipPrefix,
      if (_status != null) 'status': _status,
      if (_claimed != null) 'claimed': _claimed,
    };
    final response = await api.getProvidersApi().providersGet(
          branchId: _branchId,
          companySize: _companySize,
          providerType: _providerType,
          zipPrefix: _zipPrefix,
          status: _status,
          claimed: _claimed,
        );
    _providers = response.data?.toList() ?? const [];
    try {
      final raw = await api.dio.get('/providers', queryParameters: query);
      final rows = raw.data as List<dynamic>;
      final reasons = <String, String?>{};
      final rejectedAt = <String, String?>{};
      for (final row in rows) {
        final id = row['companyId']?.toString();
        if (id == null || id.isEmpty) continue;
        reasons[id] = row['rejectionReason'] as String?;
        rejectedAt[id] = row['rejectedAt'] as String?;
      }
      _rejectionReasons = reasons;
      _rejectedAt = rejectedAt;
    } catch (_) {}
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
        return AppBody(
          contextMenu: Row(
            children: [
              Text('Providers', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 12),
              TextButton(onPressed: _refresh, child: const Text('Refresh')),
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
                      title: Text(
                        provider.companyName ?? provider.companyId ?? 'Provider',
                      ),
                      subtitle: Text(
                        'Type: ${provider.providerType ?? '-'} | '
                        'Size: ${provider.companySize ?? '-'}',
                      ),
                      selected: _selected?.companyId == provider.companyId,
                      onTap: () => setState(() => _selected = provider),
                    );
                  },
                ),
              ),
            ],
          ),
          rightSplit: _selected == null
              ? const Center(child: Text('Select a provider.'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      Text(_selected!.companyName ?? 'Provider',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Company ID: ${_selected!.companyId ?? '-'}'),
                      Text('Size: ${_selected!.companySize ?? '-'}'),
                      Text('Type: ${_selected!.providerType ?? '-'}'),
                      Text('Postcode: ${_selected!.postcode ?? '-'}'),
                      Text('Branches: ${_selected!.branchIds?.join(', ') ?? '-'}'),
                      Text(
                        'Pending branches: '
                        '${_selected!.pendingBranchIds?.join(', ') ?? '-'}',
                      ),
                      Text('Status: ${_selected!.status ?? '-'}'),
                      if (_rejectionReasons[_selected!.companyId ?? ''] != null)
                        Text(
                          'Rejection reason: '
                          '${_rejectionReasons[_selected!.companyId ?? ''] ?? '-'}',
                        ),
                      if (_rejectedAt[_selected!.companyId ?? ''] != null)
                        Text(
                          'Rejected at: '
                          '${_rejectedAt[_selected!.companyId ?? ''] ?? '-'}',
                        ),
                      const Divider(height: 24),
                      Text('Subscription: ${_selected!.subscriptionPlanId ?? '-'}'),
                      Text('Payment interval: ${_selected!.paymentInterval ?? '-'}'),
                      const Divider(height: 24),
                      Text('IBAN: ${_selected!.iban ?? '-'}'),
                      Text('BIC: ${_selected!.bic ?? '-'}'),
                      Text('Account owner: ${_selected!.accountOwner ?? '-'}'),
                      Text('Registration date: ${_selected!.registrationDate ?? '-'}'),
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
