import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:url_launcher/url_launcher.dart';

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
      return const Center(child: Text('No ads found.'));
    }

    return ListView.builder(
      itemCount: ads.length,
      itemBuilder: (context, index) {
        final ad = ads[index];
        if (typeFilter != null && ad.type != typeFilter) {
          return const SizedBox.shrink();
        }
        return AdsListTile(
          ad: ad,
          isSelected: selectedAdId == ad.id,
          isBuyer: isBuyer,
          onTap: () => onAdSelected(ad),
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
    return ListTile(
      title: Text(ad.headline ?? ad.id ?? 'Ad'),
      subtitle: Text('${ad.status ?? '-'} | ${ad.type ?? '-'}'),
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
    );
  }
}
