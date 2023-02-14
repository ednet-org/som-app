import 'package:flutter/material.dart';
import '../../../../../../../domain/model/inquiry_management/inquiry.dart';
import 'entity.dart';
import 'inquiry/description.dart';
import 'inquiry/entity_title.dart';
import 'inquiry/inquiry_card_divider.dart';
import 'inquiry/entity_status.dart';

class EntityCard<T extends Entity> extends StatelessWidget {
  final T entity;

  const EntityCard({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    final summary = entity.getSummaryAttributes();
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Container(
            constraints: const BoxConstraints(
              maxWidth: 450, // layout.constraints.containerLayout.maxWidth,
              maxHeight: 500, //layout.constraints.containerLayout.maxHeight,
              minWidth: 350, //layout.constraints.containerLayout.minWidth,
              minHeight: 350, //layout.constraints.containerLayout.minHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      SizedBox(
                        height: 300,
                        child: EntityTitle(entity: entity),
                      ),
                      Expanded(
                        child: EntityStatus(
                          entity: entity,
                        ),
                      ),
                    ],
                  ),
                  const InquiryCardDivider(),
                  Description(entity: entity),
                  const Flexible(
                    fit: FlexFit.tight,
                    child: SizedBox(),
                  ),
                  const InquiryCardDivider(),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      EntityBranch(entity: entity),
                      const SizedBox(
                        width: 10,
                      ),
                      const VerticalDivider(),
                      const SizedBox(
                        width: 10,
                      ),
                      EntityCategory(entity: entity),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class EntityBranch<T extends Entity> extends StatelessWidget {
  final T entity;

  const EntityBranch({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final attributes = entity.getDocumentAttributes();
    final branch = attributes.firstWhere((element) => element.name == 'branch');

    return SizedBox(
      width: 150,
      child: Text(
        branch.value,
        maxLines: 2,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

class EntityCategory<T extends Entity> extends StatelessWidget {
  final T entity;

  const EntityCategory({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final attributes = entity.getDocumentAttributes();
    final category = attributes.firstWhere((element) => element.name == 'category');

    return SizedBox(
      width: 150,
      child: Text(
        category.value,
        maxLines: 2,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
