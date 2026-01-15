import '../infrastructure/repositories/ads_repository.dart';
import '../infrastructure/repositories/company_repository.dart';
import '../infrastructure/repositories/inquiry_repository.dart';
import '../infrastructure/repositories/offer_repository.dart';
import '../infrastructure/repositories/provider_repository.dart';
import '../infrastructure/repositories/user_repository.dart';
import '../models/models.dart';
import 'email_service.dart';

class NotificationService {
  NotificationService({
    required this.ads,
    required this.users,
    required this.companies,
    required this.providers,
    required this.inquiries,
    required this.offers,
    required this.email,
  });

  final AdsRepository ads;
  final UserRepository users;
  final CompanyRepository companies;
  final ProviderRepository providers;
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

  Future<void> notifyConsultantsOnCompanyRegistered(
    CompanyRecord company,
  ) async {
    final consultants = await users.listByRole('consultant');
    if (consultants.isEmpty) {
      return;
    }
    for (final consultant in consultants) {
      await email.send(
        to: consultant.email,
        subject: 'New company registered',
        text: 'Company ${company.name} has registered on SOM.',
      );
    }
  }

  Future<void> notifyConsultantsOnCompanyUpdated(
    CompanyRecord company,
  ) async {
    final consultants = await users.listByRole('consultant');
    for (final consultant in consultants) {
      await email.send(
        to: consultant.email,
        subject: 'Company updated',
        text: 'Company ${company.name} has updated its profile.',
      );
    }
  }

  Future<void> notifyAdminsOnCompanyActivated(CompanyRecord company) async {
    final admins = await users.listAdminsByCompany(company.id);
    for (final admin in admins) {
      await email.send(
        to: admin.email,
        subject: 'Company activated',
        text: 'Your company ${company.name} has been activated.',
      );
    }
  }

  Future<void> notifyAdminsOnCompanyDeactivated(CompanyRecord company) async {
    final admins = await users.listAdminsByCompany(company.id);
    for (final admin in admins) {
      await email.send(
        to: admin.email,
        subject: 'Company deactivated',
        text: 'Your company ${company.name} has been deactivated.',
      );
    }
  }

  Future<void> notifyConsultantsOnCompanyActivated(
    CompanyRecord company,
  ) async {
    final consultants = await users.listByRole('consultant');
    for (final consultant in consultants) {
      await email.send(
        to: consultant.email,
        subject: 'Company activated',
        text: 'Company ${company.name} has been activated.',
      );
    }
  }

  Future<void> notifyConsultantsOnCompanyDeactivated(
    CompanyRecord company,
  ) async {
    final consultants = await users.listByRole('consultant');
    for (final consultant in consultants) {
      await email.send(
        to: consultant.email,
        subject: 'Company deactivated',
        text: 'Company ${company.name} has been deactivated.',
      );
    }
  }

  Future<void> notifyUserRemovedFromCompany({
    required UserRecord user,
    required CompanyRecord company,
    UserRecord? removedBy,
  }) async {
    await email.send(
      to: user.email,
      subject: 'You have been removed from ${company.name}',
      text:
          'Your account has been removed from ${company.name}. Please contact support if this was unexpected.',
    );
    final admins = await users.listAdminsByCompany(company.id);
    for (final admin in admins) {
      await email.send(
        to: admin.email,
        subject: 'User removed from company',
        text:
            'User ${user.email} was removed from ${company.name} by ${removedBy?.email ?? 'an admin'}.',
      );
    }
  }

  Future<void> notifyUserRemovedByEmails({
    required CompanyRecord company,
    String? userEmail,
    String? removedByEmail,
  }) async {
    if (userEmail == null) {
      return;
    }
    await email.send(
      to: userEmail,
      subject: 'You have been removed from ${company.name}',
      text:
          'Your account has been removed from ${company.name}. Please contact support if this was unexpected.',
    );
    final admins = await users.listAdminsByCompany(company.id);
    for (final admin in admins) {
      await email.send(
        to: admin.email,
        subject: 'User removed from company',
        text:
            'User $userEmail was removed from ${company.name} by ${removedByEmail ?? 'an admin'}.',
      );
    }
  }

  Future<void> notifyProvidersOnInquiryAssigned({
    required InquiryRecord inquiry,
    required List<String> providerCompanyIds,
  }) async {
    if (providerCompanyIds.isEmpty) {
      return;
    }
    final link = _inquiryLink(inquiry.id, role: 'provider');
    for (final providerCompanyId in providerCompanyIds) {
      final admins = await users.listAdminsByCompany(providerCompanyId);
      for (final admin in admins) {
        await email.send(
          to: admin.email,
          subject: 'New inquiry assigned',
          text:
              'A new inquiry has been assigned to your company.\n'
              'Inquiry ID: ${inquiry.id}\n'
              'Deadline: ${inquiry.deadline.toIso8601String()}\n'
              'View: $link',
        );
      }
    }
  }

  Future<void> notifyProvidersOfUpcomingDeadlines({
    Duration window = const Duration(days: 2),
    DateTime? now,
  }) async {
    final current = now ?? DateTime.now().toUtc();
    final remindBefore = current.add(window);
    final openInquiries = await inquiries.listAll(status: 'open');
    for (final inquiry in openInquiries) {
      if (inquiry.deadline.isBefore(current) ||
          inquiry.deadline.isAfter(remindBefore)) {
        continue;
      }
      final assignments = await inquiries.listAssignmentsByInquiry(inquiry.id);
      for (final assignment in assignments) {
        if (assignment.deadlineReminderSentAt != null) {
          continue;
        }
        final admins =
            await users.listAdminsByCompany(assignment.providerCompanyId);
        if (admins.isEmpty) {
          continue;
        }
        final link = _inquiryLink(inquiry.id, role: 'provider');
        for (final admin in admins) {
          await email.send(
            to: admin.email,
            subject: 'Inquiry deadline approaching',
            text:
                'The inquiry ${inquiry.id} is due on ${inquiry.deadline.toIso8601String()}.\n'
                'Please submit your offer before the deadline.\n'
                'View: $link',
          );
        }
        await inquiries.markAssignmentReminderSent(
          assignment.id,
          current,
        );
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

  Future<void> notifyProvidersOnBranchUpdated({
    required String branchId,
    required String oldName,
    required String newName,
  }) async {
    final affected = await providers.listByBranch(branchId);
    if (affected.isEmpty) {
      return;
    }
    for (final profile in affected) {
      final admins = await users.listAdminsByCompany(profile.companyId);
      for (final admin in admins) {
        await email.send(
          to: admin.email,
          subject: 'Branch updated',
          text:
              'Branch "$oldName" has been renamed to "$newName". '
              'Please review your provider profile.',
        );
      }
    }
  }

  Future<void> notifyProvidersOnBranchDeleted({
    required String branchId,
    required String name,
  }) async {
    final affected = await providers.listByBranch(branchId);
    if (affected.isEmpty) {
      return;
    }
    for (final profile in affected) {
      final admins = await users.listAdminsByCompany(profile.companyId);
      for (final admin in admins) {
        await email.send(
          to: admin.email,
          subject: 'Branch removed',
          text:
              'Branch "$name" has been removed. Please update your provider profile.',
        );
      }
    }
  }

  Future<void> notifyProvidersOnCategoryUpdated({
    required String categoryId,
    required String branchId,
    required String oldName,
    required String newName,
  }) async {
    final affected = await providers.listByBranch(branchId);
    if (affected.isEmpty) {
      return;
    }
    for (final profile in affected) {
      final admins = await users.listAdminsByCompany(profile.companyId);
      for (final admin in admins) {
        await email.send(
          to: admin.email,
          subject: 'Category updated',
          text:
              'Category "$oldName" has been renamed to "$newName". '
              'Please review your provider profile and inquiries.',
        );
      }
    }
  }

  Future<void> notifyProvidersOnCategoryDeleted({
    required String categoryId,
    required String branchId,
    required String name,
  }) async {
    final affected = await providers.listByBranch(branchId);
    if (affected.isEmpty) {
      return;
    }
    for (final profile in affected) {
      final admins = await users.listAdminsByCompany(profile.companyId);
      for (final admin in admins) {
        await email.send(
          to: admin.email,
          subject: 'Category removed',
          text:
              'Category "$name" has been removed. Please review your provider profile.',
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

  String _inquiryLink(String inquiryId, {required String role}) {
    final baseUrl = const String.fromEnvironment(
      'APP_BASE_URL',
      defaultValue: 'http://localhost:8090',
    );
    return '$baseUrl/#/inquiries?inquiryId=$inquiryId&role=$role';
  }
}
