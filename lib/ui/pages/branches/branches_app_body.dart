import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';

import '../../domain/application/application.dart';
import '../../domain/infrastructure/supabase_realtime.dart';
import '../../domain/model/layout/app_body.dart';
import '../../utils/ui_logger.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/empty_state.dart';

class BranchesAppBody extends StatefulWidget {
  const BranchesAppBody({super.key});

  @override
  State<BranchesAppBody> createState() => _BranchesAppBodyState();
}

class _BranchesAppBodyState extends State<BranchesAppBody> {
  Future<List<Branch>>? _branchesFuture;
  Branch? _selectedBranch;
  Category? _selectedCategory;
  List<ProviderSummary> _pendingProviders = const [];
  bool _realtimeReady = false;
  late final RealtimeRefreshHandle _realtimeRefresh =
      RealtimeRefreshHandle(_handleRealtimeRefresh);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _branchesFuture ??= _loadBranches();
    _loadPendingProviders();
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
      tables: const ['branches', 'categories', 'provider_profiles'],
      channelName: 'branches-page',
    );
    _realtimeReady = true;
  }

  Future<List<Branch>> _loadBranches() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final response = await api.getBranchesApi().branchesGet();
    final list = response.data?.toList() ?? const [];
    if (_selectedBranch != null) {
      _selectedBranch = list.firstWhere(
        (branch) => branch.id == _selectedBranch!.id,
        orElse: () => list.isNotEmpty ? list.first : Branch(),
      );
    }
    return list;
  }

  Future<void> _refresh() async {
    setState(() {
      _branchesFuture = _loadBranches();
    });
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
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getProvidersApi().providersCompanyIdApprovePost(
      companyId: provider.companyId!,
      providersCompanyIdApprovePostRequest:
          ProvidersCompanyIdApprovePostRequest((b) {
            b.approvedBranchIds.clear();
            b.approvedBranchIds.addAll(provider.pendingBranchIds ?? const []);
          }),
    );
    await _loadPendingProviders();
  }

  Future<void> _declinePending(ProviderSummary provider) async {
    if (provider.companyId == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
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
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Decline'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (confirmed != true) return;
    try {
      await api.getProvidersApi().providersCompanyIdDeclinePost(
        companyId: provider.companyId!,
        subscriptionsCancelPostRequest: SubscriptionsCancelPostRequest(
          (b) => b..reason = controller.text.trim(),
        ),
      );
    } catch (error) {
      _showSnack('Failed to decline provider: $error');
    }
    await _loadPendingProviders();
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
          ElevatedButton(
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
          ElevatedButton(
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
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getBranchesApi().branchesBranchIdPut(
      branchId: branch.id!,
      branchesPostRequest: BranchesPostRequest(
        (b) => b
          ..name = name
          ..status = status,
      ),
    );
    await _refresh();
  }

  Future<void> _setCategoryStatus(Category category, String status) async {
    if (category.id == null) return;
    final name = category.name ?? '';
    if (name.isEmpty) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getBranchesApi().categoriesCategoryIdPut(
      categoryId: category.id!,
      branchesPostRequest: BranchesPostRequest(
        (b) => b
          ..name = name
          ..status = status,
      ),
    );
    await _refresh();
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
          ElevatedButton(
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
          ElevatedButton(
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
      return const AppBody(
        contextMenu: Text('Consultant access required'),
        leftSplit: Center(child: Text('Only consultants can manage branches.')),
        rightSplit: SizedBox.shrink(),
      );
    }

    return FutureBuilder<List<Branch>>(
      future: _branchesFuture,
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
              child: Text('Failed to load branches: ${snapshot.error}'),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final branches = snapshot.data ?? const [];
        if (branches.isEmpty) {
          return AppBody(
            contextMenu: AppToolbar(
              title: const Text('Branches'),
              actions: [
                FilledButton.tonal(
                  onPressed: _createBranch,
                  child: const Text('Add branch'),
                ),
              ],
            ),
            leftSplit: const EmptyState(
              asset: SomAssets.emptySearchResults,
              title: 'No branches yet',
              message: 'Create a branch to categorize inquiries',
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        return AppBody(
          contextMenu: AppToolbar(
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
            ],
          ),
          leftSplit: ListView.builder(
            itemCount: branches.length,
            itemBuilder: (context, index) {
              final branch = branches[index];
              final statusLabel = branch.status ?? 'active';
              return ListTile(
                title: Text(branch.name ?? branch.id ?? 'Branch'),
                subtitle: Text(
                  '${branch.categories?.length ?? 0} categories • $statusLabel',
                ),
                selected: _selectedBranch?.id == branch.id,
                onTap: () {
                  setState(() {
                    _selectedBranch = branch;
                    _selectedCategory = null;
                  });
                },
                trailing: statusLabel == 'pending'
                    ? Wrap(
                        spacing: 8,
                        children: [
                          TextButton(
                            onPressed: () => _setBranchStatus(branch, 'active'),
                            child: const Text('Approve'),
                          ),
                          TextButton(
                            onPressed: () =>
                                _setBranchStatus(branch, 'declined'),
                            child: const Text('Decline'),
                          ),
                        ],
                      )
                    : null,
              );
            },
          ),
          rightSplit: _selectedBranch == null
              ? const Center(child: Text('Select a branch to view categories.'))
              : Padding(
                  padding: const EdgeInsets.all(16),
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
                            return ListTile(
                              title: Text(
                                category.name ?? category.id ?? 'Category',
                              ),
                              subtitle: Text(statusLabel),
                              selected: _selectedCategory?.id == category.id,
                              onTap: () =>
                                  setState(() => _selectedCategory = category),
                              trailing: Wrap(
                                spacing: 8,
                                children: [
                                  if (statusLabel == 'pending')
                                    TextButton(
                                      onPressed: () => _setCategoryStatus(
                                        category,
                                        'active',
                                      ),
                                      child: const Text('Approve'),
                                    ),
                                  if (statusLabel == 'pending')
                                    TextButton(
                                      onPressed: () => _setCategoryStatus(
                                        category,
                                        'declined',
                                      ),
                                      child: const Text('Decline'),
                                    ),
                                  IconButton(
                                    icon: SomSvgIcon(
                                      SomAssets.iconDelete,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                    onPressed: () {
                                      _selectedCategory = category;
                                      _deleteCategory();
                                    },
                                  ),
                                ],
                              ),
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
                              final pending =
                                  provider.pendingBranchIds?.join(', ') ?? '-';
                              return Card(
                                child: ListTile(
                                  title: Text(
                                    provider.companyName ??
                                        provider.companyId ??
                                        'Provider',
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
      },
    );
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
