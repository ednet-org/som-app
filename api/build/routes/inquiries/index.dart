import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/domain/som_domain.dart';
import 'package:som_api/services/date_utils.dart';
import 'package:som_api/services/file_storage.dart';
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
  final auth = parseAuth(
    context,
    secret: const String.fromEnvironment('JWT_SECRET', defaultValue: 'som_dev_secret'),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final repo = context.read<InquiryRepository>();
  final status = context.request.uri.queryParameters['status'];
  List<InquiryRecord> inquiries;
  if (auth.roles.contains('consultant')) {
    inquiries = repo.listAll(status: status);
  } else if (auth.roles.contains('provider')) {
    inquiries = repo.listAssignedToProvider(auth.companyId);
  } else {
    inquiries = repo.listByBuyerCompany(auth.companyId);
  }
  if (context.request.uri.queryParameters['format'] == 'csv') {
    final offersRepository = context.read<OfferRepository>();
    final buffer = StringBuffer();
    buffer.writeln('id,status,creator,branch,deadline,createdAt,offers');
    for (final inquiry in inquiries) {
      final offers = offersRepository.listByInquiry(inquiry.id);
      final offersSummary = offers
          .map((offer) =>
              '${offer.id}|${offer.providerCompanyId}|${offer.status}|${offer.forwardedAt?.toIso8601String() ?? ''}|${offer.resolvedAt?.toIso8601String() ?? ''}')
          .join(';');
      buffer.writeln(
        '${inquiry.id},${inquiry.status},${inquiry.createdByUserId},${inquiry.branchId},${inquiry.deadline.toIso8601String()},${inquiry.createdAt.toIso8601String()},$offersSummary',
      );
    }
    return Response(headers: {'content-type': 'text/csv'}, body: buffer.toString());
  }
  final body = inquiries.map((inquiry) => inquiry.toJson()).toList();
  return Response.json(body: body);
}

Future<Response> _handleCreate(RequestContext context) async {
  final auth = parseAuth(
    context,
    secret: const String.fromEnvironment('JWT_SECRET', defaultValue: 'som_dev_secret'),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final companyRepo = context.read<CompanyRepository>();
  final userRepo = context.read<UserRepository>();
  final inquiryRepo = context.read<InquiryRepository>();
  final storage = context.read<FileStorage>();

  Map<String, dynamic> data;
  String? pdfPath;
  if (context.request.headers['content-type']?.contains('multipart/form-data') ?? false) {
    final form = await context.request.formData();
    data = form.fields.map((key, value) => MapEntry(key, value));
    final file = form.files['file'];
    if (file != null) {
      final bytes = await file.readAsBytes();
      pdfPath = await storage.saveFile(
        category: 'inquiries',
        fileName: file.name,
        bytes: bytes,
      );
    }
  } else {
    data = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  }

  final deadline = DateTime.parse(data['deadline'] as String);
  if (!isAtLeastBusinessDaysInFuture(deadline, 3)) {
    return Response.json(statusCode: 400, body: 'Deadline must be at least 3 business days in the future');
  }

  final company = companyRepo.findById(auth.companyId);
  final user = userRepo.findById(auth.userId);
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
        : (data['productTags'] as String? ?? '').split(',').where((e) => e.isNotEmpty).toList(),
    deadline: deadline,
    deliveryZips: (data['deliveryZips'] is List)
        ? (data['deliveryZips'] as List).map((e) => e.toString()).toList()
        : (data['deliveryZips'] as String? ?? '').split(',').where((e) => e.isNotEmpty).toList(),
    numberOfProviders: int.parse(data['numberOfProviders']?.toString() ?? '1'),
    description: data['description'] as String?,
    pdfPath: pdfPath,
    providerCriteria: ProviderCriteria(
      providerZip: data['providerZip'] as String?,
      radiusKm: data['radiusKm'] == null ? null : int.tryParse(data['radiusKm'].toString()),
      providerType: data['providerType'] as String?,
      companySize: data['providerCompanySize'] as String?,
    ),
    contactInfo: contact,
    notifiedAt: null,
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

  inquiryRepo.create(inquiry);
  return Response.json(body: inquiry.toJson());
}
