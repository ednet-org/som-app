import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
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
  await inquiryRepo.assignToProviders(
    inquiryId: inquiryId,
    assignedByUserId: auth.userId,
    providerCompanyIds: providerIds,
  );
  final email = context.read<EmailService>();
  final userRepo = context.read<UserRepository>();
  for (final providerId in providerIds) {
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
  return Response(statusCode: 200);
}
