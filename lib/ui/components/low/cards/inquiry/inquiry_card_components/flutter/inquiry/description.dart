import 'package:flutter/material.dart';

import '../entity.dart';

class Description<T extends Entity> extends StatelessWidget {
  final Entity entity;

  const Description({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final summary = entity.getSummaryAttributes();

    final description =
        summary.firstWhere((element) => element.name == 'description');

    return Text(
      description?.value ?? '',
      maxLines: 10,
      style: theme.textTheme.bodyMedium,
      overflow: TextOverflow.ellipsis,
    );
  }
}
