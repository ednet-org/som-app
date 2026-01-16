import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openSignedPdf(
  BuildContext context, {
  required String endpoint,
}) async {
  final api = Provider.of<Openapi>(context, listen: false);
  try {
    final response = await api.dio.get(endpoint);
    final data = response.data;
    final signedUrl = data is Map<String, dynamic>
        ? data['signedUrl']?.toString()
        : null;
    if (signedUrl == null || signedUrl.isEmpty) {
      throw StateError('Missing signed URL');
    }
    await launchUrl(
      Uri.parse(signedUrl),
      mode: LaunchMode.externalApplication,
    );
  } on DioException {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to download PDF.')),
    );
  } catch (_) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to download PDF.')),
    );
  }
}
