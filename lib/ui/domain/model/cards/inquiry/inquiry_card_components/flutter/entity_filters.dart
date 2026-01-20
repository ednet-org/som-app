import 'package:flutter/material.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';

import 'entity_filter.dart';
import '../core/i_filter.dart';

class EntityFilters<F, T> extends StatefulWidget {
  final List<IFilter> filters;
  final List<Sort> sorts;

  final List<T> items;

  const EntityFilters({
    super.key,
    required this.filters,
    this.sorts = const [],
    required this.items,
  });

  @override
  State<EntityFilters<F, T>> createState() => _EntityFiltersState<F, T>();
}

class _EntityFiltersState<F, T> extends State<EntityFilters<F, T>> {
  bool menuIsPined = true;

  void onFilterChange(dynamic filter) {
    print(filter);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final isMobile = constraints.maxWidth <= 600;
        if (isMobile) {
          return hamburgerMenu(isPinned: menuIsPined);
        }

        return menu(isPinned: menuIsPined);
      },
    );
  }

  SizedBox menu({isPinned = false}) {
    return SizedBox(
      width: 300,
      height: 900,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.filters.length,
              itemBuilder: (context, index) {
                return EntityFilter(
                  widget.filters[index],
                  onChanged: onFilterChange,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  SizedBox collapsedMenu() {
    return SizedBox(
      width: 150,
      height: 900,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: widget.filters.length,
                itemBuilder: (context, index) {
                  return EntityFilter(
                    widget.filters[index],
                    onChanged: onFilterChange,
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget hamburgerMenu({isPinned = false}) {
    return IconButton(
      tooltip: 'Filter menu',
      onPressed: () {
        print('here comes menu');
      },
      icon: SomSvgIcon(
        SomAssets.iconMenu,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
