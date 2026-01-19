import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:som/ui/theme/som_assets.dart';
import '../../../domain/model/forms/som_drop_down.dart';
import '../../../domain/model/forms/som_text_input.dart';
import '../../../widgets/design_system/som_button.dart';

/// Widget for filtering inquiries by various criteria.
///
/// Displays expandable filter panel with dropdowns and date pickers.
class InquiryFilters extends StatelessWidget {
  const InquiryFilters({
    super.key,
    required this.branches,
    required this.companyUsers,
    required this.statusFilter,
    required this.branchIdFilter,
    required this.branchNameFilter,
    required this.providerTypeFilter,
    required this.providerSizeFilter,
    required this.createdFrom,
    required this.createdTo,
    required this.deadlineFrom,
    required this.deadlineTo,
    required this.editorFilter,
    required this.isAdmin,
    required this.isProvider,
    required this.onStatusChanged,
    required this.onBranchIdChanged,
    required this.onBranchNameChanged,
    required this.onProviderTypeChanged,
    required this.onProviderSizeChanged,
    required this.onCreatedFromChanged,
    required this.onCreatedToChanged,
    required this.onDeadlineFromChanged,
    required this.onDeadlineToChanged,
    required this.onEditorChanged,
    required this.onClear,
    required this.onApply,
  });

  final List<Branch> branches;
  final List<UserDto> companyUsers;
  final String? statusFilter;
  final String? branchIdFilter;
  final String? branchNameFilter;
  final String? providerTypeFilter;
  final String? providerSizeFilter;
  final DateTime? createdFrom;
  final DateTime? createdTo;
  final DateTime? deadlineFrom;
  final DateTime? deadlineTo;
  final String? editorFilter;
  final bool isAdmin;
  final bool isProvider;

  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onBranchIdChanged;
  final ValueChanged<String?> onBranchNameChanged;
  final ValueChanged<String?> onProviderTypeChanged;
  final ValueChanged<String?> onProviderSizeChanged;
  final ValueChanged<DateTime?> onCreatedFromChanged;
  final ValueChanged<DateTime?> onCreatedToChanged;
  final ValueChanged<DateTime?> onDeadlineFromChanged;
  final ValueChanged<DateTime?> onDeadlineToChanged;
  final ValueChanged<String?> onEditorChanged;
  final VoidCallback onClear;
  final VoidCallback onApply;

  List<String> get _statusOptions {
    if (isProvider) {
      return const ['open', 'offer_created', 'lost', 'won', 'ignored'];
    }
    return const ['open', 'closed', 'draft', 'expired'];
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Filters'),
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 150,
                child: SomDropDown<String>(
                  hint: 'Status',
                  value: statusFilter,
                  items: _statusOptions,
                  onChanged: onStatusChanged,
                ),
              ),
              SizedBox(
                width: 200,
                child: SomDropDown<String>(
                  hint: 'Branch',
                  value: branchIdFilter,
                  items: branches.map((b) => b.id!).toList(),
                  itemAsString: (id) => branches.firstWhere((b) => b.id == id).name ?? id,
                  onChanged: onBranchIdChanged,
                ),
              ),
              SizedBox(
                width: 160,
                child: SomTextInput(label: 'Branch (text)',
                  onChanged: (value) => onBranchNameChanged(value.trim()),
                ),
              ),
              SizedBox(
                width: 180,
                child: SomDropDown<String>(
                  hint: 'Provider type',
                  value: providerTypeFilter,
                  items: const ['haendler', 'hersteller', 'dienstleister', 'grosshaendler'],
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
                  onChanged: onProviderTypeChanged,
                ),
              ),
              SizedBox(
                width: 150,
                child: SomDropDown<String>(
                  hint: 'Provider size',
                  value: providerSizeFilter,
                  items: const ['0-10', '11-50', '51-100', '101-250', '251-500', '500+'],
                  onChanged: onProviderSizeChanged,
                ),
              ),
              _DateFilterButton(
                label: 'Created from',
                value: createdFrom,
                onSelected: onCreatedFromChanged,
              ),
              _DateFilterButton(
                label: 'Created to',
                value: createdTo,
                onSelected: onCreatedToChanged,
              ),
              _DateFilterButton(
                label: 'Deadline from',
                value: deadlineFrom,
                onSelected: onDeadlineFromChanged,
              ),
              _DateFilterButton(
                label: 'Deadline to',
                value: deadlineTo,
                onSelected: onDeadlineToChanged,
              ),
              if (isAdmin)
                SizedBox(
                  width: 200,
                  child: SomDropDown<String>(
                    hint: 'Editor',
                    value: editorFilter,
                    items: companyUsers.map((u) => u.id!).toList(),
                    itemAsString: (id) => companyUsers.firstWhere((u) => u.id == id).email ?? id,
                    onChanged: onEditorChanged,
                  ),
                ),
              SomButton(
                onPressed: onClear,
                text: 'Clear', type: SomButtonType.ghost,
              ),
              SomButton(
                onPressed: onApply,
                text: 'Apply', type: SomButtonType.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DateFilterButton extends StatelessWidget {
  const _DateFilterButton({
    required this.label,
    required this.value,
    required this.onSelected,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SomButton(
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onSelected(picked);
        }
      },
      text: value == null
          ? label
          : '$label: ${value!.toIso8601String().split('T').first}',
      type: SomButtonType.secondary,
      icon: SomAssets.iconCalendar,
    );
  }
}
