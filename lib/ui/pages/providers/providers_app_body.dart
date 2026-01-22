import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/application/application.dart';
import '../../domain/infrastructure/supabase_realtime.dart';
import '../../domain/model/layout/app_body.dart';
import '../../theme/tokens.dart';
import '../../utils/formatters.dart';
import '../../utils/ui_logger.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/debounced_search_field.dart';
import '../../widgets/detail_section.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/inline_message.dart';
import '../../widgets/meta_text.dart';
import '../../widgets/snackbars.dart';
import '../../widgets/selectable_list_view.dart';
import '../../widgets/som_list_tile.dart';
import '../../widgets/design_system/som_badge.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/status_legend.dart';

const _apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:8081',
);

const _pageSize = 50;

class ProvidersAppBody extends StatefulWidget {
  const ProvidersAppBody({super.key});

  @override
  State<ProvidersAppBody> createState() => _ProvidersAppBodyState();
}

class _ProvidersAppBodyState extends State<ProvidersAppBody> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<ProviderSummary> _providers = const [];
  ProviderSummary? _selected;
  bool _bulkMode = false;
  final Set<String> _bulkSelection = {};

  // Pagination state
  int _totalCount = 0;
  int _currentOffset = 0;
  bool _hasMore = true;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;

  // Filter state
  String? _branchId;
  String? _companySize;
  String? _providerType;
  String? _zipPrefix;
  String? _status;
  String? _claimed;
  String? _search;

  List<Branch> _branches = const [];
  bool _realtimeReady = false;
  late final RealtimeRefreshHandle _realtimeRefresh = RealtimeRefreshHandle(
    _handleRealtimeRefresh,
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _realtimeRefresh.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_providers.isEmpty && !_isLoading) {
      _loadInitialProviders();
      _loadBranches();
    }
    _setupRealtime();
  }

  void _handleRealtimeRefresh() {
    if (!mounted) return;
    _loadInitialProviders();
    _loadBranches();
  }

  void _setupRealtime() {
    if (_realtimeReady) return;
    final appStore = Provider.of<Application>(context, listen: false);
    SupabaseRealtime.setAuth(appStore.authorization?.token);
    _realtimeRefresh.subscribe(
      tables: const ['provider_profiles', 'branches', 'categories'],
      channelName: 'providers-page',
    );
    _realtimeReady = true;
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMoreProviders();
    }
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

  Future<void> _loadInitialProviders() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _providers = const [];
      _selected = null; // Clear selection when list is reset (filter/search change)
      _currentOffset = 0;
      _hasMore = true;
    });

    try {
      final api = Provider.of<Openapi>(context, listen: false);
      final response = await api.getProvidersApi().providersGet(
        limit: _pageSize,
        offset: 0,
        search: _search,
        branchId: _branchId,
        companySize: _companySize,
        providerType: _providerType,
        zipPrefix: _zipPrefix,
        status: _status,
        claimed: _claimed,
      );

      // Parse pagination headers
      final totalCountHeader = response.headers.value('X-Total-Count');
      final hasMoreHeader = response.headers.value('X-Has-More');

      setState(() {
        _providers = response.data?.toList() ?? const [];
        _totalCount = int.tryParse(totalCountHeader ?? '') ?? _providers.length;
        _hasMore = hasMoreHeader?.toLowerCase() == 'true';
        _currentOffset = _providers.length;
        _isLoading = false;
      });
    } catch (error, stackTrace) {
      UILogger.silentError(
        'ProvidersAppBody._loadInitialProviders',
        error,
        stackTrace,
      );
      setState(() {
        _isLoading = false;
        _error = _extractError(error);
      });
    }
  }

  Future<void> _loadMoreProviders() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final api = Provider.of<Openapi>(context, listen: false);
      final response = await api.getProvidersApi().providersGet(
        limit: _pageSize,
        offset: _currentOffset,
        search: _search,
        branchId: _branchId,
        companySize: _companySize,
        providerType: _providerType,
        zipPrefix: _zipPrefix,
        status: _status,
        claimed: _claimed,
      );

      final totalCountHeader = response.headers.value('X-Total-Count');
      final hasMoreHeader = response.headers.value('X-Has-More');
      final newProviders = response.data?.toList() ?? const [];

      setState(() {
        _providers = [..._providers, ...newProviders];
        _totalCount = int.tryParse(totalCountHeader ?? '') ?? _totalCount;
        _hasMore = hasMoreHeader?.toLowerCase() == 'true';
        _currentOffset = _providers.length;
        _isLoadingMore = false;
      });
    } catch (error, stackTrace) {
      UILogger.silentError(
        'ProvidersAppBody._loadMoreProviders',
        error,
        stackTrace,
      );
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refresh() async {
    await _loadInitialProviders();
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      _search = value.trim().isEmpty ? null : value.trim();
    });
    _loadInitialProviders();
  }

  void _enterBulkMode([ProviderSummary? provider]) {
    setState(() {
      _bulkMode = true;
      _bulkSelection.clear();
      final id = provider?.companyId;
      if (id != null && id.isNotEmpty) {
        _bulkSelection.add(id);
      }
      _selected = null;
    });
  }

  void _exitBulkMode() {
    setState(() {
      _bulkMode = false;
      _bulkSelection.clear();
    });
  }

  void _toggleBulkSelection(ProviderSummary provider) {
    final id = provider.companyId;
    if (id == null || id.isEmpty) {
      SomSnackBars.warning(context, 'Provider is missing a company ID.');
      return;
    }
    setState(() {
      if (!_bulkSelection.add(id)) {
        _bulkSelection.remove(id);
      }
    });
  }

  List<ProviderSummary> _bulkSelectedProviders() {
    if (_bulkSelection.isEmpty) return const [];
    return _providers
        .where((provider) => _bulkSelection.contains(provider.companyId))
        .toList();
  }

  Future<void> _bulkApproveSelected() async {
    final providers = _bulkSelectedProviders();
    if (providers.isEmpty) return;
    int success = 0;
    int failed = 0;
    for (final provider in providers) {
      final approved = await _approveProvider(
        provider,
        showFeedback: false,
        refreshAfter: false,
      );
      if (approved) {
        success += 1;
      } else {
        failed += 1;
      }
    }
    if (!mounted) return;
    if (success > 0) {
      final suffix = failed > 0 ? ' • $failed failed' : '';
      _showSnackbar('Approved $success provider${success == 1 ? '' : 's'}$suffix.');
    } else {
      _showSnackbar('Failed to approve selected providers.');
    }
    await _refresh();
    if (mounted) _exitBulkMode();
  }

  Future<void> _bulkDeclineSelected() async {
    final providers = _bulkSelectedProviders();
    if (providers.isEmpty) return;
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decline selected providers'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Decline ${providers.length} provider(s).'),
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
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Decline'),
          ),
        ],
      ),
    );
    final reason = reasonController.text.trim();
    reasonController.dispose();
    if (confirmed != true) return;
    int success = 0;
    int failed = 0;
    for (final provider in providers) {
      final declined = await _declineProvider(
        provider,
        reason: reason,
        showFeedback: false,
        refreshAfter: false,
      );
      if (declined) {
        success += 1;
      } else {
        failed += 1;
      }
    }
    if (!mounted) return;
    if (success > 0) {
      final suffix = failed > 0 ? ' • $failed failed' : '';
      _showSnackbar('Declined $success provider${success == 1 ? '' : 's'}$suffix.');
    } else {
      _showSnackbar('Failed to decline selected providers.');
    }
    await _refresh();
    if (mounted) _exitBulkMode();
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
        if (_search != null && _search!.isNotEmpty) 'search': _search,
        'format': 'csv',
      },
    );
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!mounted) return;
    _showSnackbar(
      launched ? 'CSV export started.' : 'Failed to start CSV export.',
    );
  }

  Future<bool> _approveProvider(
    ProviderSummary provider, {
    bool showFeedback = true,
    bool refreshAfter = true,
  }) async {
    if (provider.companyId == null) return false;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final branchIdsToApprove = provider.pendingBranchIds?.toList() ?? [];
      await api.getProvidersApi().providersCompanyIdApprovePost(
        companyId: provider.companyId!,
        providersCompanyIdApprovePostRequest:
            ProvidersCompanyIdApprovePostRequest((b) {
              b.approvedBranchIds.clear();
              b.approvedBranchIds.addAll(branchIdsToApprove);
            }),
      );
      if (showFeedback) {
        _showSnackbar('Provider approved successfully.');
      }
      if (refreshAfter) {
        await _refresh();
      }
      return true;
    } on DioException catch (error) {
      if (showFeedback) {
        _showSnackbar('Failed to approve: ${_extractError(error)}');
      }
      return false;
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
            Text(
              'Company: ${provider.companyName ?? 'Provider ${SomFormatters.shortId(provider.companyId)}'}',
            ),
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
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Decline'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      reasonController.dispose();
      return;
    }
    if (!mounted) {
      reasonController.dispose();
      return;
    }
    await _declineProvider(
      provider,
      reason: reasonController.text.trim(),
    );
    reasonController.dispose();
  }

  Future<bool> _declineProvider(
    ProviderSummary provider, {
    required String reason,
    bool showFeedback = true,
    bool refreshAfter = true,
  }) async {
    if (provider.companyId == null) return false;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getProvidersApi().providersCompanyIdDeclinePost(
        companyId: provider.companyId!,
        subscriptionsCancelPostRequest: SubscriptionsCancelPostRequest(
          (b) => b..reason = reason,
        ),
      );
      if (showFeedback) {
        _showSnackbar('Provider declined.');
      }
      if (refreshAfter) {
        await _refresh();
      }
      return true;
    } on DioException catch (error) {
      if (showFeedback) {
        _showSnackbar('Failed to decline: ${_extractError(error)}');
      }
      return false;
    }
  }

  Future<void> _showEditTaxonomyDialog() async {
    final provider = _selected;
    if (provider?.companyId == null) return;
    if (_branches.isEmpty) {
      _showSnackbar('Branches not loaded yet.');
      return;
    }

    final selectedBranchIds = <String>{};
    for (final assignment in _selectedBranchAssignments) {
      final branchId = assignment.branchId;
      if (branchId != null && branchId.isNotEmpty) {
        selectedBranchIds.add(branchId);
      }
    }
    if (selectedBranchIds.isEmpty) {
      selectedBranchIds.addAll(
        provider?.branchIds?.toList().where((id) => id.isNotEmpty) ??
            const <String>[],
      );
    }
    final selectedCategoryIds = _selectedCategoryAssignments
        .map((c) => c.categoryId)
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final branchOptions = _branches
              .where((b) => (b.id ?? '').isNotEmpty)
              .toList();
          final selectedBranches = branchOptions
              .where((branch) => selectedBranchIds.contains(branch.id))
              .toList();

          return AlertDialog(
            title: const Text('Edit classification'),
            content: SizedBox(
              width: 520,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Branches',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: branchOptions.map((branch) {
                      final branchId = branch.id ?? '';
                      final selected = selectedBranchIds.contains(branchId);
                      return FilterChip(
                        label: Text(branch.name ?? branchId),
                        selected: selected,
                        onSelected: branchId.isEmpty
                            ? null
                            : (value) {
                                setDialogState(() {
                                  if (value) {
                                    selectedBranchIds.add(branchId);
                                  } else {
                                    selectedBranchIds.remove(branchId);
                                    final branchCategoryIds =
                                        (branch.categories?.toList() ??
                                                const <Category>[])
                                            .map((c) => c.id)
                                            .whereType<String>()
                                            .toSet();
                                    selectedCategoryIds.removeWhere(
                                      (id) => branchCategoryIds.contains(id),
                                    );
                                  }
                                });
                              },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  if (selectedBranchIds.isEmpty)
                    const Text(
                      'Select at least one branch to choose categories.',
                    )
                  else
                    SizedBox(
                      height: 240,
                      child: ListView(
                        children: [
                          for (final branch in selectedBranches)
                            for (final category
                                in (branch.categories?.toList() ??
                                        const <Category>[])
                                    .where((c) => c.status != 'declined'))
                              CheckboxListTile(
                                value: selectedCategoryIds.contains(
                                  category.id ?? '',
                                ),
                                title: Text(
                                  '${branch.name ?? SomFormatters.shortId(branch.id)} — '
                                  '${category.name ?? SomFormatters.shortId(category.id)}',
                                ),
                                onChanged: (checked) {
                                  final id = category.id ?? '';
                                  if (id.isEmpty) return;
                                  setDialogState(() {
                                    if (checked == true) {
                                      selectedCategoryIds.add(id);
                                    } else {
                                      selectedCategoryIds.remove(id);
                                    }
                                  });
                                },
                              ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  const Text(
                    'Saving marks the classification as manual and removes AI labels.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );

    if (confirmed != true || !mounted) return;

    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final validCategoryIds = <String>{};
      for (final branch in _branches) {
        final branchId = branch.id;
        if (branchId == null || branchId.isEmpty) continue;
        if (!selectedBranchIds.contains(branchId)) continue;
        validCategoryIds.addAll(
          (branch.categories?.toList() ?? const <Category>[])
              .map((c) => c.id)
              .whereType<String>(),
        );
      }
      final filteredCategoryIds = selectedCategoryIds
          .where((id) => validCategoryIds.contains(id))
          .toList();
      await api.getProvidersApi().providersCompanyIdTaxonomyPut(
        companyId: provider!.companyId!,
        providersCompanyIdTaxonomyPutRequest:
            ProvidersCompanyIdTaxonomyPutRequest((b) {
              b.branchIds.replace(selectedBranchIds.toList());
              b.categoryIds.replace(filteredCategoryIds);
            }),
      );
      _showSnackbar('Classification updated.');
      await _loadInitialProviders();
      if (!mounted) return;
      // Re-select the provider from fresh data if it still exists in filtered list
      final refreshedProvider = _providers.cast<ProviderSummary?>().firstWhere(
        (p) => p?.companyId == provider.companyId,
        orElse: () => null,
      );
      if (refreshedProvider != null) {
        setState(() {
          _selected = refreshedProvider;
        });
      }
    } on DioException catch (error) {
      _showSnackbar('Failed to update: ${_extractError(error)}');
    }
  }

  void _showSnackbar(String message) {
    if (!mounted) return;
    final lower = message.toLowerCase();
    if (lower.contains('failed')) {
      SomSnackBars.error(context, message);
    } else if (lower.contains('not loaded')) {
      SomSnackBars.warning(context, message);
    } else {
      SomSnackBars.success(context, message);
    }
  }

  String _extractError(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is String) return data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      return error.message ?? 'Request failed.';
    }
    return error.toString();
  }

  bool _isAiSource(String? source) {
    if (source == null) return false;
    final normalized = source.toLowerCase().trim();
    return normalized == 'openai' || normalized == 'ai';
  }

  String _formatConfidence(num? confidence) {
    if (confidence == null) return 'AI';
    final percent = (confidence.toDouble() * 100).round();
    return 'AI $percent%';
  }

  List<CompanyBranchAssignment> get _selectedBranchAssignments =>
      _selected?.branchAssignments?.toList() ?? const [];

  List<CompanyCategoryAssignment> get _selectedCategoryAssignments =>
      _selected?.categoryAssignments?.toList() ?? const [];

  bool get _hasAiAssignments {
    for (final assignment in _selectedBranchAssignments) {
      if (_isAiSource(assignment.source_)) {
        return true;
      }
    }
    for (final assignment in _selectedCategoryAssignments) {
      if (_isAiSource(assignment.source_)) {
        return true;
      }
    }
    return false;
  }

  num? get _aiSummaryConfidence {
    num? maxConfidence;
    for (final assignment in _selectedBranchAssignments) {
      if (!_isAiSource(assignment.source_)) continue;
      final value = assignment.confidence;
      if (value == null) continue;
      if (maxConfidence == null || value > maxConfidence) {
        maxConfidence = value;
      }
    }
    for (final assignment in _selectedCategoryAssignments) {
      if (!_isAiSource(assignment.source_)) continue;
      final value = assignment.confidence;
      if (value == null) continue;
      if (maxConfidence == null || value > maxConfidence) {
        maxConfidence = value;
      }
    }
    return maxConfidence;
  }

  void _filterPendingOnly() {
    setState(() {
      _status = 'pending';
    });
    _loadInitialProviders();
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    if (appStore.authorization == null ||
        appStore.authorization?.isConsultant != true ||
        appStore.authorization?.isAdmin != true) {
      return AppBody(
        contextMenu: AppToolbar(title: const Text('Providers')),
        leftSplit: const EmptyState(
          asset: SomAssets.illustrationStateNoConnection,
          title: 'Consultant admin access required',
          message: 'Only consultant admins can manage providers.',
        ),
        rightSplit: const SizedBox.shrink(),
      );
    }

    if (_isLoading && _providers.isEmpty) {
      return AppBody(
        contextMenu: _buildToolbar(),
        leftSplit: const Center(child: CircularProgressIndicator()),
        rightSplit: const SizedBox.shrink(),
      );
    }

    if (_error != null && _providers.isEmpty) {
      return AppBody(
        contextMenu: _buildToolbar(),
        leftSplit: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InlineMessage(
                message: 'Failed to load providers: $_error',
                type: InlineMessageType.error,
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: _refresh,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        rightSplit: const SizedBox.shrink(),
      );
    }

    return AppBody(
      contextMenu: _buildToolbar(),
      leftSplit: Column(
        children: [
          _buildSearchBar(),
          _buildFilters(),
          const Divider(height: 1),
          if (_providers.isEmpty)
            const Expanded(
              child: EmptyState(
                asset: SomAssets.emptySearchResults,
                title: 'No providers found',
                message: 'Try adjusting filters or search term',
              ),
            )
          else
            Expanded(
              child: SelectableListView<ProviderSummary>(
                controller: _scrollController,
                items: _providers,
                selectedIndex: _bulkMode
                    ? null
                    : () {
                        final index = _providers.indexWhere(
                          (provider) =>
                              provider.companyId == _selected?.companyId,
                        );
                        return index < 0 ? null : index;
                      }(),
                onSelectedIndex: (index) {
                  if (_bulkMode) {
                    _toggleBulkSelection(_providers[index]);
                  } else {
                    setState(() => _selected = _providers[index]);
                  }
                },
                enableKeyboardNavigation: !_bulkMode,
                itemBuilder: (context, provider, isSelected) {
                  final index = _providers.indexOf(provider);
                  final isBulkSelected =
                      _bulkSelection.contains(provider.companyId);
                  return Column(
                    children: [
                      SomListTile(
                        selected: isSelected || isBulkSelected,
                        leading: _bulkMode
                            ? Checkbox(
                                value: isBulkSelected,
                                onChanged: provider.companyId == null
                                    ? null
                                    : (_) => _toggleBulkSelection(provider),
                              )
                            : null,
                        onTap: _bulkMode
                            ? () => _toggleBulkSelection(provider)
                            : () => setState(() => _selected = provider),
                        onLongPress: _bulkMode
                            ? null
                            : () => _enterBulkMode(provider),
                        title: Text(
                          provider.companyName ??
                              'Provider ${SomFormatters.shortId(provider.companyId)}',
                        ),
                        subtitle: Text(
                          'Type: ${provider.providerType ?? '-'} | '
                          'Size: ${provider.companySize ?? '-'}',
                        ),
                        trailing: StatusBadge.provider(
                          status: provider.status ?? 'pending',
                          compact: false,
                          showIcon: false,
                        ),
                      ),
                      if (index != _providers.length - 1)
                        const Divider(height: 1),
                      if (index == _providers.length - 1 && _hasMore)
                        _buildLoadingIndicator(),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
      rightSplit: _bulkMode
          ? _buildBulkSummary()
          : _selected == null
              ? const EmptyState(
                  asset: SomAssets.emptySearchResults,
                  title: 'Select a provider',
                  message: 'Choose a provider from the list to view details',
                )
              : _buildProviderDetails(),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(SomSpacing.sm),
      child: DebouncedSearchField(
        controller: _searchController,
        hintText: 'Search by company name...',
        onSearch: (value) {
          _onSearchSubmitted(value);
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(SomSpacing.md),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildToolbar() {
    return AppToolbar(
      title: Text('Providers ($_totalCount total)'),
      actions: [
        if (_bulkMode) ...[
          FilledButton(
            onPressed: _bulkSelection.isEmpty ? null : _bulkApproveSelected,
            child: Text('Approve (${_bulkSelection.length})'),
          ),
          OutlinedButton(
            onPressed: _bulkSelection.isEmpty ? null : _bulkDeclineSelected,
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              side: BorderSide(color: Theme.of(context).colorScheme.error),
            ),
            child: Text('Decline (${_bulkSelection.length})'),
          ),
          TextButton(
            onPressed: _exitBulkMode,
            child: const Text('Done'),
          ),
        ] else ...[
          TextButton(
            onPressed: _filterPendingOnly,
            child: const Text('Pending Approval'),
          ),
          FilledButton.tonal(
            onPressed: _exportCsv,
            child: const Text('Export CSV'),
          ),
          TextButton(
            onPressed: () => _enterBulkMode(),
            child: const Text('Bulk actions'),
          ),
        ],
        StatusLegendButton(
          title: 'Provider status',
          items: const [
            StatusLegendItem(
              label: 'Active',
              status: 'active',
              type: StatusType.provider,
            ),
            StatusLegendItem(
              label: 'Pending',
              status: 'pending',
              type: StatusType.provider,
            ),
            StatusLegendItem(
              label: 'Declined',
              status: 'declined',
              type: StatusType.provider,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProviderDetails() {
    return Padding(
      padding: const EdgeInsets.all(SomSpacing.md),
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _selected!.companyName ?? 'Provider',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              StatusBadge.provider(status: _selected!.status ?? 'pending'),
            ],
          ),
          const SizedBox(height: SomSpacing.xs),
          SomMetaText('Company ID ${SomFormatters.shortId(_selected!.companyId)}'),
          const SizedBox(height: SomSpacing.md),
          DetailSection(
            title: 'Overview',
            iconAsset: SomAssets.iconInfo,
            child: DetailGrid(
              items: [
                DetailItem(
                  label: 'Status',
                  value: SomFormatters.capitalize(_selected!.status ?? '-'),
                ),
                DetailItem(label: 'Size', value: _selected!.companySize ?? '-'),
                DetailItem(
                  label: 'Type',
                  value: SomFormatters.capitalize(_selected!.providerType),
                ),
                DetailItem(label: 'Postcode', value: _selected!.postcode ?? '-'),
                DetailItem(
                  label: 'Branches',
                  value: SomFormatters.list(
                    _selected!.branchIds
                        ?.map((id) => SomFormatters.shortId(id))
                        .toList(),
                  ),
                ),
                DetailItem(
                  label: 'Pending branches',
                  value: SomFormatters.list(
                    _selected!.pendingBranchIds
                        ?.map((id) => SomFormatters.shortId(id))
                        .toList(),
                  ),
                ),
                if (_selected!.rejectionReason != null)
                  DetailItem(
                    label: 'Rejection reason',
                    value: _selected!.rejectionReason ?? '-',
                  ),
                if (_selected!.rejectedAt != null)
                  DetailItem(
                    label: 'Rejected at',
                    value: SomFormatters.dateTime(_selected!.rejectedAt),
                    isMeta: true,
                  ),
              ],
            ),
          ),
          const SizedBox(height: SomSpacing.md),
          DetailSection(
            title: 'Classification',
            iconAsset: SomAssets.iconSettings,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (_hasAiAssignments) ...[
                      SomBadge(
                        text: _formatConfidence(_aiSummaryConfidence),
                        type: SomBadgeType.info,
                      ),
                      const SizedBox(width: 8),
                    ],
                    TextButton.icon(
                      onPressed: _showEditTaxonomyDialog,
                      icon: SomSvgIcon(
                        SomAssets.iconEdit,
                        size: SomIconSize.sm,
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      label: const Text('Edit'),
                    ),
                  ],
                ),
                const SizedBox(height: SomSpacing.sm),
                _buildClassificationSection(),
              ],
            ),
          ),
          const SizedBox(height: SomSpacing.md),
          DetailSection(
            title: 'Subscription',
            iconAsset: SomAssets.iconStatistics,
            child: DetailGrid(
              items: [
                DetailItem(
                  label: 'Plan',
                  value: SomFormatters.shortId(_selected!.subscriptionPlanId),
                  isMeta: true,
                ),
                DetailItem(
                  label: 'Payment interval',
                  value: _selected!.paymentInterval ?? '-',
                ),
              ],
            ),
          ),
          const SizedBox(height: SomSpacing.md),
          DetailSection(
            title: 'Banking',
            iconAsset: SomAssets.iconSettings,
            child: DetailGrid(
              items: [
                DetailItem(label: 'IBAN', value: _selected!.iban ?? '-'),
                DetailItem(label: 'BIC', value: _selected!.bic ?? '-'),
                DetailItem(
                  label: 'Account owner',
                  value: _selected!.accountOwner ?? '-',
                ),
                DetailItem(
                  label: 'Registration date',
                  value: SomFormatters.dateTime(_selected!.registrationDate),
                  isMeta: true,
                ),
              ],
            ),
          ),
          if (_selected!.status == 'pending' ||
              (_selected!.pendingBranchIds?.isNotEmpty ?? false)) ...[
            const SizedBox(height: SomSpacing.md),
            DetailSection(
              title: 'Approval actions',
              iconAsset: SomAssets.iconWarning,
              child: Wrap(
                spacing: SomSpacing.sm,
                runSpacing: SomSpacing.sm,
                children: [
                  FilledButton.icon(
                    onPressed: () => _approveProvider(_selected!),
                    icon: SomSvgIcon(
                      SomAssets.offerStatusAccepted,
                      size: SomIconSize.sm,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    label: const Text('Approve'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _showDeclineDialog(_selected!),
                    icon: SomSvgIcon(
                      SomAssets.offerStatusRejected,
                      size: SomIconSize.sm,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: const Text('Decline'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBulkSummary() {
    final count = _bulkSelection.length;
    return Padding(
      padding: const EdgeInsets.all(SomSpacing.md),
      child: ListView(
        children: [
          Text(
            'Bulk selection',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: SomSpacing.xs),
          SomMetaText(
            '$count provider${count == 1 ? '' : 's'} selected',
          ),
          const SizedBox(height: SomSpacing.md),
          InlineMessage(
            message: count == 0
                ? 'Select providers to enable bulk actions.'
                : 'Use the toolbar to approve or decline the selected providers.',
            type: InlineMessageType.info,
          ),
        ],
      ),
    );
  }

  Widget _buildClassificationSection() {
    final branchAssignments = _selectedBranchAssignments;
    final categoryAssignments = _selectedCategoryAssignments;

    if (branchAssignments.isEmpty && categoryAssignments.isEmpty) {
      return const Text('No classifications assigned.');
    }

    final textStyle = Theme.of(context).textTheme.bodySmall;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (branchAssignments.isNotEmpty) ...[
          Text('Branches', style: textStyle),
          const SizedBox(height: 4),
          ...branchAssignments.map(
            (assignment) => _buildAssignmentRow(
              label: assignment.branchName ?? assignment.branchId ?? '-',
              source: assignment.source_,
              confidence: assignment.confidence,
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (categoryAssignments.isNotEmpty) ...[
          Text('Categories', style: textStyle),
          const SizedBox(height: 4),
          ...categoryAssignments.map(
            (assignment) => _buildAssignmentRow(
              label: _categoryLabelForAssignment(assignment),
              source: assignment.source_,
              confidence: assignment.confidence,
            ),
          ),
        ],
      ],
    );
  }

  String _categoryLabelForAssignment(CompanyCategoryAssignment assignment) {
    final categoryLabel = assignment.categoryName ??
        SomFormatters.shortId(assignment.categoryId);
    final branchLabel =
        assignment.branchName ?? SomFormatters.shortId(assignment.branchId);
    if (branchLabel == '-' || branchLabel.isEmpty) {
      return categoryLabel;
    }
    return '$branchLabel — $categoryLabel';
  }

  Widget _buildAssignmentRow({
    required String label,
    required String? source,
    required num? confidence,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          if (_isAiSource(source))
            SomBadge(
              text: _formatConfidence(confidence),
              type: SomBadgeType.info,
            ),
        ],
      ),
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
                    .map(
                      (branch) => DropdownMenuItem(
                        value: branch.id,
                        child: Text(
                          branch.name ?? SomFormatters.shortId(branch.id),
                        ),
                      ),
                    )
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
                  DropdownMenuItem(
                    value: 'hersteller',
                    child: Text('Hersteller'),
                  ),
                  DropdownMenuItem(
                    value: 'dienstleister',
                    child: Text('Dienstleister'),
                  ),
                  DropdownMenuItem(
                    value: 'grosshaendler',
                    child: Text('Großhändler'),
                  ),
                ],
                onChanged: (value) => setState(() => _providerType = value),
              ),
              SizedBox(
                width: 120,
                child: TextField(
                  decoration: const InputDecoration(labelText: 'ZIP prefix'),
                  onChanged: (value) =>
                      setState(() => _zipPrefix = value.trim()),
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
                    _search = null;
                    _searchController.clear();
                  });
                  _loadInitialProviders();
                },
                child: const Text('Clear'),
              ),
              FilledButton.tonal(
                onPressed: _loadInitialProviders,
                child: const Text('Apply'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
