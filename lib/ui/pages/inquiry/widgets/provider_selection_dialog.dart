import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:openapi/openapi.dart';
import 'package:som/ui/theme/som_assets.dart';
import '../../../domain/model/forms/som_drop_down.dart';
import '../../../domain/model/forms/som_text_input.dart';
import '../../../widgets/design_system/som_button.dart';

/// Result of a paginated provider search.
class ProviderSearchResult {
  const ProviderSearchResult({
    required this.providers,
    required this.totalCount,
    required this.hasMore,
  });

  final List<ProviderSummary> providers;
  final int totalCount;
  final bool hasMore;
}

/// Callback type for loading providers with pagination.
typedef LoadProvidersCallback =
    Future<ProviderSearchResult> Function({
      required int limit,
      required int offset,
      String? search,
      String? branchId,
      String? categoryId,
      String? companySize,
      String? providerType,
      String? zipPrefix,
    });

/// Dialog for selecting providers to assign to an inquiry.
///
/// Supports pagination and search for handling large provider datasets (125k+).
class ProviderSelectionDialog extends StatefulWidget {
  const ProviderSelectionDialog({
    super.key,
    required this.branches,
    required this.maxProviders,
    required this.loadProviders,
  });

  final List<Branch> branches;
  final int maxProviders;
  final LoadProvidersCallback loadProviders;

  /// Shows the dialog and returns selected providers.
  static Future<List<ProviderSummary>?> show({
    required BuildContext context,
    required List<Branch> branches,
    required int maxProviders,
    required LoadProvidersCallback loadProviders,
  }) {
    return showDialog<List<ProviderSummary>>(
      context: context,
      builder: (context) => ProviderSelectionDialog(
        branches: branches,
        maxProviders: maxProviders,
        loadProviders: loadProviders,
      ),
    );
  }

  @override
  State<ProviderSelectionDialog> createState() =>
      _ProviderSelectionDialogState();
}

class _ProviderSelectionDialogState extends State<ProviderSelectionDialog> {
  static const _pageSize = 50;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  // Filter state
  String? _branchId;
  String? _categoryId;
  String? _companySize;
  String? _providerType;
  String? _zipPrefix;
  String? _search;

  // Pagination state
  List<ProviderSummary> _providers = const [];
  int _totalCount = 0;
  int _currentOffset = 0;
  bool _hasMore = true;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;

  // Selection state
  final Set<String> _selectedIds = {};
  final Map<String, ProviderSummary> _selectedProviders = {};

  bool get _overLimit =>
      widget.maxProviders > 0 && _selectedIds.length > widget.maxProviders;

  List<Category> get _allCategories => widget.branches
      .expand((branch) => branch.categories?.toList() ?? const <Category>[])
      .where((category) => category.status != 'declined')
      .toList();

  List<Category> get _categoryOptions {
    if (_branchId == null) {
      return _allCategories;
    }
    final branch = widget.branches.firstWhere(
      (b) => b.id == _branchId,
      orElse: () => Branch(),
    );
    return (branch.categories?.toList() ?? const <Category>[])
        .where((category) => category.status != 'declined')
        .toList();
  }

  String _categoryLabel(String id) {
    String? name;
    String? branchName;
    for (final branch in widget.branches) {
      for (final category
          in branch.categories?.toList() ?? const <Category>[]) {
        if (category.id == id) {
          name = category.name;
          branchName = branch.name;
          break;
        }
      }
      if (name != null) {
        break;
      }
    }
    final label = name ?? id;
    if (branchName == null || branchName.isEmpty) {
      return label;
    }
    return '$branchName — $label';
  }

  BoxConstraints get _filterPopupConstraints =>
      const BoxConstraints(minWidth: 240, maxWidth: 360, maxHeight: 360);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialProviders();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMoreProviders();
    }
  }

  Future<void> _loadInitialProviders() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _providers = const [];
      _currentOffset = 0;
      _hasMore = true;
    });

    try {
      final result = await widget.loadProviders(
        limit: _pageSize,
        offset: 0,
        search: _search,
        branchId: _branchId,
        categoryId: _categoryId,
        companySize: _companySize,
        providerType: _providerType,
        zipPrefix: _zipPrefix,
      );

      setState(() {
        _providers = result.providers;
        _totalCount = result.totalCount;
        _hasMore = result.hasMore;
        _currentOffset = _providers.length;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _loadMoreProviders() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final result = await widget.loadProviders(
        limit: _pageSize,
        offset: _currentOffset,
        search: _search,
        branchId: _branchId,
        categoryId: _categoryId,
        companySize: _companySize,
        providerType: _providerType,
        zipPrefix: _zipPrefix,
      );

      setState(() {
        _providers = [..._providers, ...result.providers];
        _totalCount = result.totalCount;
        _hasMore = result.hasMore;
        _currentOffset = _providers.length;
        _isLoadingMore = false;
      });
    } catch (error) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      _search = value.trim().isEmpty ? null : value.trim();
    });
    _loadInitialProviders();
  }

  void _toggleSelection(ProviderSummary provider) {
    final id = provider.companyId;
    if (id == null || id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Provider is missing a company ID.')),
      );
      return;
    }
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        _selectedProviders.remove(id);
      } else {
        _selectedIds.add(id);
        _selectedProviders[id] = provider;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedLabel = widget.maxProviders > 0
        ? '${_selectedIds.length}/${widget.maxProviders} selected'
        : '${_selectedIds.length} selected';
    return AlertDialog(
      title: Row(
        children: [
          const Expanded(child: Text('Select providers')),
          Text(
            selectedLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _overLimit ? Colors.orangeAccent : null,
              fontWeight: _overLimit ? FontWeight.w600 : null,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 700,
        height: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 4),
            _buildFilters(),
            const SizedBox(height: 8),
            if (_overLimit)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Selection exceeds allowed providers (${widget.maxProviders}).',
                  style: const TextStyle(color: Colors.orangeAccent),
                ),
              ),
            Text(
              '$_totalCount providers found',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildProvidersList()),
          ],
        ),
      ),
      actions: [
        SomButton(
          onPressed: () => Navigator.of(context).pop(),
          text: 'Cancel',
          type: SomButtonType.ghost,
        ),
        SomButton(
          onPressed: _selectedIds.isEmpty || _overLimit
              ? null
              : () {
                  Navigator.of(context).pop(_selectedProviders.values.toList());
                },
          text: 'Assign (${_selectedIds.length})',
          type: SomButtonType.primary,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SomTextInput(
      controller: _searchController,
      hint: 'Search by company name...',
      iconAsset: SomAssets.iconSearch,
      onFieldSubmitted: _onSearchSubmitted,
      onChanged: (value) {
        setState(() {}); // Update UI for clear button visibility
      },
    );
  }

  Widget _buildFilters() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 640;
        final popupMode = isCompact
            ? PopupMode.modalBottomSheet
            : PopupMode.menu;
        final popupConstraints = isCompact ? null : _filterPopupConstraints;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Filters', style: Theme.of(context).textTheme.bodySmall),
                const Spacer(),
                SomButton(
                  onPressed: () {
                    setState(() {
                      _branchId = null;
                      _categoryId = null;
                      _companySize = null;
                      _providerType = null;
                      _zipPrefix = null;
                      _search = null;
                      _searchController.clear();
                    });
                    _loadInitialProviders();
                  },
                  text: 'Clear filters',
                  type: SomButtonType.ghost,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                SizedBox(
                  width: 220,
                  child: SomDropDown<String>(
                    hint: 'Branch',
                    value: _branchId,
                    items: widget.branches.map((b) => b.id!).toList(),
                    itemAsString: (id) =>
                        widget.branches.firstWhere((b) => b.id == id).name ??
                        id,
                    popupMode: popupMode,
                    popupConstraints: popupConstraints,
                    onChanged: (value) {
                      setState(() {
                        _branchId = value;
                        _categoryId = null;
                      });
                      _loadInitialProviders();
                    },
                  ),
                ),
                SizedBox(
                  width: 240,
                  child: SomDropDown<String>(
                    hint: 'Category',
                    value: _categoryId,
                    items: _categoryOptions
                        .map((category) => category.id)
                        .whereType<String>()
                        .toList(),
                    itemAsString: _categoryLabel,
                    popupMode: popupMode,
                    popupConstraints: popupConstraints,
                    onChanged: (value) {
                      setState(() => _categoryId = value);
                      _loadInitialProviders();
                    },
                  ),
                ),
                SizedBox(
                  width: 190,
                  child: SomDropDown<String>(
                    hint: 'Provider type',
                    value: _providerType,
                    items: const [
                      'haendler',
                      'hersteller',
                      'dienstleister',
                      'grosshaendler',
                    ],
                    itemAsString: (String s) {
                      switch (s) {
                        case 'haendler':
                          return 'Händler';
                        case 'hersteller':
                          return 'Hersteller';
                        case 'dienstleister':
                          return 'Dienstleister';
                        case 'grosshaendler':
                          return 'Großhändler';
                        default:
                          return s;
                      }
                    },
                    popupMode: popupMode,
                    popupConstraints: popupConstraints,
                    onChanged: (value) {
                      setState(() => _providerType = value);
                      _loadInitialProviders();
                    },
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: SomDropDown<String>(
                    hint: 'Company size',
                    value: _companySize,
                    items: const [
                      '0-10',
                      '11-50',
                      '51-100',
                      '101-250',
                      '251-500',
                      '500+',
                    ],
                    popupMode: popupMode,
                    popupConstraints: popupConstraints,
                    onChanged: (value) {
                      setState(() => _companySize = value);
                      _loadInitialProviders();
                    },
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: SomTextInput(
                    label: 'ZIP prefix',
                    onChanged: (value) {
                      setState(
                        () => _zipPrefix = value.trim().isEmpty
                            ? null
                            : value.trim(),
                      );
                    },
                    onFieldSubmitted: (_) => _loadInitialProviders(),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildProvidersList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Failed to load providers: $_error'),
            const SizedBox(height: 16),
            SomButton(
              onPressed: _loadInitialProviders,
              text: 'Retry',
              type: SomButtonType.primary,
            ),
          ],
        ),
      );
    }

    if (_providers.isEmpty) {
      return const Center(child: Text('No providers match filters.'));
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _providers.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _providers.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final provider = _providers[index];
        final id = provider.companyId;
        final checked = id != null && _selectedIds.contains(id);

        return CheckboxListTile(
          value: checked,
          onChanged: id == null ? null : (_) => _toggleSelection(provider),
          title: Text(provider.companyName ?? (id ?? 'Unknown provider')),
          subtitle: Text(
            'Branch: ${provider.branchIds?.join(', ') ?? '-'} | '
            'Type: ${provider.providerType ?? '-'} | '
            'Size: ${provider.companySize ?? '-'}',
          ),
        );
      },
    );
  }
}
