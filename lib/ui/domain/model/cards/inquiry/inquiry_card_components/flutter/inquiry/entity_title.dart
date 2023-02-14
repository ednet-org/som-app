import 'package:flutter/material.dart';

import '../../../../../../../../domain/model/core/entity.dart';

class EntityTitle<T extends Entity> extends StatelessWidget {
  final Entity entity;

  const EntityTitle({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final summary = entity.getSummaryAttributes();

    final title = summary.firstWhere((element) => element.name == 'title');

    return Text(
      title.value ?? '',
      maxLines: 4,
      style: theme.textTheme.titleSmall,
    );
  }
}
