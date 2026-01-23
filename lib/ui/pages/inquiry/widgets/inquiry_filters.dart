import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import '../../../domain/model/forms/som_drop_down.dart';
import '../../../domain/model/forms/som_text_input.dart';
import '../../../utils/formatters.dart';

/// Widget for filtering inquiries by various criteria.
///
/// Displays expandable filter panel with dropdowns and date pickers.
/// Designed with accessibility best practices:
/// - Logical grouping of related filters
/// - Clear visual hierarchy
/// - Proper labels and semantics
/// - Responsive layout
class InquiryFilters extends StatefulWidget {
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

  @override
  State<InquiryFilters> createState() => _InquiryFiltersState();
}

class _InquiryFiltersState extends State<InquiryFilters> {
  bool _isExpanded = false;

  List<String> get _statusOptions {
    if (widget.isProvider) {
      return const ['open', 'offer_created', 'lost', 'won', 'ignored'];
    }
    return const ['open', 'closed', 'draft', 'expired'];
  }

  int get _activeFilterCount {
    int count = 0;
    if (widget.statusFilter != null) count++;
    if (widget.branchIdFilter != null) count++;
    if (widget.branchNameFilter?.isNotEmpty == true) count++;
    if (widget.providerTypeFilter != null) count++;
    if (widget.providerSizeFilter != null) count++;
    if (widget.createdFrom != null) count++;
    if (widget.createdTo != null) count++;
    if (widget.deadlineFrom != null) count++;
    if (widget.deadlineTo != null) count++;
    if (widget.editorFilter != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filterCount = _activeFilterCount;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header row with toggle and actions
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'Filters',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (filterCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$filterCount',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (filterCount > 0)
                  TextButton(
                    onPressed: widget.onClear,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(0, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Clear'),
                  ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: widget.onApply,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),
          ),
        ),
        // Expandable filter content
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: _buildFilterContent(theme),
        ),
      ],
    );
  }

  Widget _buildFilterContent(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primary filters row
          _buildFilterSection(
            theme: theme,
            children: [
              _buildFilterItem(
                flex: 2,
                child: SomDropDown<String>(
                  label: 'Status',
                  hint: 'All statuses',
                  value: widget.statusFilter,
                  items: _statusOptions,
                  itemAsString: _formatStatus,
                  onChanged: widget.onStatusChanged,
                  showLeadingIcon: false,
                  isDense: true,
                  popupMode: PopupMode.menu,
                ),
              ),
              _buildFilterItem(
                flex: 3,
                child: SomDropDown<String>(
                  label: 'Branch',
                  hint: 'All branches',
                  value: widget.branchIdFilter,
                  items: widget.branches.map((b) => b.id!).toList(),
                  itemAsString: (id) =>
                      widget.branches.firstWhere((b) => b.id == id).name ?? id,
                  onChanged: widget.onBranchIdChanged,
                  showLeadingIcon: false,
                  isDense: true,
                  popupMode: PopupMode.menu,
                ),
              ),
              _buildFilterItem(
                flex: 2,
                child: SomTextInput(
                  label: 'Branch search',
                  hint: 'Search by name',
                  onChanged: (value) =>
                      widget.onBranchNameChanged(value.trim()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Provider filters row
          _buildFilterSection(
            theme: theme,
            children: [
              _buildFilterItem(
                flex: 2,
                child: SomDropDown<String>(
                  label: 'Provider type',
                  hint: 'All types',
                  value: widget.providerTypeFilter,
                  items: const [
                    'haendler',
                    'hersteller',
                    'dienstleister',
                    'grosshaendler'
                  ],
                  itemAsString: _formatProviderType,
                  onChanged: widget.onProviderTypeChanged,
                  showLeadingIcon: false,
                  isDense: true,
                  popupMode: PopupMode.menu,
                ),
              ),
              _buildFilterItem(
                flex: 2,
                child: SomDropDown<String>(
                  label: 'Company size',
                  hint: 'All sizes',
                  value: widget.providerSizeFilter,
                  items: const [
                    '0-10',
                    '11-50',
                    '51-100',
                    '101-250',
                    '251-500',
                    '500+'
                  ],
                  itemAsString: (s) => '$s employees',
                  onChanged: widget.onProviderSizeChanged,
                  showLeadingIcon: false,
                  isDense: true,
                  popupMode: PopupMode.menu,
                ),
              ),
              if (widget.isAdmin)
                _buildFilterItem(
                  flex: 2,
                  child: SomDropDown<String>(
                    label: 'Editor',
                    hint: 'All editors',
                    value: widget.editorFilter,
                    items: widget.companyUsers.map((u) => u.id!).toList(),
                    itemAsString: (id) =>
                        widget.companyUsers
                            .firstWhere((u) => u.id == id)
                            .email ??
                        id,
                    onChanged: widget.onEditorChanged,
                    showLeadingIcon: false,
                    isDense: true,
                    popupMode: PopupMode.menu,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Date filters row
          _buildFilterSection(
            theme: theme,
            children: [
              _buildFilterItem(
                flex: 1,
                child: _DateFilterField(
                  label: 'Created from',
                  value: widget.createdFrom,
                  onSelected: widget.onCreatedFromChanged,
                ),
              ),
              _buildFilterItem(
                flex: 1,
                child: _DateFilterField(
                  label: 'Created to',
                  value: widget.createdTo,
                  onSelected: widget.onCreatedToChanged,
                ),
              ),
              _buildFilterItem(
                flex: 1,
                child: _DateFilterField(
                  label: 'Deadline from',
                  value: widget.deadlineFrom,
                  onSelected: widget.onDeadlineFromChanged,
                ),
              ),
              _buildFilterItem(
                flex: 1,
                child: _DateFilterField(
                  label: 'Deadline to',
                  value: widget.deadlineTo,
                  onSelected: widget.onDeadlineToChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required ThemeData theme,
    required List<Widget> children,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildFilterItem({required int flex, required Widget child}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: child,
      ),
    );
  }

  String _formatStatus(String status) {
    switch (status) {
      case 'open':
        return 'Open';
      case 'closed':
        return 'Closed';
      case 'draft':
        return 'Draft';
      case 'expired':
        return 'Expired';
      case 'offer_created':
        return 'Offer created';
      case 'lost':
        return 'Lost';
      case 'won':
        return 'Won';
      case 'ignored':
        return 'Ignored';
      default:
        return status;
    }
  }

  String _formatProviderType(String type) {
    switch (type) {
      case 'haendler':
        return 'Händler';
      case 'hersteller':
        return 'Hersteller';
      case 'dienstleister':
        return 'Dienstleister';
      case 'grosshaendler':
        return 'Großhändler';
      default:
        return type;
    }
  }
}

/// Compact date filter field with Material 3 styling.
class _DateFilterField extends StatelessWidget {
  const _DateFilterField({
    required this.label,
    required this.value,
    required this.onSelected,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _pickDate(context),
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (value != null)
                IconButton(
                  icon: const Icon(Icons.clear, size: 16),
                  onPressed: () => onSelected(null),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  splashRadius: 16,
                  tooltip: 'Clear date',
                ),
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.calendar_today, size: 16),
              ),
            ],
          ),
          suffixIconConstraints: const BoxConstraints(minWidth: 48),
        ),
        child: Text(
          value != null ? SomFormatters.date(value) : 'Select date',
          style: theme.textTheme.bodySmall?.copyWith(
            color: value != null
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onSelected(picked);
    }
  }
}
