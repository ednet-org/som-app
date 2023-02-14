import 'package:flutter/material.dart';

import '../../entity.dart';
import '../../inquiry/entity_title.dart';

// TODO: refactor to document structure fromm AppBody
class EntityDocument<T extends Entity> extends StatelessWidget {
  final T entity;

  const EntityDocument({
    super.key,
    required this.entity,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
          width: 600,
          height: 400,
          child: Center(
            child: Column(children: [
              EntityTitle(entity: entity),
            ]),
          )),
    );
  }
}
