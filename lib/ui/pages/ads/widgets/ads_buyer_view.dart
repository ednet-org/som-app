import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:url_launcher/url_launcher.dart';

/// View for buyers showing ads grouped by type.
class AdsBuyerView extends StatelessWidget {
  const AdsBuyerView({
    super.key,
    required this.ads,
  });

  final List<Ad> ads;

  @override
  Widget build(BuildContext context) {
    final banners = ads.where((ad) => ad.type == 'banner').toList();
    final normal = ads.where((ad) => ad.type != 'banner').toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          if (banners.isNotEmpty) ...[
            Text('Banner ads', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: banners
                  .map((ad) => _BannerAdButton(ad: ad))
                  .toList(),
            ),
            const Divider(height: 24),
          ],
          Text('Ads', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          ...normal.map((ad) => _NormalAdCard(ad: ad)),
        ],
      ),
    );
  }
}

class _BannerAdButton extends StatelessWidget {
  const _BannerAdButton({required this.ad});

  final Ad ad;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: ad.url == null
          ? null
          : () => launchUrl(
                Uri.parse(ad.url!),
                mode: LaunchMode.externalApplication,
              ),
      child: Text(ad.headline ?? ad.id ?? 'Banner'),
    );
  }
}

class _NormalAdCard extends StatelessWidget {
  const _NormalAdCard({required this.ad});

  final Ad ad;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(ad.headline ?? ad.id ?? 'Ad'),
        subtitle: Text(ad.description ?? ad.url ?? ''),
        trailing: Text(ad.status ?? ''),
        onTap: ad.url == null
            ? null
            : () => launchUrl(
                  Uri.parse(ad.url!),
                  mode: LaunchMode.externalApplication,
                ),
      ),
    );
  }
}
