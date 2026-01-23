import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:url_launcher/url_launcher.dart';

/// Ensures URL has a scheme for proper launching.
Uri _ensureScheme(String url) {
  final trimmed = url.trim();
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return Uri.parse(trimmed);
  }
  return Uri.parse('https://$trimmed');
}

/// Immersive marketing-focused view for buyers showing ads prominently.
class AdsBuyerView extends StatefulWidget {
  const AdsBuyerView({
    super.key,
    required this.ads,
    this.branches = const [],
    this.branchIdFilter,
    this.typeFilter,
    this.onBranchIdChanged,
    this.onTypeChanged,
    this.onClearFilters,
  });

  final List<Ad> ads;
  final List<Branch> branches;
  final String? branchIdFilter;
  final String? typeFilter;
  final ValueChanged<String?>? onBranchIdChanged;
  final ValueChanged<String?>? onTypeChanged;
  final VoidCallback? onClearFilters;

  @override
  State<AdsBuyerView> createState() => _AdsBuyerViewState();
}

class _AdsBuyerViewState extends State<AdsBuyerView> {
  bool _filtersExpanded = false;

  bool get _hasActiveFilters =>
      widget.branchIdFilter != null || widget.typeFilter != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Apply type filter to ads
    final filteredAds = widget.typeFilter != null
        ? widget.ads.where((ad) => ad.type == widget.typeFilter).toList()
        : widget.ads;

    // Separate banners and normal ads from filtered results
    final banners = filteredAds.where((ad) => ad.type == 'banner').toList();
    final normal = filteredAds.where((ad) => ad.type != 'banner').toList();

    // Show banner section only if not filtering by 'normal' type
    final showBanners = widget.typeFilter != 'normal' && banners.isNotEmpty;
    // Show normal section only if not filtering by 'banner' type
    final showNormal = widget.typeFilter != 'banner' && normal.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Discrete filter row
          _buildFilterRow(theme),
          const SizedBox(height: 24),
          // Empty state
          if (filteredAds.isEmpty) ...[
            const SizedBox(height: 48),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.campaign_outlined,
                    size: 64,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _hasActiveFilters
                        ? 'No offers match your filters'
                        : 'No promotions available',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _hasActiveFilters
                        ? 'Try adjusting your filters'
                        : 'Check back later for exciting offers!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  if (_hasActiveFilters) ...[
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: widget.onClearFilters,
                      icon: const Icon(Icons.clear_all, size: 18),
                      label: const Text('Clear filters'),
                    ),
                  ],
                ],
              ),
            ),
          ] else ...[
            // Hero banner section
            if (showBanners) ...[
              _BannerHeroSection(banners: banners),
              const SizedBox(height: 32),
            ],
            // Promotions grid
            if (showNormal) ...[
              Text(
                'Featured Offers',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Discover services from our trusted partners',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              _PromotionsGrid(ads: normal),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildFilterRow(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Filter toggle
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => setState(() => _filtersExpanded = !_filtersExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tune,
                    size: 18,
                    color: _hasActiveFilters
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Filter',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: _hasActiveFilters
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (_hasActiveFilters) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${(widget.branchIdFilter != null ? 1 : 0) + (widget.typeFilter != null ? 1 : 0)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 4),
                  Icon(
                    _filtersExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          // Expanded filters
          if (_filtersExpanded) ...[
            const SizedBox(width: 16),
            const VerticalDivider(width: 1),
            const SizedBox(width: 16),
            // Branch dropdown
            if (widget.branches.isNotEmpty) ...[
              _buildCompactDropdown<String?>(
                theme: theme,
                value: widget.branchIdFilter,
                hint: 'Branch',
                items: [
                  const DropdownMenuItem(value: null, child: Text('All branches')),
                  ...widget.branches.map((b) => DropdownMenuItem(
                        value: b.id,
                        child: Text(
                          b.name ?? 'Branch',
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                ],
                onChanged: widget.onBranchIdChanged,
              ),
              const SizedBox(width: 12),
            ],
            // Type dropdown
            _buildCompactDropdown<String?>(
              theme: theme,
              value: widget.typeFilter,
              hint: 'Type',
              items: const [
                DropdownMenuItem(value: null, child: Text('All types')),
                DropdownMenuItem(value: 'normal', child: Text('Standard')),
                DropdownMenuItem(value: 'banner', child: Text('Banner')),
              ],
              onChanged: widget.onTypeChanged,
            ),
            // Clear button
            if (_hasActiveFilters) ...[
              const SizedBox(width: 12),
              IconButton(
                onPressed: widget.onClearFilters,
                icon: const Icon(Icons.close, size: 18),
                tooltip: 'Clear filters',
                style: IconButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  padding: const EdgeInsets.all(8),
                  minimumSize: const Size(32, 32),
                ),
              ),
            ],
          ],
          const Spacer(),
          // Results count
          Text(
            '${widget.ads.length} offer${widget.ads.length == 1 ? '' : 's'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactDropdown<T>({
    required ThemeData theme,
    required T value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint, style: theme.textTheme.bodyMedium),
          isDense: true,
          borderRadius: BorderRadius.circular(8),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// Hero section displaying banner ads prominently.
class _BannerHeroSection extends StatelessWidget {
  const _BannerHeroSection({required this.banners});

  final List<Ad> banners;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Highlighted',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: banners.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) => _BannerCard(ad: banners[index]),
          ),
        ),
      ],
    );
  }
}

/// Large banner card with gradient overlay and CTA.
class _BannerCard extends StatefulWidget {
  const _BannerCard({required this.ad});

  final Ad ad;

  @override
  State<_BannerCard> createState() => _BannerCardState();
}

class _BannerCardState extends State<_BannerCard> {
  bool _isHovered = false;

  void _launchUrl() {
    if (widget.ad.url == null) return;
    launchUrl(
      _ensureScheme(widget.ad.url!),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = widget.ad.imagePath != null && widget.ad.imagePath!.isNotEmpty;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _launchUrl,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 360,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(_isHovered ? 0.2 : 0.1),
                blurRadius: _isHovered ? 20 : 12,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image or gradient
                if (hasImage)
                  Image.network(
                    widget.ad.imagePath!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(theme),
                  )
                else
                  _buildPlaceholder(theme),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.ad.headline ?? 'Special Offer',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.ad.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.ad.description!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 12),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: _isHovered ? 16 : 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Learn more',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primary,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.campaign_rounded,
          size: 48,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }
}

/// Responsive grid of promotional ad cards.
class _PromotionsGrid extends StatelessWidget {
  const _PromotionsGrid({required this.ads});

  final List<Ad> ads;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 3
            : constraints.maxWidth > 600
                ? 2
                : 1;

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: ads.map((ad) {
            final cardWidth = (constraints.maxWidth - (crossAxisCount - 1) * 20) / crossAxisCount;
            return SizedBox(
              width: cardWidth.clamp(280.0, 400.0),
              child: _PromotionCard(ad: ad),
            );
          }).toList(),
        );
      },
    );
  }
}

/// Individual promotion card with hover effects and CTA.
class _PromotionCard extends StatefulWidget {
  const _PromotionCard({required this.ad});

  final Ad ad;

  @override
  State<_PromotionCard> createState() => _PromotionCardState();
}

class _PromotionCardState extends State<_PromotionCard> {
  bool _isHovered = false;

  void _launchUrl() {
    if (widget.ad.url == null) return;
    launchUrl(
      _ensureScheme(widget.ad.url!),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = widget.ad.imagePath != null && widget.ad.imagePath!.isNotEmpty;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _launchUrl,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? theme.colorScheme.primary.withOpacity(0.5)
                  : theme.colorScheme.outlineVariant.withOpacity(0.5),
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(_isHovered ? 0.15 : 0.08),
                blurRadius: _isHovered ? 16 : 8,
                offset: Offset(0, _isHovered ? 6 : 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (hasImage)
                        Image.network(
                          widget.ad.imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildImagePlaceholder(theme),
                        )
                      else
                        _buildImagePlaceholder(theme),
                      // Hover overlay
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _isHovered ? 1 : 0,
                        child: Container(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'View offer',
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.open_in_new_rounded,
                                    size: 16,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Content section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.ad.headline ?? 'Special Offer',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.ad.description != null &&
                        widget.ad.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.ad.description!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.link_rounded,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _displayUrl(widget.ad.url),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer.withOpacity(0.5),
            theme.colorScheme.secondaryContainer.withOpacity(0.5),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.local_offer_rounded,
          size: 40,
          color: theme.colorScheme.onPrimaryContainer.withOpacity(0.3),
        ),
      ),
    );
  }

  String _displayUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    return url
        .replaceFirst(RegExp(r'^https?://'), '')
        .replaceFirst(RegExp(r'^www\.'), '')
        .split('/')
        .first;
  }
}
