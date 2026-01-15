import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

/// Dialog for selecting providers to assign to an inquiry.
///
/// Allows filtering providers by branch, type, size, and ZIP prefix.
class ProviderSelectionDialog extends StatefulWidget {
  const ProviderSelectionDialog({
    Key? key,
    required this.branches,
    required this.maxProviders,
    required this.loadProviders,
  }) : super(key: key);

  final List<Branch> branches;
  final int maxProviders;
  final Future<List<ProviderSummary>> Function({
    String? branchId,
    String? companySize,
    String? providerType,
    String? zipPrefix,
  }) loadProviders;

  /// Shows the dialog and returns selected providers.
  static Future<List<ProviderSummary>?> show({
    required BuildContext context,
    required List<Branch> branches,
    required int maxProviders,
    required Future<List<ProviderSummary>> Function({
      String? branchId,
      String? companySize,
      String? providerType,
      String? zipPrefix,
    }) loadProviders,
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
  String? _branchId;
  String? _companySize;
  String? _providerType;
  String? _zipPrefix;
  final Set<String> _selected = {};

  bool get _overLimit =>
      widget.maxProviders > 0 && _selected.length > widget.maxProviders;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select providers'),
      content: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilters(),
            const SizedBox(height: 12),
            if (_overLimit)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Selection exceeds allowed providers (${widget.maxProviders}).',
                  style: const TextStyle(color: Colors.orangeAccent),
                ),
              ),
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
          onPressed: _selected.isEmpty || _overLimit
              ? null
              : () {
                  Navigator.of(context).pop(
                    _selected
                        .map((id) => ProviderSummary((b) => b..companyId = id))
                        .toList(),
                  );
                },
          child: const Text('Assign'),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
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
          onChanged: (value) => setState(() => _branchId = value),
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
        SizedBox(
          width: 120,
          child: TextField(
            decoration: const InputDecoration(labelText: 'ZIP prefix'),
            onChanged: (value) =>
                setState(() => _zipPrefix = value.trim().isEmpty ? null : value.trim()),
          ),
        ),
        TextButton(
          onPressed: () => setState(() {}),
          child: const Text('Refresh'),
        ),
      ],
    );
  }

  Widget _buildProvidersList() {
    return FutureBuilder<List<ProviderSummary>>(
      future: widget.loadProviders(
        branchId: _branchId,
        companySize: _companySize,
        providerType: _providerType,
        zipPrefix: _zipPrefix,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Failed to load providers: ${snapshot.error}');
        }
        final providers = snapshot.data ?? const [];
        if (providers.isEmpty) {
          return const Text('No providers match filters.');
        }
        return ListView.builder(
          itemCount: providers.length,
          itemBuilder: (context, index) {
            final provider = providers[index];
            final id = provider.companyId ?? 'unknown';
            final checked = _selected.contains(id);
            return CheckboxListTile(
              value: checked,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selected.add(id);
                  } else {
                    _selected.remove(id);
                  }
                });
              },
              title: Text(provider.companyName ?? id),
              subtitle: Text(
                'Branch: ${provider.branchIds?.join(', ') ?? '-'} | '
                'Type: ${provider.providerType ?? '-'} | '
                'Size: ${provider.companySize ?? '-'}',
              ),
            );
          },
        );
      },
    );
  }
}
