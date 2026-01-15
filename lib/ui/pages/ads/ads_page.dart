import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';

import '../../domain/application/application.dart';
import '../../domain/model/layout/app_body.dart';
import '../../utils/ui_logger.dart';
import 'widgets/ads_buyer_view.dart';
import 'widgets/ads_create_form.dart';
import 'widgets/ads_edit_form.dart';
import 'widgets/ads_filters.dart';
import 'widgets/ads_list.dart';

/// Main page for ad management.
///
/// Orchestrates ad list, create/edit forms, filters, and buyer view.
class AdsPage extends StatefulWidget {
  const AdsPage({super.key});

  @override
  State<AdsPage> createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  Future<List<Ad>>? _adsFuture;
  Ad? _selectedAd;
  List<Branch> _branches = const [];

  String? _filterBranchId;
  String? _filterStatus;
  String? _filterType;

  bool _showCreateForm = false;
  bool _bootstrapped = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _adsFuture ??= _loadAds();
    if (!_bootstrapped) {
      _bootstrapped = true;
      _bootstrap();
    }
  }

  Future<void> _bootstrap() async {
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final response = await api.getBranchesApi().branchesGet();
      setState(() {
        _branches = response.data?.toList() ?? const [];
      });
    } catch (error, stackTrace) {
      UILogger.silentError('AdsPage._bootstrap.branches', error, stackTrace);
    }
  }

  Future<List<Ad>> _loadAds() async {
    final appStore = Provider.of<Application>(context, listen: false);
    final api = Provider.of<Openapi>(context, listen: false);
    final scope = appStore.authorization?.isConsultant == true
        ? 'all'
        : appStore.authorization?.isProvider == true
            ? 'company'
            : null;
    final response = await api.getAdsApi().adsGet(
          branchId: _filterBranchId,
          status: _filterStatus,
          scope: scope,
        );
    return response.data?.toList() ?? const [];
  }

  Future<void> _refresh() async {
    setState(() {
      _adsFuture = _loadAds();
    });
  }

  void _clearFilters() {
    setState(() {
      _filterBranchId = null;
      _filterStatus = null;
      _filterType = null;
    });
    _refresh();
  }

  Future<void> _selectAd(Ad ad) async {
    setState(() {
      _selectedAd = ad;
    });
  }

  Future<void> _createAd(AdFormData data) async {
    final api = Provider.of<Openapi>(context, listen: false);
    final response = await api.getAdsApi().createAd(
          createAdRequest: CreateAdRequest((b) => b
            ..type = data.type
            ..status = CreateAdRequestStatusEnum.draft
            ..branchId = data.branchId
            ..url = data.url
            ..headline = data.headline
            ..description = data.description
            ..startDate = data.startDate?.toIso8601String()
            ..endDate = data.endDate?.toIso8601String()
            ..bannerDate = data.bannerDate?.toIso8601String()),
        );
    final adId = response.data?.id;
    if (adId != null && data.image?.bytes != null) {
      await api.getAdsApi().adsAdIdImagePost(
            adId: adId,
            file: MultipartFile.fromBytes(
              data.image!.bytes!,
              filename: data.image!.name,
            ),
          );
    }
    _showSnack('Ad created.');
    setState(() => _showCreateForm = false);
    await _refresh();
  }

  Future<void> _updateAd(AdEditData data) async {
    if (_selectedAd?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    final updated = _selectedAd!.rebuild((b) => b
      ..url = data.url
      ..headline = data.headline.isEmpty ? null : data.headline
      ..description = data.description.isEmpty ? null : data.description
      ..startDate = data.startDate
      ..endDate = data.endDate
      ..bannerDate = data.bannerDate);
    await api.getAdsApi().adsAdIdPut(adId: updated.id!, ad: updated);
    if (data.image?.bytes != null) {
      await api.getAdsApi().adsAdIdImagePost(
            adId: updated.id!,
            file: MultipartFile.fromBytes(
              data.image!.bytes!,
              filename: data.image!.name,
            ),
          );
    }
    _showSnack('Ad updated.');
    await _refresh();
  }

  Future<void> _activateAd() async {
    if (_selectedAd?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getAdsApi().adsAdIdActivatePost(
            adId: _selectedAd!.id!,
            adActivationRequest: AdActivationRequest((b) => b
              ..startDate = _selectedAd!.startDate
              ..endDate = _selectedAd!.endDate
              ..bannerDate = _selectedAd!.bannerDate),
          );
      _showSnack('Ad activated.');
      await _refresh();
    } catch (error) {
      _showSnack('Failed to activate ad: $error');
    }
  }

  Future<void> _deactivateAd() async {
    if (_selectedAd?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getAdsApi().adsAdIdDeactivatePost(adId: _selectedAd!.id!);
      _showSnack('Ad deactivated.');
      await _refresh();
    } catch (error) {
      _showSnack('Failed to deactivate ad: $error');
    }
  }

  Future<void> _deleteAd() async {
    if (_selectedAd?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getAdsApi().adsAdIdDelete(adId: _selectedAd!.id!);
    setState(() {
      _selectedAd = null;
    });
    await _refresh();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    if (appStore.authorization == null) {
      return const AppBody(
        contextMenu: Text('Login required'),
        leftSplit: Center(child: Text('Please log in to view ads.')),
        rightSplit: SizedBox.shrink(),
      );
    }

    return FutureBuilder<List<Ad>>(
      future: _adsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppBody(
            contextMenu: Text('Loading'),
            leftSplit: Center(child: CircularProgressIndicator()),
            rightSplit: SizedBox.shrink(),
          );
        }
        if (snapshot.hasError) {
          return AppBody(
            contextMenu: const Text('Error'),
            leftSplit: Center(
              child: Text('Failed to load ads: ${snapshot.error}'),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }

        final ads = snapshot.data ?? const [];
        final isBuyer = appStore.authorization?.isBuyer == true;

        return AppBody(
          contextMenu: _buildContextMenu(appStore),
          leftSplit: Column(
            children: [
              AdsFilters(
                branches: _branches,
                branchIdFilter: _filterBranchId,
                statusFilter: _filterStatus,
                typeFilter: _filterType,
                onBranchIdChanged: (v) => setState(() => _filterBranchId = v),
                onStatusChanged: (v) => setState(() => _filterStatus = v),
                onTypeChanged: (v) => setState(() => _filterType = v),
                onClear: _clearFilters,
                onApply: _refresh,
              ),
              const Divider(height: 1),
              Expanded(
                child: AdsList(
                  ads: ads,
                  selectedAdId: _selectedAd?.id,
                  typeFilter: _filterType,
                  isBuyer: isBuyer,
                  onAdSelected: _selectAd,
                ),
              ),
            ],
          ),
          rightSplit: isBuyer
              ? AdsBuyerView(ads: ads)
              : _showCreateForm
                  ? AdsCreateForm(
                      branches: _branches,
                      onSubmit: _createAd,
                    )
                  : _selectedAd != null
                      ? AdsEditForm(
                          ad: _selectedAd!,
                          onUpdate: _updateAd,
                          onActivate: _activateAd,
                          onDeactivate: _deactivateAd,
                          onDelete: _deleteAd,
                        )
                      : const NoAdSelected(),
        );
      },
    );
  }

  Widget _buildContextMenu(Application appStore) {
    return Row(
      children: [
        Text('SOM Ads', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: 12),
        TextButton(onPressed: _refresh, child: const Text('Refresh')),
        if (appStore.authorization?.isBuyer != true)
          TextButton(
            onPressed: () => setState(() => _showCreateForm = !_showCreateForm),
            child: Text(_showCreateForm ? 'Close form' : 'Create ad'),
          ),
      ],
    );
  }
}
