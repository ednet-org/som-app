import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/file_validation.dart';
import 'package:som_api/services/file_storage.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context, String inquiryId) async {
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null) {
    return Response(statusCode: 401);
  }
  if (context.request.method == HttpMethod.get) {
    final inquiryRepo = context.read<InquiryRepository>();
    final inquiry = await inquiryRepo.findById(inquiryId);
    if (inquiry == null) {
      return Response(statusCode: 404);
    }
    final isConsultant = auth.roles.contains('consultant');
    if (!isConsultant) {
      if (auth.activeRole == 'buyer') {
        if (inquiry.buyerCompanyId != auth.companyId) {
          return Response(statusCode: 403);
        }
      } else if (auth.activeRole == 'provider') {
        final provider = await context
            .read<ProviderRepository>()
            .findByCompany(auth.companyId);
        if (provider == null || provider.status != 'active') {
          return Response.json(
            statusCode: 403,
            body: 'Provider registration is pending.',
          );
        }
        final assigned = await inquiryRepo.isAssignedToProvider(
          inquiryId,
          auth.companyId,
        );
        if (!assigned) {
          return Response.json(
            statusCode: 403,
            body: 'Inquiry not assigned to provider.',
          );
        }
      } else {
        return Response(statusCode: 403);
      }
    }
    final pdfPath = inquiry.pdfPath;
    if (pdfPath == null || pdfPath.isEmpty) {
      return Response(statusCode: 404);
    }
    final signedUrl =
        await context.read<FileStorage>().createSignedUrl(pdfPath);
    if (signedUrl.isEmpty) {
      return Response(statusCode: 404);
    }
    await context.read<AuditService>().log(
          action: 'inquiry.pdf.downloaded',
          entityType: 'inquiry',
          entityId: inquiryId,
          actorId: auth.userId,
          metadata: {'companyId': auth.companyId},
        );
    return Response.json(body: {'signedUrl': signedUrl});
  }
  if (context.request.method == HttpMethod.delete) {
    final inquiryRepo = context.read<InquiryRepository>();
    final inquiry = await inquiryRepo.findById(inquiryId);
    if (inquiry == null) {
      return Response(statusCode: 404);
    }
    final isConsultant = auth.roles.contains('consultant');
    final isBuyer = auth.activeRole == 'buyer';
    final ownsInquiry = inquiry.buyerCompanyId == auth.companyId;
    if (!isConsultant && !(isBuyer && ownsInquiry)) {
      return Response(statusCode: 403);
    }
    final pdfPath = inquiry.pdfPath;
    if (pdfPath != null && pdfPath.isNotEmpty) {
      await context.read<FileStorage>().deleteFile(pdfPath);
    }
    await inquiryRepo.clearPdfPath(inquiryId);
    return Response(statusCode: 200);
  }
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  if (auth.activeRole != 'buyer') {
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
  final validationError = validatePdfUpload(fileName: file.name, bytes: bytes);
  if (validationError != null) {
    return Response.json(statusCode: 400, body: validationError);
  }
  final storage = context.read<FileStorage>();
  final pdfPath = await storage.saveFile(
    category: 'inquiries',
    fileName: file.name,
    bytes: bytes,
  );
  await context.read<InquiryRepository>().updatePdfPath(inquiryId, pdfPath);
  return Response.json(body: {'pdfPath': pdfPath});
}
