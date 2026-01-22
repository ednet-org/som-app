import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:built_value/serializer.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';

import '../../domain/application/application.dart';
import '../../domain/infrastructure/supabase_realtime.dart';
import '../../domain/model/layout/app_body.dart';
import '../../theme/tokens.dart';
import '../../utils/formatters.dart';
import '../../utils/ui_logger.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/inline_message.dart';
import '../../widgets/snackbars.dart';
import '../../widgets/selectable_list_view.dart';
import '../../widgets/som_list_tile.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/status_legend.dart';

class BranchesAppBody extends StatefulWidget {
  const BranchesAppBody({super.key});

  @override
  State<BranchesAppBody> createState() => _BranchesAppBodyState();
}

class _BranchesAppBodyState extends State<BranchesAppBody> {
  // Pagination state
  List<Branch> _branches = [];
  int _totalBranches = 0;
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  static const int _pageSize = 50;

  final ScrollController _scrollController = ScrollController();

  Branch? _selectedBranch;
  Category? _selectedCategory;
  List<ProviderSummary> _pendingProviders = const [];
  bool _realtimeReady = false;
  late final RealtimeRefreshHandle _realtimeRefresh =
      RealtimeRefreshHandle(_handleRealtimeRefresh);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_branches.isEmpty && !_isLoading) {
      _loadBranches();
    }
    _loadPendingProviders();
    _setupRealtime();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _realtimeRefresh.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreBranches();
    }
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
      tables: const ['branches', 'categories', 'provider_profiles'],
      channelName: 'branches-page',
    );
    _realtimeReady = true;
  }

  Branch _deserializeBranch(Map<String, dynamic> json, Openapi api) {
    return api.serializers.deserializeWith(Branch.serializer, json)!;
  }

  Future<void> _loadBranches({bool refresh = false}) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
      if (refresh) {
        _branches = [];
        _totalBranches = 0;
      }
    });
    try {
      final api = Provider.of<Openapi>(context, listen: false);
      // Use dio directly to pass pagination params (not in generated client)
      final response = await api.dio.get<dynamic>(
        '/branches',
        queryParameters: {'limit': _pageSize, 'offset': 0},
      );
      final data = response.data;
      List<Branch> list = [];
      if (data is List) {
        // Flat array response (backward compatible)
        list = data.map((e) => _deserializeBranch(e as Map<String, dynamic>, api)).toList();
        _totalBranches = list.length < _pageSize ? list.length : 1000;
      } else if (data is Map) {
        // Paginated response
        final mapData = data as Map<String, dynamic>;
        final items = mapData['data'] as List<dynamic>? ?? [];
        list = items.map((e) => _deserializeBranch(e as Map<String, dynamic>, api)).toList();
        _totalBranches = mapData['total'] as int? ?? list.length;
      }
      setState(() {
        _branches = list;
        _isLoading = false;
        if (_selectedBranch != null) {
          _selectedBranch = list.firstWhere(
            (branch) => branch.id == _selectedBranch!.id,
            orElse: () => list.isNotEmpty ? list.first : Branch(),
          );
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _loadMoreBranches() async {
    if (_isLoading || _branches.length >= _totalBranches) return;
    setState(() => _isLoading = true);
    try {
      final api = Provider.of<Openapi>(context, listen: false);
      final response = await api.dio.get<dynamic>(
        '/branches',
        queryParameters: {'limit': _pageSize, 'offset': _branches.length},
      );
      final data = response.data;
      List<Branch> list = [];
      if (data is List) {
        list = data.map((e) => _deserializeBranch(e as Map<String, dynamic>, api)).toList();
      } else if (data is Map) {
        final mapData = data as Map<String, dynamic>;
        final items = mapData['data'] as List<dynamic>? ?? [];
        list = items.map((e) => _deserializeBranch(e as Map<String, dynamic>, api)).toList();
      }
      setState(() {
        _branches = [..._branches, ...list];
        _isLoading = false;
        // Update total if we got less than requested (end of list)
        if (list.length < _pageSize) {
          _totalBranches = _branches.length;
        }
      });
    } catch (error) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refresh() async {
    await _loadBranches(refresh: true);
    await _loadPendingProviders();
  }

  Future<void> _loadPendingProviders() async {
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final response = await api.getProvidersApi().providersGet(
        status: 'pending',
      );
      final providers = response.data?.toList() ?? const [];
      setState(() {
        _pendingProviders = providers
            .where((p) => (p.pendingBranchIds?.isNotEmpty ?? false))
            .toList();
      });
    } catch (error, stackTrace) {
      UILogger.silentError(
        'BranchesAppBody._loadPendingProviders',
        error,
        stackTrace,
      );
    }
  }

  Future<void> _approvePending(ProviderSummary provider) async {
    if (provider.companyId == null) return;
    // Optimistic update: remove from list immediately
    final previousList = List<ProviderSummary>.from(_pendingProviders);
    setState(() {
      _pendingProviders = _pendingProviders
          .where((p) => p.companyId != provider.companyId)
          .toList();
    });
    try {
      final api = Provider.of<Openapi>(context, listen: false);
      await api.getProvidersApi().providersCompanyIdApprovePost(
        companyId: provider.companyId!,
        providersCompanyIdApprovePostRequest:
            ProvidersCompanyIdApprovePostRequest((b) {
              b.approvedBranchIds.clear();
              b.approvedBranchIds.addAll(provider.pendingBranchIds ?? const []);
            }),
      );
      _showSnack('Provider approved successfully');
    } catch (error) {
      // Revert optimistic update on failure
      setState(() {
        _pendingProviders = previousList;
      });
      _showSnack('Failed to approve provider: $error');
    }
  }

  Future<void> _declinePending(ProviderSummary provider) async {
    if (provider.companyId == null) return;
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decline provider'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Rejection reason (optional)',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Decline'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (confirmed != true) return;
    // Optimistic update: remove from list immediately
    final previousList = List<ProviderSummary>.from(_pendingProviders);
    setState(() {
      _pendingProviders = _pendingProviders
          .where((p) => p.companyId != provider.companyId)
          .toList();
    });
    try {
      final api = Provider.of<Openapi>(context, listen: false);
      await api.getProvidersApi().providersCompanyIdDeclinePost(
        companyId: provider.companyId!,
        subscriptionsCancelPostRequest: SubscriptionsCancelPostRequest(
          (b) => b..reason = controller.text.trim(),
        ),
      );
      _showSnack('Provider declined');
    } catch (error) {
      // Revert optimistic update on failure
      setState(() {
        _pendingProviders = previousList;
      });
      _showSnack('Failed to decline provider: $error');
    }
  }

  Future<void> _createBranch() async {
    final controller = TextEditingController();
    final created = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create branch'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Branch name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (created != true) return;
    final name = controller.text.trim();
    if (name.isEmpty) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getBranchesApi().branchesPost(
      branchesPostRequest: BranchesPostRequest(
        (b) => b
          ..name = name
          ..status = 'active',
      ),
    );
    await _refresh();
  }

  Future<void> _renameBranch() async {
    if (_selectedBranch?.id == null) return;
    final controller = TextEditingController(text: _selectedBranch?.name ?? '');
    final renamed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename branch'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Branch name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (renamed != true) return;
    final name = controller.text.trim();
    if (name.isEmpty) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getBranchesApi().branchesBranchIdPut(
      branchId: _selectedBranch!.id!,
      branchesPostRequest: BranchesPostRequest((b) => b..name = name),
    );
    await _refresh();
  }

  Future<void> _setBranchStatus(Branch branch, String status) async {
    if (branch.id == null) return;
    final name = branch.name ?? '';
    if (name.isEmpty) return;
    // Optimistic update: update local branch status immediately
    final previousBranches = List<Branch>.from(_branches);
    final updatedBranches = _branches.map((b) {
      if (b.id == branch.id) {
        return b.rebuild((builder) => builder.status = status);
      }
      return b;
    }).toList();
    setState(() {
      _branches = updatedBranches;
    });
    try {
      final api = Provider.of<Openapi>(context, listen: false);
      await api.getBranchesApi().branchesBranchIdPut(
        branchId: branch.id!,
        branchesPostRequest: BranchesPostRequest(
          (b) => b
            ..name = name
            ..status = status,
        ),
      );
      _showSnack('Branch ${status == 'active' ? 'approved' : 'declined'}');
    } catch (error) {
      // Revert optimistic update on failure
      setState(() {
        _branches = previousBranches;
      });
      _showSnack('Failed to update branch: $error');
    }
  }

  Future<void> _setCategoryStatus(Category category, String status) async {
    if (category.id == null) return;
    final name = category.name ?? '';
    if (name.isEmpty) return;
    // Optimistic update: update local category status immediately
    final previousBranches = List<Branch>.from(_branches);
    final updatedBranches = _branches.map((b) {
      if (b.id == _selectedBranch?.id && b.categories != null) {
        final updatedCategories = b.categories!.map((c) {
          if (c.id == category.id) {
            return c.rebuild((builder) => builder.status = status);
          }
          return c;
        }).toList();
        return b.rebuild((builder) => builder.categories.replace(updatedCategories));
      }
      return b;
    }).toList();
    setState(() {
      _branches = updatedBranches;
      // Update selected branch reference
      if (_selectedBranch != null) {
        _selectedBranch = updatedBranches.firstWhere(
          (b) => b.id == _selectedBranch!.id,
          orElse: () => _selectedBranch!,
        );
      }
    });
    try {
      final api = Provider.of<Openapi>(context, listen: false);
      await api.getBranchesApi().categoriesCategoryIdPut(
        categoryId: category.id!,
        branchesPostRequest: BranchesPostRequest(
          (b) => b
            ..name = name
            ..status = status,
        ),
      );
      _showSnack('Category ${status == 'active' ? 'approved' : 'declined'}');
    } catch (error) {
      // Revert optimistic update on failure
      setState(() {
        _branches = previousBranches;
      });
      _showSnack('Failed to update category: $error');
    }
  }

  Future<void> _deleteBranch() async {
    if (_selectedBranch?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getBranchesApi().branchesBranchIdDelete(
      branchId: _selectedBranch!.id!,
    );
    setState(() {
      _selectedBranch = null;
    });
    await _refresh();
  }

  Future<void> _createCategory() async {
    if (_selectedBranch?.id == null) return;
    final controller = TextEditingController();
    final created = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Category name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (created != true) return;
    final name = controller.text.trim();
    if (name.isEmpty) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getBranchesApi().branchesBranchIdCategoriesPost(
      branchId: _selectedBranch!.id!,
      branchesPostRequest: BranchesPostRequest(
        (b) => b
          ..name = name
          ..status = 'active',
      ),
    );
    await _refresh();
  }

  Future<void> _renameCategory() async {
    if (_selectedCategory?.id == null) return;
    final controller = TextEditingController(
      text: _selectedCategory?.name ?? '',
    );
    final renamed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Category name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (renamed != true) return;
    final name = controller.text.trim();
    if (name.isEmpty) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getBranchesApi().categoriesCategoryIdPut(
      categoryId: _selectedCategory!.id!,
      branchesPostRequest: BranchesPostRequest((b) => b..name = name),
    );
    await _refresh();
  }

  Future<void> _deleteCategory() async {
    if (_selectedCategory?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getBranchesApi().categoriesCategoryIdDelete(
      categoryId: _selectedCategory!.id!,
    );
    setState(() {
      _selectedCategory = null;
    });
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    if (appStore.authorization == null ||
        appStore.authorization?.isConsultant != true) {
      return AppBody(
        contextMenu: AppToolbar(title: const Text('Branches')),
        leftSplit: const EmptyState(
          asset: SomAssets.illustrationStateNoConnection,
          title: 'Consultant access required',
          message: 'Only consultants can manage branches.',
        ),
        rightSplit: const SizedBox.shrink(),
      );
    }

    // Initial loading state
    if (_branches.isEmpty && _isLoading) {
      return AppBody(
        contextMenu: _buildToolbar(),
        leftSplit: const Center(child: CircularProgressIndicator()),
        rightSplit: const SizedBox.shrink(),
      );
    }

    // Error state
    if (_hasError && _branches.isEmpty) {
      return AppBody(
        contextMenu: _buildToolbar(),
        leftSplit: Center(
          child: InlineMessage(
            message: 'Failed to load branches: $_errorMessage',
            type: InlineMessageType.error,
          ),
        ),
        rightSplit: const SizedBox.shrink(),
      );
    }

    // Empty state
    if (_branches.isEmpty && !_isLoading) {
      return AppBody(
        contextMenu: _buildToolbar(),
        leftSplit: const EmptyState(
          asset: SomAssets.emptySearchResults,
          title: 'No branches yet',
          message: 'Create a branch to categorize inquiries',
        ),
        rightSplit: const SizedBox.shrink(),
      );
    }

    // Main content with infinite scroll
    return AppBody(
      contextMenu: _buildToolbar(),
      leftSplit: Column(
        children: [
          // Progress indicator showing load status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Showing ${_branches.length} of $_totalBranches branches',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _branches.length + (_isLoading ? 1 : 0),
              cacheExtent: 500,
              itemBuilder: (context, index) {
                // Loading indicator at the end
                if (index >= _branches.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final branch = _branches[index];
                final isSelected = branch.id == _selectedBranch?.id;
                final statusLabel = branch.status ?? 'active';
                return Column(
                  children: [
                    SomListTile(
                      selected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedBranch = branch;
                          _selectedCategory = null;
                        });
                      },
                      title: Text(
                        branch.name ??
                            'Branch ${SomFormatters.shortId(branch.id)}',
                      ),
                      subtitle: Text(
                        '${branch.categories?.length ?? 0} categories • ${SomFormatters.capitalize(statusLabel)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StatusBadge.branch(
                            status: statusLabel,
                            compact: false,
                            showIcon: false,
                          ),
                          if (statusLabel == 'pending') ...[
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () =>
                                  _setBranchStatus(branch, 'active'),
                              child: const Text('Approve'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  _setBranchStatus(branch, 'declined'),
                              child: const Text('Decline'),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (index != _branches.length - 1)
                      const Divider(height: 1),
                  ],
                );
              },
            ),
          ),
        ],
      ),
          rightSplit: _selectedBranch == null
              ? const EmptyState(
                  asset: SomAssets.emptySearchResults,
                  title: 'Select a branch',
                  message: 'Choose a branch to view its categories.',
                )
              : Padding(
                  padding: const EdgeInsets.all(SomSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedBranch!.name ?? 'Branch',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _selectedBranch!.categories?.length ?? 0,
                          itemBuilder: (context, index) {
                            final category =
                                _selectedBranch!.categories![index];
                            final statusLabel = category.status ?? 'active';
                            return Column(
                              children: [
                                SomListTile(
                                  selected:
                                      _selectedCategory?.id == category.id,
                                  onTap: () => setState(
                                    () => _selectedCategory = category,
                                  ),
                                  title: Text(
                                    category.name ??
                                        'Category ${SomFormatters.shortId(category.id)}',
                                  ),
                                  subtitle: Text(
                                    SomFormatters.capitalize(statusLabel),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      StatusBadge.branch(
                                        status: statusLabel,
                                        compact: false,
                                        showIcon: false,
                                      ),
                                      if (statusLabel == 'pending') ...[
                                        const SizedBox(width: 8),
                                        TextButton(
                                          onPressed: () =>
                                              _setCategoryStatus(
                                            category,
                                            'active',
                                          ),
                                          child: const Text('Approve'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              _setCategoryStatus(
                                            category,
                                            'declined',
                                          ),
                                          child: const Text('Decline'),
                                        ),
                                      ],
                                      IconButton(
                                        tooltip: 'Delete category',
                                        icon: SomSvgIcon(
                                          SomAssets.iconDelete,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                        onPressed: () {
                                          _selectedCategory = category;
                                          _deleteCategory();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                if (index !=
                                    (_selectedBranch!.categories?.length ?? 1) -
                                        1)
                                  const Divider(height: 1),
                              ],
                            );
                          },
                        ),
                      ),
                      if (_pendingProviders.isNotEmpty) ...[
                        const Divider(height: 24),
                        Text(
                          'Pending provider approvals',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _pendingProviders.length,
                            itemBuilder: (context, index) {
                              final provider = _pendingProviders[index];
                              final pending = SomFormatters.list(
                                provider.pendingBranchIds
                                    ?.map(SomFormatters.shortId)
                                    .toList(),
                              );
                              return Card(
                                child: SomListTile(
                                  title: Text(
                                    provider.companyName ??
                                        'Provider ${SomFormatters.shortId(provider.companyId)}',
                                  ),
                                  subtitle: Text('Pending: $pending'),
                                  trailing: Wrap(
                                    spacing: 8,
                                    children: [
                                      TextButton(
                                        onPressed: () =>
                                            _approvePending(provider),
                                        child: const Text('Approve'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            _declinePending(provider),
                                        child: const Text('Decline'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildToolbar() {
    return AppToolbar(
      title: const Text('Branches'),
      actions: [
        FilledButton.tonal(
          onPressed: _createBranch,
          child: const Text('Add branch'),
        ),
        TextButton(
          onPressed: _renameBranch,
          child: const Text('Rename branch'),
        ),
        TextButton(
          onPressed: _createCategory,
          child: const Text('Add category'),
        ),
        TextButton(
          onPressed: _renameCategory,
          child: const Text('Rename category'),
        ),
        TextButton(
          onPressed: _deleteBranch,
          child: const Text('Delete branch'),
        ),
        StatusLegendButton(
          title: 'Branch status',
          items: const [
            StatusLegendItem(
              label: 'Active',
              status: 'active',
              type: StatusType.branch,
            ),
            StatusLegendItem(
              label: 'Pending',
              status: 'pending',
              type: StatusType.branch,
            ),
            StatusLegendItem(
              label: 'Declined',
              status: 'declined',
              type: StatusType.branch,
            ),
          ],
        ),
      ],
    );
  }

  void _showSnack(String message) {
    if (!mounted) return;
    if (message.toLowerCase().contains('failed') ||
        message.toLowerCase().contains('error')) {
      SomSnackBars.error(context, message);
    } else {
      SomSnackBars.success(context, message);
    }
  }
}
