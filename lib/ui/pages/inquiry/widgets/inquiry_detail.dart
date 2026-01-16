import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import '../../../utils/pdf_download.dart';

import '../../../theme/semantic_colors.dart';
import '../../../theme/tokens.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/status_badge.dart';
import 'offer_list.dart';

/// Widget for displaying inquiry details.
///
/// Shows full inquiry information, actions, and associated offers.
class InquiryDetail extends StatelessWidget {
  const InquiryDetail({
    super.key,
    required this.inquiry,
    required this.offers,
    required this.isLoadingOffers,
    required this.offersError,
    required this.isBuyer,
    required this.isProvider,
    required this.isConsultant,
    required this.onUploadOffer,
    required this.onIgnoreInquiry,
    required this.onAssignProviders,
    required this.onCloseInquiry,
    required this.onRemoveAttachment,
    required this.onAcceptOffer,
    required this.onRejectOffer,
  });

  final Inquiry inquiry;
  final List<Offer> offers;
  final bool isLoadingOffers;
  final String? offersError;
  final bool isBuyer;
  final bool isProvider;
  final bool isConsultant;
  final VoidCallback onUploadOffer;
  final VoidCallback onIgnoreInquiry;
  final VoidCallback onAssignProviders;
  final VoidCallback onCloseInquiry;
  final VoidCallback onRemoveAttachment;
  final ValueChanged<Offer> onAcceptOffer;
  final ValueChanged<Offer> onRejectOffer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SomSpacing.md),
      child: ListView(
        children: [
          _buildHeader(context),
          const SizedBox(height: SomSpacing.md),
          _buildStatusSection(context),
          const SizedBox(height: SomSpacing.md),
          _buildDetailsSection(context),
          if (inquiry.description?.isNotEmpty == true) ...[
            const SizedBox(height: SomSpacing.md),
            _buildDescriptionSection(context),
          ],
          if (inquiry.pdfPath != null) ...[
            const SizedBox(height: SomSpacing.md),
            _buildAttachmentSection(context),
          ],
          const Divider(height: SomSpacing.xl),
          _buildActionsSection(context),
          const Divider(height: SomSpacing.xl),
          _buildOffersSection(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                inquiry.description?.isNotEmpty == true
                    ? SomFormatters.truncate(inquiry.description, 60)
                    : 'Inquiry ${SomFormatters.shortId(inquiry.id)}',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: SomSpacing.xs),
              Text(
                SomFormatters.shortId(inquiry.id),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    return Row(
      children: [
        StatusBadge.inquiry(status: inquiry.status ?? 'unknown'),
        const SizedBox(width: SomSpacing.md),
        if (inquiry.deadline != null) ...[
          Icon(
            Icons.event,
            size: SomIconSize.sm,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(width: SomSpacing.xs),
          Text(
            'Due ${SomFormatters.date(inquiry.deadline)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return _SectionCard(
      title: 'Details',
      icon: Icons.info_outline,
      child: Column(
        children: [
          _DetailRow(
            label: 'Branch',
            value: inquiry.branchId != null
                ? SomFormatters.shortId(inquiry.branchId)
                : null,
          ),
          _DetailRow(
            label: 'Category',
            value: inquiry.categoryId != null
                ? SomFormatters.shortId(inquiry.categoryId)
                : null,
          ),
          _DetailRow(
            label: 'Created',
            value: SomFormatters.dateTime(inquiry.createdAt),
          ),
          if (inquiry.assignedAt != null)
            _DetailRow(
              label: 'Assigned',
              value: SomFormatters.dateTime(inquiry.assignedAt),
            ),
          if (inquiry.closedAt != null)
            _DetailRow(
              label: 'Closed',
              value: SomFormatters.dateTime(inquiry.closedAt),
            ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return _SectionCard(
      title: 'Description',
      icon: Icons.description_outlined,
      child: Text(
        inquiry.description ?? '',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildAttachmentSection(BuildContext context) {
    return _SectionCard(
      title: 'Attachment',
      icon: Icons.attach_file,
      child: Row(
        children: [
          Icon(
            Icons.picture_as_pdf,
            color: SomSemanticColors.error,
            size: SomIconSize.lg,
          ),
          const SizedBox(width: SomSpacing.sm),
          Expanded(
            child: Text(
              'Inquiry PDF',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          TextButton.icon(
            onPressed: inquiry.id == null
                ? null
                : () => openSignedPdf(
                      context,
                      endpoint: '/inquiries/${inquiry.id}/pdf',
                    ),
            icon: const Icon(Icons.download, size: SomIconSize.sm),
            label: const Text('Download'),
          ),
          if (isBuyer || isConsultant)
            TextButton.icon(
              onPressed: onRemoveAttachment,
              icon: Icon(
                Icons.delete_outline,
                size: SomIconSize.sm,
                color: SomSemanticColors.error,
              ),
              label: Text(
                'Remove',
                style: TextStyle(color: SomSemanticColors.error),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    final hasActions = isProvider || isConsultant || isBuyer;
    if (!hasActions) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: SomSpacing.sm),
        Wrap(
          spacing: SomSpacing.sm,
          runSpacing: SomSpacing.sm,
          children: [
            if (isProvider) ...[
              FilledButton.icon(
                onPressed: onUploadOffer,
                icon: const Icon(Icons.upload, size: SomIconSize.sm),
                label: const Text('Upload offer'),
              ),
              OutlinedButton(
                onPressed: onIgnoreInquiry,
                child: const Text("I don't want to make an offer"),
              ),
            ],
            if (isConsultant)
              FilledButton.tonalIcon(
                onPressed: onAssignProviders,
                icon: const Icon(Icons.person_add, size: SomIconSize.sm),
                label: const Text('Assign providers'),
              ),
            if ((isBuyer || isConsultant) &&
                (inquiry.status ?? '').toLowerCase() != 'closed')
              OutlinedButton.icon(
                onPressed: onCloseInquiry,
                icon: const Icon(Icons.check_circle_outline,
                    size: SomIconSize.sm),
                label: const Text('Close inquiry'),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildOffersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Offers',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(width: SomSpacing.sm),
            if (offers.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SomSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(SomRadius.full),
                ),
                child: Text(
                  '${offers.length}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ),
          ],
        ),
        const SizedBox(height: SomSpacing.sm),
        OfferList(
          offers: offers,
          isLoading: isLoadingOffers,
          error: offersError,
          isBuyer: isBuyer,
          onAccept: onAcceptOffer,
          onReject: onRejectOffer,
        ),
      ],
    );
  }
}

/// A card container for detail sections
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(SomSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(SomRadius.md),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: SomIconSize.sm,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(width: SomSpacing.xs),
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: SomSpacing.sm),
          child,
        ],
      ),
    );
  }
}

/// A single detail row with label and value
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SomSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder widget when no inquiry is selected.
class NoInquirySelected extends StatelessWidget {
  const NoInquirySelected({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.touch_app_outlined,
            size: SomIconSize.xxl,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: SomSpacing.md),
          Text(
            'Select an inquiry',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: SomSpacing.xs),
          Text(
            'Choose an inquiry from the list to view details',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
