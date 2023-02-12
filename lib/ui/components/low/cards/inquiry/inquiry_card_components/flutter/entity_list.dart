import 'package:flutter/material.dart';
import 'package:som/ui/components/low/cards/inquiry/inquiry_card_components/core/arr.dart';

import '../core/i_filter.dart';
import 'entity_filters.dart';

/// Filters
/// Sorting
/// Pagination
class EntityList<T> {
  final List<Sort> sorts;
  final List<T> entities;

  final Widget Function(T) entityBuilder;

  final EntityFilters<Arr, T> filters;

  EntityList({
    required this.entities,
    filters,
    required this.entityBuilder,
    this.sorts = const [],
  }) : filters = EntityFilters(filters: filters, items: entities);

  build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: entities.length,
            itemBuilder: (context, index) {
              return entityBuilder(entities[index]);
            },
          ),
        ),
      ],
    );
  }
}
