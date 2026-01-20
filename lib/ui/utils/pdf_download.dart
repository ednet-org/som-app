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
