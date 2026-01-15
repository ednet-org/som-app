import '../infrastructure/repositories/ads_repository.dart';
import '../infrastructure/repositories/company_repository.dart';
import '../infrastructure/repositories/inquiry_repository.dart';
import '../infrastructure/repositories/offer_repository.dart';
import '../infrastructure/repositories/user_repository.dart';
import '../models/models.dart';
import 'email_service.dart';

class NotificationService {
  NotificationService({
    required this.ads,
    required this.users,
    required this.companies,
    required this.inquiries,
    required this.offers,
    required this.email,
  });

  final AdsRepository ads;
  final UserRepository users;
  final CompanyRepository companies;
  final InquiryRepository inquiries;
  final OfferRepository offers;
  final EmailService email;

  Future<void> notifyBuyersForOfferCountOrDeadline() async {
    final openInquiries = await inquiries.listAll(status: 'open');
    final now = DateTime.now().toUtc();
    for (final inquiry in openInquiries) {
      if (inquiry.notifiedAt != null) {
        continue;
      }
      final inquiryOffers = await offers.listByInquiry(inquiry.id);
      final reachedTarget = inquiryOffers.length >= inquiry.numberOfProviders;
      final deadlineReached = now.isAfter(inquiry.deadline);
      if (reachedTarget || deadlineReached) {
        await _sendBuyerNotification(inquiry, reachedTarget, deadlineReached);
        await inquiries.markNotified(inquiry.id, now);
      }
    }
  }

  Future<void> notifyBuyerIfOfferTargetReached(InquiryRecord inquiry) async {
    if (inquiry.notifiedAt != null) {
      return;
    }
    final inquiryOffers = await offers.listByInquiry(inquiry.id);
    if (inquiryOffers.length >= inquiry.numberOfProviders) {
      await _sendBuyerNotification(inquiry, true, false);
      await inquiries.markNotified(inquiry.id, DateTime.now().toUtc());
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
    final baseUrl = const String.fromEnvironment(
      'APP_BASE_URL',
      defaultValue: 'http://localhost:8090',
    );
    final link = '$baseUrl/#/inquiries?inquiryId=${inquiry.id}';
    await email.send(
      to: inquiry.contactInfo.email,
      subject: 'New offers for your inquiry',
      text: 'Inquiry ${inquiry.id}: $reason\nView offers: $link',
    );
  }

  Future<void> notifyConsultantsOnAdCreated(AdRecord ad) async {
    final consultants = await users.listByRole('consultant');
    if (consultants.isEmpty) {
      return;
    }
    final company = await companies.findById(ad.companyId);
    final companyLabel = company?.name ?? ad.companyId;
    final link = _adLink(ad.id);
    for (final consultant in consultants) {
      await email.send(
        to: consultant.email,
        subject: 'New ad created',
        text: 'Company $companyLabel created a new ad.\nReview: $link',
      );
    }
  }

  Future<void> notifyConsultantsOnAdActivated(AdRecord ad) async {
    final consultants = await users.listByRole('consultant');
    if (consultants.isEmpty) {
      return;
    }
    final company = await companies.findById(ad.companyId);
    final companyLabel = company?.name ?? ad.companyId;
    final link = _adLink(ad.id);
    for (final consultant in consultants) {
      await email.send(
        to: consultant.email,
        subject: 'Ad activated',
        text: 'Company $companyLabel activated an ad.\nReview: $link',
      );
    }
  }

  Future<void> notifyProvidersForExpiredAds({DateTime? now}) async {
    final current = now ?? DateTime.now().toUtc();
    final activeAds = await ads.listAll(status: 'active');
    for (final ad in activeAds) {
      if (!_isAdExpired(ad, current)) {
        continue;
      }
      final updated = AdRecord(
        id: ad.id,
        companyId: ad.companyId,
        type: ad.type,
        status: 'expired',
        branchId: ad.branchId,
        url: ad.url,
        imagePath: ad.imagePath,
        headline: ad.headline,
        description: ad.description,
        startDate: ad.startDate,
        endDate: ad.endDate,
        bannerDate: ad.bannerDate,
        createdAt: ad.createdAt,
        updatedAt: current,
      );
      await ads.update(updated);
      final admins = await users.listAdminsByCompany(ad.companyId);
      if (admins.isEmpty) {
        continue;
      }
      final link = _adLink(ad.id);
      for (final admin in admins) {
        await email.send(
          to: admin.email,
          subject: 'Your ad has expired',
          text: 'Ad ${ad.id} has expired.\nReview: $link',
        );
      }
    }
  }

  bool _isAdExpired(AdRecord ad, DateTime now) {
    if (ad.type == 'banner') {
      final bannerDate = ad.bannerDate;
      if (bannerDate == null) {
        return false;
      }
      final day = DateTime.utc(
        bannerDate.year,
        bannerDate.month,
        bannerDate.day,
      );
      final expiresAt = day.add(const Duration(days: 1));
      return !now.isBefore(expiresAt);
    }
    final endDate = ad.endDate;
    if (endDate == null) {
      return false;
    }
    return !now.isBefore(endDate);
  }

  String _adLink(String adId) {
    final baseUrl = const String.fromEnvironment(
      'APP_BASE_URL',
      defaultValue: 'http://localhost:8090',
    );
    return '$baseUrl/#/ads?adId=$adId';
  }
}
