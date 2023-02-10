import 'package:flutter/material.dart';

import 'entity_filter.dart';
import 'filter.dart';
import 'i_filter.dart';

class EntityFilters<T> extends StatelessWidget {
  final List<IFilter> filters;
  final List<Sort> sorts;

  const EntityFilters({
    super.key,
    required this.filters,
    this.sorts = const [],
  });

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
                return EntityFilter<IFilter>(filters[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
