import 'package:flutter/material.dart';
import 'package:som/ui/components/low/cards/inquiry/inquiry_card_components/core/arr.dart';

import '../core/i_filter.dart';
import 'entity_filters.dart';

/// Filters
/// Sorting
/// Pagination
class EntityList<T> extends StatefulWidget {
  final List<Sort> sorts;
  final List<T> entities;

  final ListMode listMode;

  final Widget Function(T) entityBuilder;

  final EntityFilters<Arr, T> filters;

  EntityList({
    super.key,
    required this.entities,
    filters,
    required this.entityBuilder,
    this.sorts = const [],
    this.listMode = ListMode.grid,
  }) : filters = EntityFilters(filters: filters, items: entities);

  @override
  State<EntityList<T>> createState() => _EntityListState<T>();
}

class _EntityListState<T> extends State<EntityList<T>> {
  bool isDetailsMode = false;
  T? selectedEntity;
  EntityDetails? selectedEntityDetails;

  get details {}

  @override
  build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: widget.listMode == ListMode.list
              ? ListView.builder(
            itemCount: widget.entities.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: switchDetailMode(context, index),
                  child: widget.entityBuilder(widget.entities[index]));
            },
          )
              : GridView.builder(
            itemCount: widget.entities.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: switchDetailMode(context, index),
                  child: widget.entityBuilder(widget.entities[index]));
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
          ),
        ),
      ],
    );
  }

  switchDetailMode(BuildContext context, int index) {
    if (selectedEntityDetails != null) {
      isDetailsMode = !isDetailsMode;
      return selectedEntityDetails;
    }

    return null;
  }
}

enum ListMode {
  list,
  grid,
}

class EntityDetails extends StatelessWidget {
  final bool isDetailsMode;

  const EntityDetails({
    super.key,
    isDetailsMode,
  }) : isDetailsMode = isDetailsMode ?? false;

  @override
  Widget build(BuildContext context) {
    if (!isDetailsMode) {
      return const SizedBox();
    }

    return SizedBox(
      height: 1000,
      width: 600,
      child: Column(
        children: [
          Text('Document Title',
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium),
          const Divider(),
          Text('Document body', style: Theme
              .of(context)
              .textTheme
              .bodyMedium),
        ],
      ),
    );
  }
}
