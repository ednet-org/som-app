import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';

import '../../../theme/semantic_colors.dart';
import '../../../theme/tokens.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/status_badge.dart';

/// Widget for displaying a list of inquiries.
///
/// Shows inquiry description, status badge, and creation date with selection support.
class InquiryList extends StatelessWidget {
  const InquiryList({
    super.key,
    required this.inquiries,
    required this.selectedInquiryId,
    required this.onInquirySelected,
  });

  final List<Inquiry> inquiries;
  final String? selectedInquiryId;
  final ValueChanged<Inquiry> onInquirySelected;

  @override
  Widget build(BuildContext context) {
    if (inquiries.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.separated(
      itemCount: inquiries.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final inquiry = inquiries[index];
        return InquiryListTile(
          inquiry: inquiry,
          isSelected: selectedInquiryId == inquiry.id,
          onTap: () => onInquirySelected(inquiry),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const EmptyState(
      asset: SomAssets.inquiryEmpty,
      title: 'No inquiries found',
      message: 'Create a new inquiry to get started',
    );
  }
}

/// Single list tile for an inquiry.
class InquiryListTile extends StatelessWidget {
  const InquiryListTile({
    super.key,
    required this.inquiry,
    required this.isSelected,
    required this.onTap,
  });

  final Inquiry inquiry;
  final bool isSelected;
  final VoidCallback onTap;

  String get _title {
    // Prefer description, fall back to truncated ID
    final desc = inquiry.description;
    if (desc != null && desc.isNotEmpty) {
      return SomFormatters.truncate(desc, 50);
    }
    return 'Inquiry ${SomFormatters.shortId(inquiry.id)}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = SomSemanticColors.forInquiryStatus(inquiry.status);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: SomSpacing.md,
        vertical: SomSpacing.xs,
      ),
      selected: isSelected,
      selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.3),
      leading: CircleAvatar(
        backgroundColor: statusColor.withValues(alpha: 0.15),
        foregroundColor: statusColor,
        child: Text(
          SomFormatters.shortId(inquiry.id).substring(1, 3).toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ),
      title: Text(
        _title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: SomSpacing.xs),
        child: Row(
          children: [
            StatusBadge.inquiry(
              status: inquiry.status ?? 'unknown',
              showIcon: false,
            ),
            const SizedBox(width: SomSpacing.sm),
            SomSvgIcon(
              SomAssets.iconCalendar,
              size: SomIconSize.sm,
              color: colorScheme.outline,
            ),
            const SizedBox(width: SomSpacing.xs),
            Text(
              SomFormatters.relative(inquiry.createdAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
      trailing: isSelected
          ? SomSvgIcon(
              SomAssets.iconChevronRight,
              size: SomIconSize.md,
              color: colorScheme.primary,
            )
          : null,
      onTap: onTap,
    );
  }
}
