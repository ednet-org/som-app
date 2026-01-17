import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import '../../../utils/pdf_download.dart';

import '../../../theme/semantic_colors.dart';
import '../../../theme/tokens.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/design_system/som_button.dart';
import '../../../widgets/detail_section.dart';
import '../../../widgets/empty_state.dart';
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
    return DetailSection(
      title: 'Details',
      icon: Icons.info_outline,
      child: Column(
        children: [
          DetailRow(
            label: 'Branch',
            value: inquiry.branchId != null
                ? SomFormatters.shortId(inquiry.branchId)
                : null,
            labelWidth: 80,
          ),
          DetailRow(
            label: 'Category',
            value: inquiry.categoryId != null
                ? SomFormatters.shortId(inquiry.categoryId)
                : null,
            labelWidth: 80,
          ),
          DetailRow(
            label: 'Created',
            value: SomFormatters.dateTime(inquiry.createdAt),
            labelWidth: 80,
          ),
          if (inquiry.assignedAt != null)
            DetailRow(
              label: 'Assigned',
              value: SomFormatters.dateTime(inquiry.assignedAt),
              labelWidth: 80,
            ),
          if (inquiry.closedAt != null)
            DetailRow(
              label: 'Closed',
              value: SomFormatters.dateTime(inquiry.closedAt),
              labelWidth: 80,
            ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return DetailSection(
      title: 'Description',
      icon: Icons.description_outlined,
      child: Text(
        inquiry.description ?? '',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildAttachmentSection(BuildContext context) {
    return DetailSection(
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
          SomButton(
            onPressed: inquiry.id == null
                ? null
                : () => openInquiryPdf(
                      context,
                      inquiryId: inquiry.id!,
                    ),
            iconData: Icons.download,
            text: 'Download',
            type: SomButtonType.ghost,
          ),
          if (isBuyer || isConsultant)
            SomButton(
              onPressed: onRemoveAttachment,
              iconData: Icons.delete_outline,
              text: 'Remove',
              type: SomButtonType.ghost,
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
              SomButton(
                onPressed: onUploadOffer,
                iconData: Icons.upload,
                text: 'Upload offer',
                type: SomButtonType.primary,
              ),
              SomButton(
                onPressed: onIgnoreInquiry,
                text: "I don't want to make an offer",
                type: SomButtonType.secondary,
              ),
            ],
            if (isConsultant)
              SomButton(
                onPressed: onAssignProviders,
                iconData: Icons.person_add,
                text: 'Assign providers',
                type: SomButtonType.primary,
              ),
            if ((isBuyer || isConsultant) &&
                (inquiry.status ?? '').toLowerCase() != 'closed')
              SomButton(
                onPressed: onCloseInquiry,
                iconData: Icons.check_circle_outline,
                text: 'Close inquiry',
                type: SomButtonType.secondary,
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

/// Placeholder widget when no inquiry is selected.
class NoInquirySelected extends StatelessWidget {
  const NoInquirySelected({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.touch_app_outlined,
      title: 'Select an inquiry',
      message: 'Choose an inquiry from the list to view details',
    );
  }
}
