import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/product_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(
  RequestContext context,
  String companyId,
  String productId,
) async {
  final auth = await parseAuth(
    context,
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
    users: context.read<UserRepository>(),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final isConsultant = auth.roles.contains('consultant');
  final isAdmin = auth.roles.contains('admin') && auth.companyId == companyId;
  if (!isConsultant && !isAdmin) {
    return Response(statusCode: 403);
  }
  final companyRepo = context.read<CompanyRepository>();
  final company = await companyRepo.findById(companyId);
  if (company == null) {
    return Response(statusCode: 404);
  }
  if (company.type != 'provider' && company.type != 'buyer_provider') {
    return Response.json(statusCode: 400, body: 'Company is not a provider.');
  }
  final repo = context.read<ProductRepository>();
  final existing = await repo.findById(productId);
  if (existing == null || existing.companyId != companyId) {
    return Response(statusCode: 404);
  }

  if (context.request.method == HttpMethod.put) {
    final payload =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final name = (payload['name'] as String? ?? '').trim();
    if (name.isEmpty) {
      return Response.json(statusCode: 400, body: 'Product name is required.');
    }
    final updated = ProductRecord(
      id: existing.id,
      companyId: existing.companyId,
      name: name,
      createdAt: existing.createdAt,
    );
    await repo.update(updated);
    return Response.json(
      body: {
        'id': updated.id,
        'companyId': updated.companyId,
        'name': updated.name,
        'createdAt': updated.createdAt.toIso8601String(),
      },
    );
  }

  if (context.request.method == HttpMethod.delete) {
    await repo.delete(productId);
    return Response(statusCode: 200);
  }
  return Response(statusCode: 405);
}
