import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/inquiry.dart';
import 'package:som/ui/pages/inquiry/entity_filters.dart';
import 'package:som/ui/pages/inquiry/i_filter.dart';

class EntityList<T> extends StatelessWidget {
  final EntityFilters<Inquiry> filters;
  final List<Sort> sorts;
  final List<T> entities;

  final Widget Function(T) entityBuilder;

  const EntityList({
    super.key,
    required this.entities,
    required this.entityBuilder,
    required this.filters,
    this.sorts = const [],
  });

  @override
  Widget build(BuildContext context) {
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
