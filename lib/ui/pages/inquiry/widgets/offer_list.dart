import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import '../../../utils/pdf_download.dart';

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
        Text('Offers', style: Theme.of(context).textTheme.titleSmall),
        if (isLoading) const LinearProgressIndicator(),
        if (error != null)
          Text(
            'Failed to load offers: $error',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        if (offers.isEmpty && !isLoading) const Text('No offers yet.'),
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

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Offer ${offer.id ?? ''}'),
        subtitle: Text(
          'Provider: ${offer.providerCompanyId ?? '-'} | '
          'Status: ${offer.status ?? '-'}',
        ),
        leading: CircleAvatar(
          backgroundColor: _statusColor(offer.status),
          radius: 8,
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
