import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:som/ui/theme/som_assets.dart';

import '../../../theme/tokens.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/selectable_list_view.dart';
import '../../../widgets/som_list_tile.dart';
import '../../../widgets/status_badge.dart';

/// Widget for displaying a list of ads.
class AdsList extends StatelessWidget {
  const AdsList({
    super.key,
    required this.ads,
    required this.selectedAdId,
    required this.typeFilter,
    required this.isBuyer,
    required this.onAdSelected,
  });

  final List<Ad> ads;
  final String? selectedAdId;
  final String? typeFilter;
  final bool isBuyer;
  final ValueChanged<Ad> onAdSelected;

  @override
  Widget build(BuildContext context) {
    if (ads.isEmpty) {
      return const EmptyState(
        asset: SomAssets.emptyAds,
        title: 'No ads found',
        message: 'Create an ad to promote your offers',
      );
    }

    final filtered = ads
        .where((ad) => typeFilter == null || ad.type == typeFilter)
        .toList();
    final selectedIndex =
        filtered.indexWhere((ad) => ad.id == selectedAdId);
    return SelectableListView<Ad>(
      items: filtered,
      selectedIndex: selectedIndex < 0 ? null : selectedIndex,
      onSelectedIndex: (index) => onAdSelected(filtered[index]),
      itemBuilder: (context, ad, isSelected) {
        final index = filtered.indexOf(ad);
        return Column(
          children: [
            AdsListTile(
              ad: ad,
              isSelected: isSelected,
              isBuyer: isBuyer,
              onTap: () => onAdSelected(ad),
            ),
            if (index != filtered.length - 1) const Divider(height: 1),
          ],
        );
      },
    );
  }
}

/// Single list tile for an ad.
class AdsListTile extends StatelessWidget {
  const AdsListTile({
    super.key,
    required this.ad,
    required this.isSelected,
    required this.isBuyer,
    required this.onTap,
  });

  final Ad ad;
  final bool isSelected;
  final bool isBuyer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SomListTile(
      selected: isSelected,
      onTap: onTap,
      onLongPress: isBuyer
          ? () {
              if (ad.url != null) {
                launchUrl(
                  Uri.parse(ad.url!),
                  mode: LaunchMode.externalApplication,
                );
              }
            }
          : null,
      title: Text(ad.headline ?? 'Ad ${SomFormatters.shortId(ad.id)}'),
      subtitle: Text(
        '${SomFormatters.capitalize(ad.type ?? 'unknown')} • '
        '${SomFormatters.capitalize(ad.status ?? 'draft')}',
      ),
      trailing: StatusBadge.ad(
        status: ad.status ?? 'draft',
        compact: false,
        showIcon: false,
      ),
    );
  }
}
