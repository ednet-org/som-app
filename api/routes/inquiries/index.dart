import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/branch_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/domain/som_domain.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/csv_writer.dart';
import 'package:som_api/services/date_utils.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    return _handleList(context);
  }
  if (context.request.method == HttpMethod.post) {
    return _handleCreate(context);
  }
  return Response(statusCode: 405);
}

Future<Response> _handleList(RequestContext context) async {
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final repo = context.read<InquiryRepository>();
  final params = context.request.uri.queryParameters;
  final statusFilter = params['status'];
  final branchIdFilter = params['branchId'];
  final branchFilter = params['branch'];
  final providerTypeFilter = params['providerType'];
  final providerSizeFilter = params['providerSize'];
  final createdFrom = _parseDate(params['createdFrom']);
  final createdTo = _parseDate(params['createdTo']);
  final deadlineFrom = _parseDate(params['deadlineFrom']);
  final deadlineTo = _parseDate(params['deadlineTo']);
  final editorIds = _parseCsv(params['editorIds'] ?? params['editor']);

  final isConsultant = auth.roles.contains('consultant');
  final activeRole = auth.activeRole;
  List<InquiryRecord> inquiries;
  if (isConsultant) {
    inquiries = await repo.listAll();
  } else if (activeRole == 'provider') {
    final provider =
        await context.read<ProviderRepository>().findByCompany(auth.companyId);
    if (provider == null || provider.status != 'active') {
      return Response.json(
        statusCode: 403,
        body: 'Provider registration is pending.',
      );
    }
    final subscription = await context
        .read<SubscriptionRepository>()
        .findSubscriptionByCompany(auth.companyId);
    if (subscription == null ||
        subscription.status != 'active' ||
        subscription.endDate.isBefore(DateTime.now().toUtc())) {
      return Response.json(
        statusCode: 403,
        body: 'Provider subscription is inactive.',
      );
    }
    inquiries = await repo.listAssignedToProvider(auth.companyId);
  } else {
    inquiries = await repo.listByBuyerCompany(auth.companyId);
  }

  if (branchFilter != null && branchFilter.isNotEmpty) {
    final branches = await context.read<BranchRepository>().listBranches();
    final matchingIds = branches
        .where((branch) =>
            branch.name.toLowerCase().contains(branchFilter.toLowerCase()))
        .map((branch) => branch.id)
        .toSet();
    inquiries = inquiries
        .where((inquiry) => matchingIds.contains(inquiry.branchId))
        .toList();
  }
  if (branchIdFilter != null && branchIdFilter.isNotEmpty) {
    inquiries = inquiries
        .where((inquiry) => inquiry.branchId == branchIdFilter)
        .toList();
  }
  if (providerTypeFilter != null && providerTypeFilter.isNotEmpty) {
    inquiries = inquiries
        .where((inquiry) =>
            (inquiry.providerCriteria.providerType ?? '') == providerTypeFilter)
        .toList();
  }
  if (providerSizeFilter != null && providerSizeFilter.isNotEmpty) {
    inquiries = inquiries
        .where((inquiry) =>
            (inquiry.providerCriteria.companySize ?? '') == providerSizeFilter)
        .toList();
  }
  if (createdFrom != null) {
    inquiries = inquiries
        .where((inquiry) => inquiry.createdAt.isAfter(createdFrom))
        .toList();
  }
  if (createdTo != null) {
    inquiries = inquiries
        .where((inquiry) => inquiry.createdAt.isBefore(createdTo))
        .toList();
  }
  if (deadlineFrom != null) {
    inquiries = inquiries
        .where((inquiry) => inquiry.deadline.isAfter(deadlineFrom))
        .toList();
  }
  if (deadlineTo != null) {
    inquiries = inquiries
        .where((inquiry) => inquiry.deadline.isBefore(deadlineTo))
        .toList();
  }
  if (editorIds.isNotEmpty &&
      (auth.roles.contains('admin') || auth.roles.contains('consultant'))) {
    inquiries = inquiries
        .where((inquiry) => editorIds.contains(inquiry.createdByUserId))
        .toList();
  }

  final offersRepository = context.read<OfferRepository>();
  Map<String, String>? providerStatusMap;
  if (activeRole == 'provider') {
    providerStatusMap = {};
    for (final inquiry in inquiries) {
      final offers = await offersRepository.listByInquiry(inquiry.id);
      OfferRecord? offer;
      for (final candidate in offers) {
        if (candidate.providerCompanyId == auth.companyId) {
          offer = candidate;
          break;
        }
      }
      providerStatusMap[inquiry.id] = _providerStatus(offer);
    }
    if (statusFilter != null && statusFilter.isNotEmpty) {
      inquiries = inquiries
          .where((inquiry) => providerStatusMap![inquiry.id] == statusFilter)
          .toList();
    }
  } else if (statusFilter != null && statusFilter.isNotEmpty) {
    inquiries =
        inquiries.where((inquiry) => inquiry.status == statusFilter).toList();
  }

  if (context.request.uri.queryParameters['format'] == 'csv') {
    final offersRepository = context.read<OfferRepository>();
    final companyRepo = context.read<CompanyRepository>();
    final userRepo = context.read<UserRepository>();
    final branchRepo = context.read<BranchRepository>();
    final branchMap = <String, String>{};
    for (final branch in await branchRepo.listBranches()) {
      branchMap[branch.id] = branch.name;
    }
    final companyNameCache = <String, String>{};
    String companyName(String id) {
      return companyNameCache[id] ?? id;
    }
    final userEmailCache = <String, String>{};
    String userEmail(String id) {
      return userEmailCache[id] ?? id;
    }
    Future<void> primeCompanyName(String companyId) async {
      if (companyNameCache.containsKey(companyId)) return;
      final company = await companyRepo.findById(companyId);
      if (company != null) {
        companyNameCache[companyId] = company.name;
      }
    }
    Future<void> primeUserEmail(String userId) async {
      if (userEmailCache.containsKey(userId)) return;
      final user = await userRepo.findById(userId);
      if (user != null) {
        userEmailCache[userId] = user.email;
      }
    }

    final writer = CsvWriter();
    if (isConsultant) {
      writer.writeRow([
        'id',
        'status',
        'creatorEmail',
        'branch',
        'deadline',
        'createdAt',
        'offerCreatedAt',
        'decisionAt',
        'assignmentAt',
        'offers',
      ]);
    } else if (activeRole == 'provider') {
      writer.writeRow(
          ['id', 'companyName', 'status', 'deadline', 'editor']);
    } else {
      writer.writeRow([
        'id',
        'status',
        'creatorEmail',
        'branch',
        'deadline',
        'createdAt',
        'offers',
      ]);
    }

    for (final inquiry in inquiries) {
      await primeCompanyName(inquiry.buyerCompanyId);
      await primeUserEmail(inquiry.createdByUserId);
      final offers = await offersRepository.listByInquiry(inquiry.id);
      final offerCreatedAt = offers
          .map((offer) => offer.forwardedAt)
          .whereType<DateTime>()
          .fold<DateTime?>(
            null,
            (prev, next) =>
                prev == null || next.isBefore(prev) ? next : prev,
          );
      final decisionAt = offers
          .map((offer) => offer.resolvedAt)
          .whereType<DateTime>()
          .fold<DateTime?>(
            null,
            (prev, next) =>
                prev == null || next.isAfter(prev) ? next : prev,
          );

      final offersSummary = <String>[];
      for (final offer in offers) {
        await primeCompanyName(offer.providerCompanyId);
        if (offer.providerUserId != null) {
          await primeUserEmail(offer.providerUserId!);
        }
        final providerName = companyName(offer.providerCompanyId);
        final providerEditor = offer.providerUserId == null
            ? ''
            : userEmail(offer.providerUserId!);
        final parts = [
          offer.id,
          providerName,
          offer.buyerDecision ?? '',
          offer.providerDecision ?? '',
          offer.forwardedAt?.toIso8601String() ?? '',
          offer.resolvedAt?.toIso8601String() ?? '',
          providerEditor,
        ];
        offersSummary.add(parts.join('|'));
      }

      if (isConsultant) {
        writer.writeRow([
          inquiry.id,
          inquiry.status,
          userEmail(inquiry.createdByUserId),
          branchMap[inquiry.branchId] ?? inquiry.branchId,
          inquiry.deadline.toIso8601String(),
          inquiry.createdAt.toIso8601String(),
          offerCreatedAt?.toIso8601String() ?? '',
          decisionAt?.toIso8601String() ?? '',
          inquiry.assignedAt?.toIso8601String() ?? '',
          offersSummary.join(';'),
        ]);
      } else if (activeRole == 'provider') {
        OfferRecord? companyOffer;
        for (final offer in offers) {
          if (offer.providerCompanyId == auth.companyId) {
            companyOffer = offer;
            break;
          }
        }
        if (companyOffer?.providerUserId != null) {
          await primeUserEmail(companyOffer!.providerUserId!);
        }
        final editor =
            companyOffer?.providerUserId == null ? '' : userEmail(companyOffer!.providerUserId!);
        writer.writeRow([
          inquiry.id,
          companyName(inquiry.buyerCompanyId),
          providerStatusMap?[inquiry.id] ?? '',
          inquiry.deadline.toIso8601String(),
          editor,
        ]);
      } else {
        writer.writeRow([
          inquiry.id,
          inquiry.status,
          userEmail(inquiry.createdByUserId),
          branchMap[inquiry.branchId] ?? inquiry.branchId,
          inquiry.deadline.toIso8601String(),
          inquiry.createdAt.toIso8601String(),
          offersSummary.join(';'),
        ]);
      }
    }
    await context.read<AuditService>().log(
          action: 'inquiries.exported',
          entityType: 'inquiry',
          entityId: auth.companyId,
          actorId: auth.userId,
          metadata: {
            'format': 'csv',
            'role': auth.activeRole,
            'count': inquiries.length,
          },
        );
    return Response(
      headers: {'content-type': 'text/csv'},
      body: writer.toString(),
    );
  }
  final body = inquiries.map((inquiry) {
    final json = inquiry.toJson();
    if (providerStatusMap != null) {
      json['providerStatus'] = providerStatusMap[inquiry.id];
    }
    return json;
  }).toList();
  return Response.json(body: body);
}

Future<Response> _handleCreate(RequestContext context) async {
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  if (auth.activeRole != 'buyer') {
    return Response(statusCode: 403);
  }
  final companyRepo = context.read<CompanyRepository>();
  final userRepo = context.read<UserRepository>();
  final inquiryRepo = context.read<InquiryRepository>();

  final data = jsonDecode(await context.request.body()) as Map<String, dynamic>;

  final deadline = DateTime.parse(data['deadline'] as String);
  if (!isAtLeastBusinessDaysInFuture(deadline, 3)) {
    return Response.json(
        statusCode: 400,
        body: 'Deadline must be at least 3 business days in the future');
  }

  final company = await companyRepo.findById(auth.companyId);
  final user = await userRepo.findById(auth.userId);
  if (company == null || user == null) {
    return Response(statusCode: 400);
  }

  final contact = ContactInfo(
    companyName: company.name,
    salutation: data['salutation'] as String? ?? user.salutation,
    title: data['title'] as String? ?? (user.title ?? ''),
    firstName: data['firstName'] as String? ?? user.firstName,
    lastName: data['lastName'] as String? ?? user.lastName,
    telephone: data['telephone'] as String? ?? (user.telephoneNr ?? ''),
    email: data['email'] as String? ?? user.email,
  );

  final inquiry = InquiryRecord(
    id: const Uuid().v4(),
    buyerCompanyId: company.id,
    createdByUserId: user.id,
    status: 'open',
    branchId: data['branchId'] as String? ?? '',
    categoryId: data['categoryId'] as String? ?? '',
    productTags: (data['productTags'] is List)
        ? (data['productTags'] as List).map((e) => e.toString()).toList()
        : (data['productTags'] as String? ?? '')
            .split(',')
            .where((e) => e.isNotEmpty)
            .toList(),
    deadline: deadline,
    deliveryZips: (data['deliveryZips'] is List)
        ? (data['deliveryZips'] as List).map((e) => e.toString()).toList()
        : (data['deliveryZips'] as String? ?? '')
            .split(',')
            .where((e) => e.isNotEmpty)
            .toList(),
    numberOfProviders: int.parse(data['numberOfProviders']?.toString() ?? '1'),
    description: data['description'] as String?,
    pdfPath: null,
    providerCriteria: ProviderCriteria(
      providerZip: data['providerZip'] as String?,
      radiusKm: data['radiusKm'] == null
          ? null
          : int.tryParse(data['radiusKm'].toString()),
      providerType: data['providerType'] as String?,
      companySize: data['providerCompanySize'] as String?,
    ),
    contactInfo: contact,
    notifiedAt: null,
    assignedAt: null,
    closedAt: null,
    createdAt: DateTime.now().toUtc(),
    updatedAt: DateTime.now().toUtc(),
  );
  final domain = context.read<SomDomainModel>();
  final inquiryEntity = domain.newInquiry()
    ..setAttribute('branchId', inquiry.branchId)
    ..setAttribute('categoryId', inquiry.categoryId)
    ..setAttribute('deadline', inquiry.deadline.toIso8601String())
    ..setAttribute('deliveryZips', inquiry.deliveryZips)
    ..setAttribute('numberOfProviders', inquiry.numberOfProviders);
  try {
    inquiryEntity.validateRequired();
  } catch (error) {
    return Response.json(statusCode: 400, body: error.toString());
  }

  await inquiryRepo.create(inquiry);
  return Response.json(body: inquiry.toJson());
}

DateTime? _parseDate(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  return DateTime.parse(value).toUtc();
}

List<String> _parseCsv(String? value) {
  if (value == null || value.isEmpty) {
    return [];
  }
  return value
      .split(',')
      .map((entry) => entry.trim())
      .where((entry) => entry.isNotEmpty)
      .toList();
}

String _providerStatus(OfferRecord? offer) {
  if (offer == null) {
    return 'open';
  }
  switch (offer.status) {
    case 'accepted':
      return 'won';
    case 'rejected':
      return 'lost';
    case 'ignored':
      return 'ignored';
    case 'offer_uploaded':
      return 'offer_created';
    case 'offer_created':
      return 'offer_created';
    case 'won':
      return 'won';
    case 'lost':
      return 'lost';
    default:
      return offer.status;
  }
}
