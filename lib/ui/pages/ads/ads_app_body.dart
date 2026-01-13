import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/domain/application/application.dart';

import '../../domain/model/layout/app_body.dart';

class AdsAppBody extends StatefulWidget {
  const AdsAppBody({Key? key}) : super(key: key);

  @override
  State<AdsAppBody> createState() => _AdsAppBodyState();
}

class _AdsAppBodyState extends State<AdsAppBody> {
  Future<List<Ad>>? _adsFuture;
  Ad? _selectedAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _adsFuture ??= _loadAds(context);
  }

  Future<List<Ad>> _loadAds(BuildContext context) async {
    final api = Provider.of<Openapi>(context, listen: false);
    final response = await api.getAdsApi().adsGet();
    return response.data?.toList() ?? const <Ad>[];
  }

  Future<void> _refresh() async {
    setState(() {
      _adsFuture = _loadAds(context);
    });
  }

  Future<void> _createDemoAd() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final branchesResponse = await api.getBranchesApi().branchesGet();
    final branches = branchesResponse.data?.toList() ?? const <Branch>[];
    final branch = branches.isNotEmpty ? branches.first : null;
    if (branch?.id == null) {
      return;
    }
    await api.getAdsApi().createAd(
          createAdRequest: CreateAdRequest((b) => b
            ..type = 'normal'
            ..status = 'draft'
            ..branchId = branch!.id!
            ..url = 'https://example.com'
            ..headline = 'Demo Ad'
            ..description = 'Demo ad created from local dev'),
        );
    await _refresh();
  }

  Future<void> _toggleStatus() async {
    if (_selectedAd?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    final nextStatus =
        _selectedAd?.status == 'active' ? 'draft' : 'active';
    final updated = _selectedAd!.rebuild((b) => b..status = nextStatus);
    await api.getAdsApi().adsAdIdPut(adId: updated.id!, ad: updated);
    await _refresh();
  }

  Future<void> _deleteSelected() async {
    if (_selectedAd?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getAdsApi().adsAdIdDelete(adId: _selectedAd!.id!);
    setState(() {
      _selectedAd = null;
    });
    await _refresh();
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
        final ads = snapshot.data ?? [];
        return AppBody(
          contextMenu: Row(
            children: [
              Text('Ads', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 12),
              TextButton(onPressed: _refresh, child: const Text('Refresh')),
              TextButton(
                  onPressed: _createDemoAd, child: const Text('Create demo ad')),
              TextButton(
                  onPressed: _toggleStatus, child: const Text('Toggle status')),
              TextButton(
                  onPressed: _deleteSelected, child: const Text('Delete')),
            ],
          ),
          leftSplit: ListView.builder(
            itemCount: ads.length,
            itemBuilder: (context, index) {
              final ad = ads[index];
              return ListTile(
                title: Text(ad.headline ?? ad.id ?? 'Ad'),
                subtitle: Text(ad.status ?? 'unknown'),
                selected: _selectedAd?.id == ad.id,
                onTap: () async {
                  final api = Provider.of<Openapi>(context, listen: false);
                  final detail =
                      await api.getAdsApi().adsAdIdGet(adId: ad.id!);
                  setState(() {
                    _selectedAd = detail.data ?? ad;
                  });
                },
              );
            },
          ),
          rightSplit: _selectedAd == null
              ? const Center(child: Text('Select an ad to view details.'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_selectedAd!.headline ?? 'Ad'),
                      const SizedBox(height: 8),
                      Text('Status: ${_selectedAd!.status ?? 'unknown'}'),
                      Text('Type: ${_selectedAd!.type ?? '-'}'),
                      Text('URL: ${_selectedAd!.url ?? '-'}'),
                      Text('Branch: ${_selectedAd!.branchId ?? '-'}'),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
