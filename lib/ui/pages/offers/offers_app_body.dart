import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';

import '../../domain/application/application.dart';
import '../../domain/infrastructure/supabase_realtime.dart';
import '../../domain/model/layout/app_body.dart';
import '../../theme/tokens.dart';
import '../../utils/formatters.dart';
import '../../utils/pdf_download.dart';
import '../../utils/ui_logger.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/detail_section.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/status_badge.dart';

class OffersAppBody extends StatefulWidget {
  const OffersAppBody({super.key});

  @override
  State<OffersAppBody> createState() => _OffersAppBodyState();
}

class _OffersAppBodyState extends State<OffersAppBody> {
  Future<List<_OfferWithInquiry>>? _offersFuture;
  _OfferWithInquiry? _selected;
  String? _statusFilter;
  String? _error;
  bool _realtimeReady = false;
  late final RealtimeRefreshHandle _realtimeRefresh =
      RealtimeRefreshHandle(_handleRealtimeRefresh);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _offersFuture ??= _loadOffers();
    _setupRealtime();
  }

  @override
  void dispose() {
    _realtimeRefresh.dispose();
    super.dispose();
  }

  void _handleRealtimeRefresh() {
    if (!mounted) return;
    _refresh();
  }

  void _setupRealtime() {
    if (_realtimeReady) return;
    final appStore = Provider.of<Application>(context, listen: false);
    SupabaseRealtime.setAuth(appStore.authorization?.token);
    _realtimeRefresh.subscribe(
      tables: const ['offers', 'inquiries'],
      channelName: 'offers-page',
    );
    _realtimeReady = true;
  }

  Future<List<_OfferWithInquiry>> _loadOffers() async {
    final api = Provider.of<Openapi>(context, listen: false);

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
                inquiryTitle: inquiry.description?.isNotEmpty == true
                    ? SomFormatters.truncate(inquiry.description, 50)
                    : 'Inquiry ${SomFormatters.shortId(inquiry.id)}',
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
    return AppToolbar(
      title: const Text('Offers'),
      actions: [
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
      return const EmptyState(
        asset: SomAssets.emptySearchResults,
        title: 'No offers found',
        message: 'Offers will appear here once they are submitted',
      );
    }
    return ListView.builder(
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final item = offers[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: SomSpacing.md,
            vertical: SomSpacing.xs,
          ),
          title: Text(item.inquiryTitle),
          subtitle: Text(
            item.offer.resolvedAt != null
                ? 'Resolved ${SomFormatters.relative(item.offer.resolvedAt)}'
                : 'Forwarded ${SomFormatters.relative(item.offer.forwardedAt)}',
          ),
          selected: _selected?.offer.id == item.offer.id,
          onTap: () => _selectOffer(item),
          trailing: StatusBadge.offer(
            status: item.offer.status ?? 'pending',
            compact: false,
            showIcon: false,
          ),
        );
      },
    );
  }

  Widget _buildOfferDetails(bool isBuyer) {
    if (_selected == null) {
      return const EmptyState(
        asset: SomAssets.emptySearchResults,
        title: 'Select an offer',
        message: 'Choose an offer from the list to view details',
      );
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
          Row(
            children: [
              Expanded(
                child: Text(
                  'Offer Details',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              StatusBadge.offer(status: offer.status ?? 'pending'),
            ],
          ),
          const SizedBox(height: SomSpacing.md),
          DetailSection(
            title: 'Summary',
            iconAsset: SomAssets.iconInfo,
            child: Column(
              children: [
                DetailRow(
                  label: 'Offer ID',
                  value: SomFormatters.shortId(offer.id),
                ),
                DetailRow(
                  label: 'Inquiry',
                  value: _selected!.inquiryTitle,
                ),
                DetailRow(
                  label: 'Provider',
                  value: SomFormatters.shortId(offer.providerCompanyId),
                ),
                DetailRow(
                  label: 'Forwarded',
                  value: SomFormatters.dateTime(offer.forwardedAt),
                ),
                DetailRow(
                  label: 'Resolved',
                  value: SomFormatters.dateTime(offer.resolvedAt),
                ),
              ],
            ),
          ),
          const SizedBox(height: SomSpacing.md),
          DetailSection(
            title: 'Decisions',
            iconAsset: SomAssets.iconWarning,
            child: Column(
              children: [
                DetailRow(
                  label: 'Buyer',
                  value: offer.buyerDecision ?? '-',
                ),
                DetailRow(
                  label: 'Provider',
                  value: offer.providerDecision ?? '-',
                ),
              ],
            ),
          ),
          if (offer.pdfPath != null) ...[
            const SizedBox(height: SomSpacing.md),
            FilledButton.tonalIcon(
              onPressed: offer.id == null
                  ? null
                  : () => _openOfferPdf(offer.id!),
              icon: SomSvgIcon(
                SomAssets.iconPdf,
                size: SomIconSize.sm,
                color: Theme.of(context).colorScheme.primary,
              ),
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
            Wrap(
              spacing: SomSpacing.sm,
              children: [
                FilledButton.icon(
                  onPressed: () => _acceptOffer(_selected!),
                  icon: SomSvgIcon(
                    SomAssets.offerStatusAccepted,
                    size: SomIconSize.sm,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: const Text('Accept'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _rejectOffer(_selected!),
                  icon: SomSvgIcon(
                    SomAssets.offerStatusRejected,
                    size: SomIconSize.sm,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: const Text('Reject'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openOfferPdf(String offerId) async {
    await openOfferPdf(
      context,
      offerId: offerId,
    );
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
