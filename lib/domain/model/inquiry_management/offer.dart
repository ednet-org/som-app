import 'inquiry.dart';
import 'offer_status.dart';
import 'user.dart';

class Offer {
  final String id;
  final Inquiry inquiry;
  final User
      provider; // User that created the offer, should have role "provider"
  final double? price;
  final String? deliveryTime;
  final List<String>? attachments;
  final OfferStatus status;

  Offer({
    required this.id,
    required this.inquiry,
    required this.provider,
    required this.price,
    required this.deliveryTime,
    required this.attachments,
    required this.status,
  });
}
