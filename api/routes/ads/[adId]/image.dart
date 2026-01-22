import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/ads_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/file_storage.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String adId) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
    users: context.read<UserRepository>(),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  final repo = context.read<AdsRepository>();
  final existing = await repo.findById(adId);
  if (existing == null) {
    return Response(statusCode: 404);
  }
  final canManage = auth.roles.contains('consultant') ||
      (auth.activeRole == 'provider' && existing.companyId == auth.companyId);
  if (!canManage) {
    return Response(statusCode: 403);
  }
  if (!(context.request.headers['content-type']
          ?.contains('multipart/form-data') ??
      false)) {
    return Response.json(
        statusCode: 400, body: 'Multipart form-data is required');
  }
  final form = await context.request.formData();
  final file = form.files['file'];
  if (file == null) {
    return Response.json(statusCode: 400, body: 'file is required');
  }
  final bytes = await file.readAsBytes();
  final storage = context.read<FileStorage>();
  final imagePath = await storage.saveFile(
    category: 'ads',
    fileName: file.name,
    bytes: bytes,
  );
  final updated = AdRecord(
    id: existing.id,
    companyId: existing.companyId,
    type: existing.type,
    status: existing.status,
    branchId: existing.branchId,
    url: existing.url,
    imagePath: imagePath,
    headline: existing.headline,
    description: existing.description,
    startDate: existing.startDate,
    endDate: existing.endDate,
    bannerDate: existing.bannerDate,
    createdAt: existing.createdAt,
    updatedAt: DateTime.now().toUtc(),
  );
  await repo.update(updated);
  return Response.json(body: {'imagePath': imagePath});
}
