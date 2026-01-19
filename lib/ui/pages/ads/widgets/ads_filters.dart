import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

import '../../../widgets/responsive_filter_panel.dart';

/// Widget for filtering ads by branch, status, and type.
class AdsFilters extends StatelessWidget {
  const AdsFilters({
    super.key,
    required this.branches,
    required this.branchIdFilter,
    required this.statusFilter,
    required this.typeFilter,
    required this.onBranchIdChanged,
    required this.onStatusChanged,
    required this.onTypeChanged,
    required this.onClear,
    required this.onApply,
  });

  final List<Branch> branches;
  final String? branchIdFilter;
  final String? statusFilter;
  final String? typeFilter;
  final ValueChanged<String?> onBranchIdChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onTypeChanged;
  final VoidCallback onClear;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return ResponsiveFilterPanel(
      title: 'Filters',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          DropdownButton<String>(
            hint: const Text('Branch'),
            value: branchIdFilter,
            items: branches
                .map((branch) => DropdownMenuItem(
                      value: branch.id,
                      child: Text(branch.name ?? branch.id ?? '-'),
                    ))
                .toList(),
            onChanged: onBranchIdChanged,
          ),
          DropdownButton<String>(
            hint: const Text('Status'),
            value: statusFilter,
            items: const [
              DropdownMenuItem(value: 'active', child: Text('Active')),
              DropdownMenuItem(value: 'draft', child: Text('Draft')),
              DropdownMenuItem(value: 'expired', child: Text('Expired')),
            ],
            onChanged: onStatusChanged,
          ),
          DropdownButton<String>(
            hint: const Text('Type'),
            value: typeFilter,
            items: const [
              DropdownMenuItem(value: 'normal', child: Text('Normal')),
              DropdownMenuItem(value: 'banner', child: Text('Banner')),
            ],
            onChanged: onTypeChanged,
          ),
          TextButton(
            onPressed: onClear,
            child: const Text('Clear'),
          ),
          FilledButton.tonal(
            onPressed: onApply,
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
