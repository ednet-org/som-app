import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/inquiry.dart';
import 'package:som/ui/components/cards/inquiry/inquiry_card_components/flutter/entity_filters.dart';
import 'package:som/ui/components/cards/inquiry/inquiry_card_components/core/i_filter.dart';

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
