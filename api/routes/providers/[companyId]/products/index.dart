import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/product_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String companyId) async {
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
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
  if (context.request.method == HttpMethod.get) {
    final products = await repo.listByCompany(companyId);
    final body = products
        .map((product) => {
              'id': product.id,
              'companyId': product.companyId,
              'name': product.name,
              'createdAt': product.createdAt.toIso8601String(),
            })
        .toList();
    return Response.json(body: body);
  }
  if (context.request.method == HttpMethod.post) {
    final payload =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final name = (payload['name'] as String? ?? '').trim();
    if (name.isEmpty) {
      return Response.json(statusCode: 400, body: 'Product name is required.');
    }
    final product = ProductRecord(
      id: const Uuid().v4(),
      companyId: companyId,
      name: name,
      createdAt: DateTime.now().toUtc(),
    );
    await repo.create(product);
    return Response.json(
      body: {
        'id': product.id,
        'companyId': product.companyId,
        'name': product.name,
        'createdAt': product.createdAt.toIso8601String(),
      },
    );
  }
  return Response(statusCode: 405);
}
