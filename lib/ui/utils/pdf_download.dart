import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:som/ui/widgets/snackbars.dart';

Future<void> openInquiryPdf(
  BuildContext context, {
  required String inquiryId,
}) async {
  final api = Provider.of<Openapi>(context, listen: false);
  try {
    final response = await api
        .getInquiriesApi()
        .inquiriesInquiryIdPdfGet(inquiryId: inquiryId);
    final signedUrl = response.data?.signedUrl;
    if (signedUrl == null || signedUrl.isEmpty) {
      throw StateError('Missing signed URL');
    }
    await launchUrl(
      Uri.parse(signedUrl),
      mode: LaunchMode.externalApplication,
    );
  } on DioException {
    if (!context.mounted) return;
    SomSnackBars.error(context, 'Failed to download PDF.');
  } catch (_) {
    if (!context.mounted) return;
    SomSnackBars.error(context, 'Failed to download PDF.');
  }
}

Future<void> generateInquirySummaryPdf(
  BuildContext context, {
  required String inquiryId,
}) async {
  final api = Provider.of<Openapi>(context, listen: false);
  try {
    final response = await api.dio.post('/inquiries/$inquiryId/pdf/generate');
    final signedUrl = _extractSignedUrl(response.data);
    if (signedUrl == null || signedUrl.isEmpty) {
      throw StateError('Missing signed URL');
    }
    await launchUrl(
      Uri.parse(signedUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!context.mounted) return;
    SomSnackBars.success(context, 'Summary PDF generated.');
  } on DioException {
    if (!context.mounted) return;
    SomSnackBars.error(context, 'Failed to generate summary PDF.');
  } catch (_) {
    if (!context.mounted) return;
    SomSnackBars.error(context, 'Failed to generate summary PDF.');
  }
}

Future<void> openOfferPdf(
  BuildContext context, {
  required String offerId,
}) async {
  final api = Provider.of<Openapi>(context, listen: false);
  try {
    final response =
        await api.getOffersApi().offersOfferIdPdfGet(offerId: offerId);
    final signedUrl = response.data?.signedUrl;
    if (signedUrl == null || signedUrl.isEmpty) {
      throw StateError('Missing signed URL');
    }
    await launchUrl(
      Uri.parse(signedUrl),
      mode: LaunchMode.externalApplication,
    );
  } on DioException {
    if (!context.mounted) return;
    SomSnackBars.error(context, 'Failed to download PDF.');
  } catch (_) {
    if (!context.mounted) return;
    SomSnackBars.error(context, 'Failed to download PDF.');
  }
}

Future<void> generateOfferSummaryPdf(
  BuildContext context, {
  required String offerId,
}) async {
  final api = Provider.of<Openapi>(context, listen: false);
  try {
    final response = await api.dio.post('/offers/$offerId/pdf/generate');
    final signedUrl = _extractSignedUrl(response.data);
    if (signedUrl == null || signedUrl.isEmpty) {
      throw StateError('Missing signed URL');
    }
    await launchUrl(
      Uri.parse(signedUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!context.mounted) return;
    SomSnackBars.success(context, 'Summary PDF generated.');
  } on DioException {
    if (!context.mounted) return;
    SomSnackBars.error(context, 'Failed to generate summary PDF.');
  } catch (_) {
    if (!context.mounted) return;
    SomSnackBars.error(context, 'Failed to generate summary PDF.');
  }
}

String? _extractSignedUrl(dynamic data) {
  if (data is Map<String, dynamic>) {
    return data['signedUrl'] as String?;
  }
  if (data is Map) {
    final value = data['signedUrl'];
    return value is String ? value : null;
  }
  return null;
}
