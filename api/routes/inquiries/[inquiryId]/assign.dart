import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String inquiryId) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null || !auth.roles.contains('consultant')) {
    return Response(statusCode: 403);
  }
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final providerIds = (body['providerCompanyIds'] as List<dynamic>? ?? [])
      .map((e) => e.toString())
      .toList();
  if (providerIds.isEmpty) {
    return Response(statusCode: 400);
  }
  final inquiryRepo = context.read<InquiryRepository>();
  final inquiry = await inquiryRepo.findById(inquiryId);
  if (inquiry == null) {
    return Response(statusCode: 404);
  }
  final existingAssignments =
      await inquiryRepo.countAssignmentsForInquiry(inquiryId);
  if (existingAssignments >= inquiry.numberOfProviders) {
    return Response.json(
      statusCode: 400,
      body: 'Assignment cap reached for this inquiry.',
    );
  }
  final providerRepo = context.read<ProviderRepository>();
  final activeProviderIds = <String>[];
  final skippedProviderIds = <String>[];
  for (final providerId in providerIds) {
    final profile = await providerRepo.findByCompany(providerId);
    final alreadyAssigned =
        await inquiryRepo.isAssignedToProvider(inquiryId, providerId);
    if (profile != null && profile.status == 'active' && !alreadyAssigned) {
      activeProviderIds.add(providerId);
    } else {
      skippedProviderIds.add(providerId);
    }
  }
  if (activeProviderIds.isEmpty) {
    return Response.json(
      statusCode: 400,
      body: 'No active providers available for assignment',
    );
  }
  final remainingSlots = inquiry.numberOfProviders - existingAssignments;
  if (activeProviderIds.length > remainingSlots) {
    return Response.json(
      statusCode: 400,
      body: 'Assignment exceeds available provider slots.',
    );
  }
  await inquiryRepo.assignToProviders(
    inquiryId: inquiryId,
    assignedByUserId: auth.userId,
    providerCompanyIds: activeProviderIds,
  );
  final email = context.read<EmailService>();
  final userRepo = context.read<UserRepository>();
  for (final providerId in activeProviderIds) {
    final admins = await userRepo.listAdminsByCompany(providerId);
    for (final admin in admins) {
      await email.send(
        to: admin.email,
        subject: 'New inquiry assigned',
        text:
            'A new inquiry has been assigned to your company. Inquiry ID: $inquiryId',
      );
    }
  }
  return Response.json(
    body: {
      'assignedProviders': activeProviderIds,
      'skippedProviders': skippedProviderIds,
    },
  );
}
