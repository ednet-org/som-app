import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/subscription_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    final repository = context.read<SubscriptionRepository>();
    final plans = await repository.listPlans();
    final body = {
      'subscriptions': plans.map((plan) => plan.toDtoJson()).toList(),
    };
    return Response.json(body: body);
  }
  if (context.request.method == HttpMethod.post) {
    final auth = await parseAuth(
      context,
      secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
          defaultValue: 'som_dev_secret'),
      users: context.read<UserRepository>(),
    );
    if (auth == null || !auth.roles.contains('consultant')) {
      return Response(statusCode: 403);
    }
    if (!auth.roles.contains('admin')) {
      return Response(statusCode: 403);
    }
    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final title = body['title'] as String? ?? '';
    final sortPriority = body['sortPriority'] as int? ?? 0;
    final isActive = body['isActive'] as bool? ?? false;
    final priceInSubunit = body['priceInSubunit'] as int? ?? 0;
    final rules = (body['rules'] as List<dynamic>? ?? [])
        .map((e) => (e as Map).map((key, value) => MapEntry(key.toString(), value)))
        .toList();
    if (title.isEmpty) {
      return Response.json(statusCode: 400, body: 'Title is required');
    }
    final now = DateTime.now().toUtc();
    final plan = SubscriptionPlanRecord(
      id: const Uuid().v4(),
      name: title,
      sortPriority: sortPriority,
      isActive: isActive,
      priceInSubunit: priceInSubunit,
      rules: rules,
      createdAt: now,
    );
    final repository = context.read<SubscriptionRepository>();
    await repository.createPlan(plan);
    return Response.json(body: plan.toDtoJson());
  }
  return Response(statusCode: 405);
}
