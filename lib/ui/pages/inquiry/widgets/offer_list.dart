import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import '../../../utils/pdf_download.dart';
import '../../../theme/tokens.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/status_badge.dart';

/// Widget for displaying a list of offers for an inquiry.
///
/// Shows offer details with accept/reject actions for buyers.
class OfferList extends StatelessWidget {
  const OfferList({
    Key? key,
    required this.offers,
    required this.isLoading,
    required this.error,
    required this.isBuyer,
    required this.onAccept,
    required this.onReject,
  }) : super(key: key);

  final List<Offer> offers;
  final bool isLoading;
  final String? error;
  final bool isBuyer;
  final ValueChanged<Offer> onAccept;
  final ValueChanged<Offer> onReject;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLoading) const LinearProgressIndicator(),
        if (error != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: SomSpacing.sm),
            child: Text(
              'Failed to load offers: $error',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        if (offers.isEmpty && !isLoading)
          const EmptyState(
            icon: Icons.inventory_2_outlined,
            title: 'No offers yet',
            message: 'Offers will appear here once providers respond',
          ),
        ...offers.map((offer) => OfferCard(
              offer: offer,
              isBuyer: isBuyer,
              onAccept: () => onAccept(offer),
              onReject: () => onReject(offer),
            )),
      ],
    );
  }
}

/// Card widget for displaying a single offer.
class OfferCard extends StatelessWidget {
  const OfferCard({
    Key? key,
    required this.offer,
    required this.isBuyer,
    required this.onAccept,
    required this.onReject,
  }) : super(key: key);

  final Offer offer;
  final bool isBuyer;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: SomSpacing.sm),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SomSpacing.md,
          vertical: SomSpacing.xs,
        ),
        title: Text(
          'Offer ${SomFormatters.shortId(offer.id)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: Text(
          'Provider ${SomFormatters.shortId(offer.providerCompanyId)}',
        ),
        leading: StatusBadge.offer(
          status: offer.status ?? 'pending',
          compact: true,
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            if (offer.pdfPath != null)
              TextButton(
                onPressed: offer.id == null
                    ? null
                    : () => openOfferPdf(
                          context,
                          offerId: offer.id!,
                        ),
                child: const Text('PDF'),
              ),
            if (isBuyer && offer.status?.toLowerCase() == 'pending') ...[
              TextButton(
                onPressed: onAccept,
                child: const Text('Accept'),
              ),
              TextButton(
                onPressed: onReject,
                child: const Text('Reject'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
