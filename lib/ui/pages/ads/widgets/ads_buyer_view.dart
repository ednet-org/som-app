import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:openapi/openapi.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/utils/formatters.dart';
import 'package:som/ui/widgets/som_list_tile.dart';
import 'package:som/ui/widgets/status_badge.dart';

/// Ensures URL has a scheme for proper launching.
Uri _ensureScheme(String url) {
  final trimmed = url.trim();
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return Uri.parse(trimmed);
  }
  return Uri.parse('https://$trimmed');
}

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
                _ensureScheme(ad.url!),
                mode: LaunchMode.externalApplication,
              ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            SomAssets.adBannerPlaceholder,
            width: 220,
            height: 80,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 6),
          Text(ad.headline ?? 'Banner ${SomFormatters.shortId(ad.id)}'),
        ],
      ),
    );
  }
}

class _NormalAdCard extends StatelessWidget {
  const _NormalAdCard({required this.ad});

  final Ad ad;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SomListTile(
        leading: SvgPicture.asset(
          SomAssets.adSidebarPlaceholder,
          width: 40,
          height: 40,
        ),
        title: Text(ad.headline ?? 'Ad ${SomFormatters.shortId(ad.id)}'),
        subtitle: Text(ad.description ?? ad.url ?? ''),
        trailing: StatusBadge.ad(
          status: ad.status ?? 'draft',
          compact: true,
          showIcon: false,
        ),
        onTap: ad.url == null
            ? null
            : () => launchUrl(
                  _ensureScheme(ad.url!),
                  mode: LaunchMode.externalApplication,
                ),
      ),
    );
  }
}
