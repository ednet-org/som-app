import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/domain_event_service.dart';
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
    await context.read<DomainEventService>().emitFailure(
          type: 'inquiry.assignment',
          entityType: 'inquiry',
          entityId: inquiryId,
          actorId: auth.userId,
          payload: {'reason': 'cap_reached'},
        );
    return Response.json(
      statusCode: 400,
      body: 'Assignment cap reached for this inquiry.',
    );
  }
  final providerRepo = context.read<ProviderRepository>();
  final subscriptionRepo = context.read<SubscriptionRepository>();
  final activeProviderIds = <String>[];
  final skippedProviderIds = <String>[];
  final now = DateTime.now().toUtc();
  for (final providerId in providerIds) {
    final profile = await providerRepo.findByCompany(providerId);
    final subscription =
        await subscriptionRepo.findSubscriptionByCompany(providerId);
    final subscriptionActive = subscription != null &&
        subscription.status == 'active' &&
        !subscription.endDate.isBefore(now);
    final alreadyAssigned =
        await inquiryRepo.isAssignedToProvider(inquiryId, providerId);
    if (profile != null &&
        profile.status == 'active' &&
        subscriptionActive &&
        !alreadyAssigned) {
      activeProviderIds.add(providerId);
    } else {
      skippedProviderIds.add(providerId);
    }
  }
  if (activeProviderIds.isEmpty) {
    await context.read<DomainEventService>().emitFailure(
          type: 'inquiry.assignment',
          entityType: 'inquiry',
          entityId: inquiryId,
          actorId: auth.userId,
          payload: {'reason': 'no_active_providers'},
        );
    return Response.json(
      statusCode: 400,
      body: 'No active providers available for assignment',
    );
  }
  final remainingSlots = inquiry.numberOfProviders - existingAssignments;
  if (activeProviderIds.length > remainingSlots) {
    await context.read<DomainEventService>().emitFailure(
          type: 'inquiry.assignment',
          entityType: 'inquiry',
          entityId: inquiryId,
          actorId: auth.userId,
          payload: {'reason': 'exceeds_slots'},
        );
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
  await context.read<DomainEventService>().emit(
        type: 'inquiry.assigned',
        entityType: 'inquiry',
        entityId: inquiryId,
        actorId: auth.userId,
        payload: {'providerCompanyIds': activeProviderIds},
      );
  return Response.json(
    body: {
      'assignedProviders': activeProviderIds,
      'skippedProviders': skippedProviderIds,
    },
  );
}
