import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

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
typedef LoadProvidersCallback = Future<ProviderSearchResult> Function({
  required int limit,
  required int offset,
  String? search,
  String? branchId,
  String? companySize,
  String? providerType,
  String? zipPrefix,
});

/// Dialog for selecting providers to assign to an inquiry.
///
/// Supports pagination and search for handling large provider datasets (125k+).
class ProviderSelectionDialog extends StatefulWidget {
  const ProviderSelectionDialog({
    Key? key,
    required this.branches,
    required this.maxProviders,
    required this.loadProviders,
  }) : super(key: key);

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
    final id = provider.companyId ?? 'unknown';
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
    return AlertDialog(
      title: Row(
        children: [
          const Expanded(child: Text('Select providers')),
          Text(
            '${_selectedIds.length} selected',
            style: Theme.of(context).textTheme.bodySmall,
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
            const SizedBox(height: 8),
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
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedIds.isEmpty || _overLimit
              ? null
              : () {
                  Navigator.of(context).pop(_selectedProviders.values.toList());
                },
          child: Text('Assign (${_selectedIds.length})'),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search by company name...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _onSearchSubmitted('');
                },
              )
            : null,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onSubmitted: _onSearchSubmitted,
      onChanged: (value) {
        setState(() {}); // Update UI for clear button visibility
      },
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          DropdownButton<String>(
            hint: const Text('Branch'),
            value: _branchId,
            items: widget.branches
                .map((branch) => DropdownMenuItem(
                      value: branch.id,
                      child: Text(branch.name ?? branch.id ?? '-'),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() => _branchId = value);
              _loadInitialProviders();
            },
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            hint: const Text('Provider type'),
            value: _providerType,
            items: const [
              DropdownMenuItem(value: 'haendler', child: Text('Händler')),
              DropdownMenuItem(value: 'hersteller', child: Text('Hersteller')),
              DropdownMenuItem(
                  value: 'dienstleister', child: Text('Dienstleister')),
              DropdownMenuItem(
                  value: 'grosshaendler', child: Text('Großhändler')),
            ],
            onChanged: (value) {
              setState(() => _providerType = value);
              _loadInitialProviders();
            },
          ),
          const SizedBox(width: 8),
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
            onChanged: (value) {
              setState(() => _companySize = value);
              _loadInitialProviders();
            },
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'ZIP prefix',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              onChanged: (value) {
                setState(
                    () => _zipPrefix = value.trim().isEmpty ? null : value.trim());
              },
              onSubmitted: (_) => _loadInitialProviders(),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _branchId = null;
                _companySize = null;
                _providerType = null;
                _zipPrefix = null;
                _search = null;
                _searchController.clear();
              });
              _loadInitialProviders();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
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
            ElevatedButton(
              onPressed: _loadInitialProviders,
              child: const Text('Retry'),
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
        final id = provider.companyId ?? 'unknown';
        final checked = _selectedIds.contains(id);

        return CheckboxListTile(
          value: checked,
          onChanged: (_) => _toggleSelection(provider),
          title: Text(provider.companyName ?? id),
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
