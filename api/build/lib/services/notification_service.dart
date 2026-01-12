import '../infrastructure/repositories/inquiry_repository.dart';
import '../infrastructure/repositories/offer_repository.dart';
import '../models/models.dart';
import 'email_service.dart';

class NotificationService {
  NotificationService({
    required this.inquiries,
    required this.offers,
    required this.email,
  });

  final InquiryRepository inquiries;
  final OfferRepository offers;
  final EmailService email;

  Future<void> notifyBuyersForOfferCountOrDeadline() async {
    final openInquiries = inquiries.listAll(status: 'open');
    final now = DateTime.now().toUtc();
    for (final inquiry in openInquiries) {
      if (inquiry.notifiedAt != null) {
        continue;
      }
      final inquiryOffers = offers.listByInquiry(inquiry.id);
      final reachedTarget = inquiryOffers.length >= inquiry.numberOfProviders;
      final deadlineReached = now.isAfter(inquiry.deadline);
      if (reachedTarget || deadlineReached) {
        await _sendBuyerNotification(inquiry, reachedTarget, deadlineReached);
        inquiries.markNotified(inquiry.id, now);
      }
    }
  }

  Future<void> _sendBuyerNotification(
    InquiryRecord inquiry,
    bool reachedTarget,
    bool deadlineReached,
  ) async {
    final reason = reachedTarget
        ? 'The requested number of offers has been reached.'
        : 'The deadline for offers has been reached.';
    await email.send(
      to: inquiry.contactInfo.email,
      subject: 'New offers for your inquiry',
      text: 'Inquiry ${inquiry.id}: $reason',
    );
  }
}
