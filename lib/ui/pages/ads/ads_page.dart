import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/theme/som_assets.dart';

import '../../domain/application/application.dart';
import '../../domain/infrastructure/supabase_realtime.dart';
import '../../domain/model/layout/app_body.dart';
import '../../utils/ui_logger.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/inline_message.dart';
import '../../widgets/snackbars.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/status_legend.dart';
import 'widgets/ads_buyer_view.dart';
import 'widgets/ads_create_form.dart';
import 'widgets/ads_edit_form.dart';
import 'widgets/ads_filters.dart';
import 'widgets/ads_list.dart';

/// Main page for ad management.
///
/// Orchestrates ad list, create/edit forms, filters, and buyer view.
class AdsPage extends StatefulWidget {
  const AdsPage({super.key});

  @override
  State<AdsPage> createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  Future<List<Ad>>? _adsFuture;
  Ad? _selectedAd;
  List<Branch> _branches = const [];
  List<CompanyOption> _providerCompanies = const [];

  String? _filterBranchId;
  String? _filterStatus;
  String? _filterType;

  bool _showCreateForm = false;
  bool _bulkMode = false;
  final Set<String> _bulkSelection = {};
  bool _bootstrapped = false;
  bool _realtimeReady = false;
  late final RealtimeRefreshHandle _realtimeRefresh =
      RealtimeRefreshHandle(_handleRealtimeRefresh);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _adsFuture ??= _loadAds();
    if (!_bootstrapped) {
      _bootstrapped = true;
      _bootstrap();
    }
    _setupRealtime();
  }

  @override
  void dispose() {
    _realtimeRefresh.dispose();
    super.dispose();
  }

  void _handleRealtimeRefresh() {
    if (!mounted) return;
    _refresh();
  }

  void _setupRealtime() {
    if (_realtimeReady) return;
    final appStore = Provider.of<Application>(context, listen: false);
    SupabaseRealtime.setAuth(appStore.authorization?.token);
    _realtimeRefresh.subscribe(
      tables: const ['ads'],
      channelName: 'ads-page',
    );
    _realtimeReady = true;
  }

  Future<void> _bootstrap() async {
    final appStore = Provider.of<Application>(context, listen: false);
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final response = await api.getBranchesApi().branchesGet();
      setState(() {
        _branches = response.data?.toList() ?? const [];
      });
    } catch (error, stackTrace) {
      UILogger.silentError('AdsPage._bootstrap.branches', error, stackTrace);
    }
    // Fetch provider companies for consultants
    if (appStore.authorization?.isConsultant == true) {
      try {
        final companiesResponse = await api.getCompaniesApi().companiesGet(
          type: 'provider',
        );
        setState(() {
          _providerCompanies = companiesResponse.data
                  ?.map((c) => CompanyOption(
                        id: c.id ?? '',
                        name: c.name ?? '',
                      ))
                  .where((c) => c.id.isNotEmpty)
                  .toList() ??
              const [];
        });
      } catch (error, stackTrace) {
        UILogger.silentError('AdsPage._bootstrap.companies', error, stackTrace);
      }
    }
  }

  Future<List<Ad>> _loadAds() async {
    final appStore = Provider.of<Application>(context, listen: false);
    final api = Provider.of<Openapi>(context, listen: false);
    final scope = appStore.authorization?.isConsultant == true
        ? 'all'
        : appStore.authorization?.isProvider == true
        ? 'company'
        : null;
    final response = await api.getAdsApi().adsGet(
      branchId: _filterBranchId,
      status: _filterStatus,
      scope: scope,
    );
    return response.data?.toList() ?? const [];
  }

  Future<void> _refresh() async {
    setState(() {
      _adsFuture = _loadAds();
    });
  }

  void _clearFilters() {
    setState(() {
      _filterBranchId = null;
      _filterStatus = null;
      _filterType = null;
    });
    _refresh();
  }

  Future<void> _selectAd(Ad ad) async {
    setState(() {
      _selectedAd = ad;
    });
  }

  void _enterBulkMode([Ad? ad]) {
    setState(() {
      _bulkMode = true;
      _bulkSelection.clear();
      if (ad?.id != null) {
        _bulkSelection.add(ad!.id!);
      }
      _selectedAd = null;
      _showCreateForm = false;
    });
  }

  void _exitBulkMode() {
    setState(() {
      _bulkMode = false;
      _bulkSelection.clear();
    });
  }

  void _toggleBulkSelection(Ad ad) {
    final id = ad.id;
    if (id == null || id.isEmpty) {
      SomSnackBars.warning(context, 'Ad is missing an ID.');
      return;
    }
    setState(() {
      if (!_bulkSelection.add(id)) {
        _bulkSelection.remove(id);
      }
    });
  }

  Future<void> _bulkDeleteSelected() async {
    if (_bulkSelection.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete selected ads'),
        content: Text('Delete ${_bulkSelection.length} ad(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!mounted) return;
    final api = Provider.of<Openapi>(context, listen: false);
    int success = 0;
    int failed = 0;
    for (final id in _bulkSelection) {
      try {
        await api.getAdsApi().adsAdIdDelete(adId: id);
        success += 1;
      } catch (_) {
        failed += 1;
      }
    }
    if (!mounted) return;
    if (success > 0) {
      final suffix = failed > 0 ? ' • $failed failed' : '';
      _showSnack('Deleted $success ad${success == 1 ? '' : 's'}$suffix.');
    } else {
      _showSnack('Failed to delete selected ads.');
    }
    await _refresh();
    if (mounted) _exitBulkMode();
  }

  Future<void> _createAd(AdFormData data) async {
    final api = Provider.of<Openapi>(context, listen: false);
    final response = await api.getAdsApi().createAd(
      createAdRequest: CreateAdRequest(
        (b) => b
          ..companyId = data.companyId
          ..type = data.type
          ..status = CreateAdRequestStatusEnum.draft
          ..branchId = data.branchId
          ..url = data.url
          ..headline = data.headline
          ..description = data.description
          ..startDate = data.startDate?.toUtc().toIso8601String()
          ..endDate = data.endDate?.toUtc().toIso8601String()
          ..bannerDate = data.bannerDate?.toUtc().toIso8601String(),
      ),
    );
    final adId = response.data?.id;
    if (adId != null && data.image?.bytes != null) {
      await api.getAdsApi().adsAdIdImagePost(
        adId: adId,
        file: MultipartFile.fromBytes(
          data.image!.bytes!,
          filename: data.image!.name,
        ),
      );
    }
    _showSnack('Ad created.');
    setState(() => _showCreateForm = false);
    await _refresh();
  }

  Future<void> _updateAd(AdEditData data) async {
    if (_selectedAd?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    final updated = _selectedAd!.rebuild(
      (b) => b
        ..url = data.url
        ..headline = data.headline.isEmpty ? null : data.headline
        ..description = data.description.isEmpty ? null : data.description
        ..startDate = data.startDate?.toUtc()
        ..endDate = data.endDate?.toUtc()
        ..bannerDate = data.bannerDate?.toUtc(),
    );
    await api.getAdsApi().adsAdIdPut(adId: updated.id!, ad: updated);
    if (data.image?.bytes != null) {
      await api.getAdsApi().adsAdIdImagePost(
        adId: updated.id!,
        file: MultipartFile.fromBytes(
          data.image!.bytes!,
          filename: data.image!.name,
        ),
      );
    }
    _showSnack('Ad updated.');
    await _refresh();
  }

  Future<void> _activateAd() async {
    if (_selectedAd?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getAdsApi().adsAdIdActivatePost(
        adId: _selectedAd!.id!,
        adActivationRequest: AdActivationRequest(
          (b) => b
            ..startDate = _selectedAd!.startDate?.toUtc()
            ..endDate = _selectedAd!.endDate?.toUtc()
            ..bannerDate = _selectedAd!.bannerDate?.toUtc(),
        ),
      );
      _showSnack('Ad activated.');
      await _refresh();
    } catch (error) {
      _showSnack('Failed to activate ad: $error');
    }
  }

  Future<void> _deactivateAd() async {
    if (_selectedAd?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getAdsApi().adsAdIdDeactivatePost(adId: _selectedAd!.id!);
      _showSnack('Ad deactivated.');
      await _refresh();
    } catch (error) {
      _showSnack('Failed to deactivate ad: $error');
    }
  }

  Future<void> _deleteAd() async {
    if (_selectedAd?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getAdsApi().adsAdIdDelete(adId: _selectedAd!.id!);
    setState(() {
      _selectedAd = null;
    });
    await _refresh();
  }

  void _showSnack(String message) {
    if (!mounted) return;
    if (message.toLowerCase().contains('failed')) {
      SomSnackBars.error(context, message);
    } else {
      SomSnackBars.success(context, message);
    }
  }

  Widget _buildBulkSummary() {
    final count = _bulkSelection.length;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(
            'Bulk selection',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text('$count ad${count == 1 ? '' : 's'} selected'),
          const SizedBox(height: 12),
          InlineMessage(
            message: count == 0
                ? 'Select ads to enable bulk actions.'
                : 'Use the toolbar to delete the selected ads.',
            type: InlineMessageType.info,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    if (appStore.authorization == null) {
      return AppBody(
        contextMenu: AppToolbar(title: const Text('Ads')),
        leftSplit: const EmptyState(
          asset: SomAssets.illustrationStateNoConnection,
          title: 'Login required',
          message: 'Please log in to view ads.',
        ),
        rightSplit: const SizedBox.shrink(),
      );
    }

    return FutureBuilder<List<Ad>>(
      future: _adsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppBody(
            contextMenu: _buildContextMenu(appStore),
            leftSplit: const Center(child: CircularProgressIndicator()),
            rightSplit: const SizedBox.shrink(),
          );
        }
        if (snapshot.hasError) {
          return AppBody(
            contextMenu: _buildContextMenu(appStore),
            leftSplit: InlineMessage(
              message: 'Failed to load ads: ${snapshot.error}',
              type: InlineMessageType.error,
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }

        final ads = snapshot.data ?? const [];
        final isBuyer = appStore.authorization?.isBuyer == true;

        return AppBody(
          contextMenu: _buildContextMenu(appStore),
          leftSplit: Column(
            children: [
              AdsFilters(
                branches: _branches,
                branchIdFilter: _filterBranchId,
                statusFilter: _filterStatus,
                typeFilter: _filterType,
                onBranchIdChanged: (v) => setState(() => _filterBranchId = v),
                onStatusChanged: (v) => setState(() => _filterStatus = v),
                onTypeChanged: (v) => setState(() => _filterType = v),
                onClear: _clearFilters,
                onApply: _refresh,
              ),
              const Divider(height: 1),
              Expanded(
                child: AdsList(
                  ads: ads,
                  selectedAdId: _bulkMode ? null : _selectedAd?.id,
                  typeFilter: _filterType,
                  isBuyer: isBuyer,
                  onAdSelected: _selectAd,
                  selectionMode: _bulkMode,
                  selectedAdIds: _bulkSelection,
                  onToggleSelection: _toggleBulkSelection,
                  onEnterSelectionMode: _enterBulkMode,
                ),
              ),
            ],
          ),
          rightSplit: isBuyer
              ? AdsBuyerView(ads: ads)
              : _bulkMode
                  ? _buildBulkSummary()
                  : _showCreateForm
                      ? AdsCreateForm(
                          branches: _branches,
                          onSubmit: _createAd,
                          isConsultant: appStore.authorization?.isConsultant == true,
                          providerCompanies: _providerCompanies,
                        )
                      : _selectedAd != null
                          ? AdsEditForm(
                              ad: _selectedAd!,
                              onUpdate: _updateAd,
                              onActivate: _activateAd,
                              onDeactivate: _deactivateAd,
                              onDelete: _deleteAd,
                            )
                          : const NoAdSelected(),
        );
      },
    );
  }

  Widget _buildContextMenu(Application appStore) {
    final canManage = appStore.authorization?.isBuyer != true;
    return AppToolbar(
      title: const Text('SOM Ads'),
      actions: [
        if (canManage && _bulkMode) ...[
          OutlinedButton(
            onPressed: _bulkSelection.isEmpty ? null : _bulkDeleteSelected,
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              side: BorderSide(color: Theme.of(context).colorScheme.error),
            ),
            child: Text('Delete (${_bulkSelection.length})'),
          ),
          TextButton(
            onPressed: _exitBulkMode,
            child: const Text('Done'),
          ),
        ] else if (canManage) ...[
          FilledButton.tonal(
            onPressed: () =>
                setState(() => _showCreateForm = !_showCreateForm),
            child: Text(_showCreateForm ? 'Close form' : 'Create ad'),
          ),
          TextButton(
            onPressed: () => _enterBulkMode(),
            child: const Text('Bulk actions'),
          ),
        ],
        StatusLegendButton(
          title: 'Ad status',
          items: const [
            StatusLegendItem(
              label: 'Active',
              status: 'active',
              type: StatusType.ad,
            ),
            StatusLegendItem(
              label: 'Draft',
              status: 'draft',
              type: StatusType.ad,
            ),
            StatusLegendItem(
              label: 'Expired',
              status: 'expired',
              type: StatusType.ad,
            ),
          ],
        ),
      ],
    );
  }
}
