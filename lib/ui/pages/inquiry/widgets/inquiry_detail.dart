import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:url_launcher/url_launcher.dart';

import 'offer_list.dart';

/// Widget for displaying inquiry details.
///
/// Shows full inquiry information, actions, and associated offers.
class InquiryDetail extends StatelessWidget {
  const InquiryDetail({
    Key? key,
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
  }) : super(key: key);

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
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          _buildHeader(context),
          const SizedBox(height: 8),
          _buildDetails(),
          if (inquiry.pdfPath != null) _buildAttachment(context),
          const Divider(height: 24),
          _buildActions(),
          const Divider(height: 24),
          OfferList(
            offers: offers,
            isLoading: isLoadingOffers,
            error: offersError,
            isBuyer: isBuyer,
            onAccept: onAcceptOffer,
            onReject: onRejectOffer,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'Inquiry ${inquiry.id ?? ''}',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DetailRow(label: 'Status', value: inquiry.status),
        _DetailRow(label: 'Branch', value: inquiry.branchId),
        _DetailRow(label: 'Category', value: inquiry.categoryId),
        _DetailRow(
          label: 'Deadline',
          value: inquiry.deadline?.toIso8601String(),
        ),
        _DetailRow(
          label: 'Created',
          value: inquiry.createdAt?.toIso8601String(),
        ),
        if (inquiry.assignedAt != null)
          _DetailRow(
            label: 'Assigned',
            value: inquiry.assignedAt?.toIso8601String(),
          ),
        if (inquiry.closedAt != null)
          _DetailRow(
            label: 'Closed',
            value: inquiry.closedAt?.toIso8601String(),
          ),
        if (inquiry.description?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('Description: ${inquiry.description}'),
          ),
      ],
    );
  }

  Widget _buildAttachment(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 12,
        children: [
          TextButton(
            onPressed: () => launchUrl(Uri.parse(inquiry.pdfPath!)),
            child: const Text('Download inquiry PDF'),
          ),
          if (isBuyer || isConsultant)
            TextButton(
              onPressed: onRemoveAttachment,
              child: const Text('Remove attachment'),
            ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (isProvider) ...[
          TextButton(
            onPressed: onUploadOffer,
            child: const Text('Upload offer'),
          ),
          TextButton(
            onPressed: onIgnoreInquiry,
            child: const Text("I don't want to make an offer"),
          ),
        ],
        if (isConsultant)
          TextButton(
            onPressed: onAssignProviders,
            child: const Text('Assign providers'),
          ),
        if ((isBuyer || isConsultant) &&
            (inquiry.status ?? '').toLowerCase() != 'closed')
          TextButton(
            onPressed: onCloseInquiry,
            child: const Text('Close inquiry'),
          ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Text('$label: ${value ?? '-'}');
  }
}

/// Placeholder widget when no inquiry is selected.
class NoInquirySelected extends StatelessWidget {
  const NoInquirySelected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Select an inquiry to view details.'),
    );
  }
}
