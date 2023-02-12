import 'package:flutter/material.dart';

import 'entity_filter.dart';
import '../core/i_filter.dart';

class EntityFilters<F, T> extends StatelessWidget {
  final List<IFilter> filters;
  final List<Sort> sorts;

  final List<T> items;

  const EntityFilters({
    super.key,
    required this.filters,
    this.sorts = const [],
    required this.items,
  });

  onFilterChange(IFilter filter) {

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 900,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filters.length,
              itemBuilder: (context, index) {
                return EntityFilter(
                  filters[index],
                  onChanged: onFilterChange,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
