import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

import 'inquiry_to_card_mapping.dart';

class EntityCard<T extends Entity> extends StatelessWidget {
  final T item;

  final mapping;

  const EntityCard({
    Key? key,
    required this.item,
    required InquiryToCardMapping this.mapping,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SizedBox(width: 200, child: mapping.build(item)));
  }
}
