import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/application/application.dart';
import '../../domain/model/layout/app_body.dart';
import '../../utils/ui_logger.dart';

const _apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:8081',
);

class OffersAppBody extends StatefulWidget {
  const OffersAppBody({Key? key}) : super(key: key);

  @override
  State<OffersAppBody> createState() => _OffersAppBodyState();
}

class _OffersAppBodyState extends State<OffersAppBody> {
  Future<List<_OfferWithInquiry>>? _offersFuture;
  List<_OfferWithInquiry> _offers = const [];
  _OfferWithInquiry? _selected;
  String? _statusFilter;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _offersFuture ??= _loadOffers();
  }

  Future<List<_OfferWithInquiry>> _loadOffers() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final appStore = Provider.of<Application>(context, listen: false);

    final allOffers = <_OfferWithInquiry>[];

    try {
      final inquiriesResponse = await api.getInquiriesApi().inquiriesGet();
      final inquiries = inquiriesResponse.data?.toList() ?? [];

      for (final inquiry in inquiries) {
        if (inquiry.id == null) continue;
        try {
          final offersResponse = await api.getOffersApi().inquiriesInquiryIdOffersGet(
            inquiryId: inquiry.id!,
          );
          final offers = offersResponse.data?.toList() ?? [];
          for (final offer in offers) {
            if (_statusFilter == null || offer.status == _statusFilter) {
              allOffers.add(_OfferWithInquiry(
                offer: offer,
                inquiryTitle: inquiry.description?.substring(0, inquiry.description!.length > 50 ? 50 : inquiry.description!.length) ?? 'Inquiry ${inquiry.id}',
                inquiryId: inquiry.id!,
              ));
            }
          }
        } catch (error, stackTrace) {
          UILogger.silentError('OffersAppBody._loadOffers.inquiry_${inquiry.id}', error, stackTrace);
        }
      }
    } catch (error, stackTrace) {
      UILogger.silentError('OffersAppBody._loadOffers.inquiries', error, stackTrace);
    }

    _offers = allOffers;
    return allOffers;
  }

  Future<void> _refresh() async {
    setState(() {
      _offersFuture = _loadOffers();
    });
  }

  Future<void> _acceptOffer(_OfferWithInquiry item) async {
    if (item.offer.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getOffersApi().offersOfferIdAcceptPost(offerId: item.offer.id!);
      _showSnackbar('Offer accepted.');
      await _refresh();
    } on DioException catch (error) {
      setState(() => _error = _extractError(error));
    }
  }

  Future<void> _rejectOffer(_OfferWithInquiry item) async {
    if (item.offer.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getOffersApi().offersOfferIdRejectPost(offerId: item.offer.id!);
      _showSnackbar('Offer rejected.');
      await _refresh();
    } on DioException catch (error) {
      setState(() => _error = _extractError(error));
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _extractError(DioException error) {
    final data = error.response?.data;
    if (data is String) return data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return error.message ?? 'Request failed.';
  }

  void _selectOffer(_OfferWithInquiry item) {
    setState(() {
      _selected = item;
      _error = null;
    });
  }

  void _applyFilter(String? status) {
    setState(() {
      _statusFilter = status;
      _offersFuture = _loadOffers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    final isBuyer = appStore.authorization?.isBuyer ?? false;

    return FutureBuilder<List<_OfferWithInquiry>>(
      future: _offersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppBody(
            contextMenu: Text('Offers'),
            leftSplit: Center(child: CircularProgressIndicator()),
            rightSplit: SizedBox.shrink(),
          );
        }
        if (snapshot.hasError) {
          return AppBody(
            contextMenu: const Text('Offers'),
            leftSplit: Center(
              child: Text('Failed to load offers: ${snapshot.error}'),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final offers = snapshot.data ?? const [];
        return AppBody(
          contextMenu: _buildContextMenu(),
          leftSplit: _buildOffersList(offers),
          rightSplit: _buildOfferDetails(isBuyer),
        );
      },
    );
  }

  Widget _buildContextMenu() {
    return Row(
      children: [
        const Text('Offers'),
        const SizedBox(width: 12),
        TextButton(onPressed: _refresh, child: const Text('Refresh')),
        const SizedBox(width: 12),
        DropdownButton<String?>(
          value: _statusFilter,
          hint: const Text('All Status'),
          items: const [
            DropdownMenuItem(value: null, child: Text('All Status')),
            DropdownMenuItem(value: 'pending', child: Text('Pending')),
            DropdownMenuItem(value: 'accepted', child: Text('Accepted')),
            DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
          ],
          onChanged: _applyFilter,
        ),
      ],
    );
  }

  Widget _buildOffersList(List<_OfferWithInquiry> offers) {
    if (offers.isEmpty) {
      return const Center(child: Text('No offers found.'));
    }
    return ListView.builder(
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final item = offers[index];
        return ListTile(
          title: Text(item.inquiryTitle),
          subtitle: Text('Status: ${item.offer.status ?? 'pending'}'),
          selected: _selected?.offer.id == item.offer.id,
          onTap: () => _selectOffer(item),
          trailing: _statusBadge(item.offer.status),
        );
      },
    );
  }

  Widget _buildOfferDetails(bool isBuyer) {
    if (_selected == null) {
      return const Center(child: Text('Select an offer to view details.'));
    }
    final offer = _selected!.offer;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          Text(
            'Offer Details',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _detailRow('Offer ID', offer.id ?? '-'),
          _detailRow('Inquiry', _selected!.inquiryTitle),
          _detailRow('Provider Company', offer.providerCompanyId ?? '-'),
          _detailRow('Status', offer.status ?? 'pending'),
          _detailRow('Forwarded', _formatDate(offer.forwardedAt)),
          _detailRow('Resolved', _formatDate(offer.resolvedAt)),
          _detailRow('Buyer Decision', offer.buyerDecision ?? '-'),
          _detailRow('Provider Decision', offer.providerDecision ?? '-'),
          if (offer.pdfPath != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => _openPdf(offer.pdfPath!),
              icon: const Icon(Icons.download),
              label: const Text('Download PDF'),
            ),
          ],
          const Divider(height: 32),
          if (isBuyer && offer.status == 'pending') ...[
            Text(
              'Actions',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _acceptOffer(_selected!),
                  icon: const Icon(Icons.check),
                  label: const Text('Accept'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => _rejectOffer(_selected!),
                  icon: const Icon(Icons.close),
                  label: const Text('Reject'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _statusBadge(String? status) {
    Color color;
    switch (status?.toLowerCase()) {
      case 'accepted':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status ?? 'pending',
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _openPdf(String pdfPath) async {
    final url = pdfPath.startsWith('http') ? pdfPath : '$_apiBaseUrl$pdfPath';
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (error) {
      _showSnackbar('Failed to open PDF.');
    }
  }
}

class _OfferWithInquiry {
  final Offer offer;
  final String inquiryTitle;
  final String inquiryId;

  const _OfferWithInquiry({
    required this.offer,
    required this.inquiryTitle,
    required this.inquiryId,
  });
}
