import 'package:flutter/material.dart';

import '../core/arr.dart';
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

  final void Function(T?)? onEntitySelected;
  final Widget? Function(T entity) detailsBuilder;

  EntityList({
    super.key,
    required this.entities,
    filters,
    required this.entityBuilder,
    this.sorts = const [],
    this.listMode = ListMode.grid,
    this.onEntitySelected,
    required this.detailsBuilder,
  }) : filters = EntityFilters(filters: filters, items: entities);

  @override
  State<EntityList<T>> createState() => _EntityListState<T>();
}

class _EntityListState<T> extends State<EntityList<T>> {
  bool isDetailsMode = false;
  T? selectedEntity;

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
                        onTap: () => loadDocument(context, index),
                        child: widget.entityBuilder(widget.entities[index]));
                  },
                )
              : GridView.builder(
                  itemCount: widget.entities.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () => loadDocument(context, index),
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

  loadDocument(BuildContext context, int index) {
    selectedEntity = widget.entities[index];
    isDetailsMode = true;
    if (widget.onEntitySelected != null && selectedEntity != null) {
      widget.onEntitySelected!(selectedEntity as T);
    }
  }

  unloadDocument() {
    isDetailsMode = false;
    selectedEntity = null;

    if (widget.onEntitySelected != null) {
      widget.onEntitySelected!(null);
    }

    setState(() {});
  }

  details(BuildContext context) {
    if (selectedEntity != null) {
      return widget.detailsBuilder(selectedEntity as T);
    }
  }
}

enum ListMode {
  list,
  grid,
}

class EntityDetails extends StatelessWidget {
  final bool isDetailsMode;

  const EntityDetails({
    Key? key,
    this.isDetailsMode = false,
  }) : super(key: key);

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
              style: Theme.of(context).textTheme.titleMedium),
          const Divider(),
          Text('Document body', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
