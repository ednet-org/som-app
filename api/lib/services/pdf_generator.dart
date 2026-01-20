import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/models.dart';

class PdfGenerator {
  Future<Uint8List> generateInquirySummary({
    required InquiryRecord inquiry,
    CompanyRecord? buyerCompany,
    List<OfferRecord> offers = const [],
    Map<String, String> providerNames = const {},
  }) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Inquiry Summary', style: pw.TextStyle(fontSize: 20)),
            pw.SizedBox(height: 12),
            _keyValue('Inquiry ID', inquiry.id),
            _keyValue('Status', inquiry.status),
            _keyValue('Buyer Company', buyerCompany?.name ?? ''),
            _keyValue('Deadline', inquiry.deadline.toIso8601String()),
            _keyValue('Branch', inquiry.branchId),
            _keyValue('Description', inquiry.description ?? ''),
            pw.SizedBox(height: 12),
            pw.Text('Offers', style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 6),
            if (offers.isEmpty)
              pw.Text('No offers yet.')
            else
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: offers.map((offer) {
                  final providerName =
                      providerNames[offer.providerCompanyId] ?? '';
                  return pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 6),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Offer ${offer.id}'),
                        _keyValue('Provider', providerName),
                        _keyValue('Buyer decision', offer.buyerDecision ?? ''),
                        _keyValue(
                            'Provider decision', offer.providerDecision ?? ''),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
    return doc.save();
  }

  Future<Uint8List> generateOfferSummary({
    required OfferRecord offer,
    required InquiryRecord inquiry,
    CompanyRecord? buyerCompany,
    CompanyRecord? providerCompany,
  }) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Offer Summary', style: pw.TextStyle(fontSize: 20)),
            pw.SizedBox(height: 12),
            _keyValue('Offer ID', offer.id),
            _keyValue('Inquiry ID', inquiry.id),
            _keyValue('Buyer Company', buyerCompany?.name ?? ''),
            _keyValue('Provider Company', providerCompany?.name ?? ''),
            _keyValue('Status', offer.status),
            _keyValue('Buyer decision', offer.buyerDecision ?? ''),
            _keyValue('Provider decision', offer.providerDecision ?? ''),
            _keyValue('Deadline', inquiry.deadline.toIso8601String()),
          ],
        ),
      ),
    );
    return doc.save();
  }

  pw.Widget _keyValue(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Text('$label: $value'),
    );
  }
}
