import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/enums/inquiry_status.dart';

import '../../../../../../../../domain/model/core/entity.dart';

class EntityStatus<T extends Entity> extends StatelessWidget {
  final Entity entity;

  const EntityStatus({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.black;
    switch (entity.status.value) {
      case InquiryStatus.draft:
        backgroundColor = Colors.grey;
        break;
      case InquiryStatus.published:
        backgroundColor = Colors.orange;
        break;
      case InquiryStatus.responded:
        backgroundColor = Colors.blue;
        break;
      case InquiryStatus.expired:
        backgroundColor = Colors.red;
        break;
      case InquiryStatus.closed:
        backgroundColor = Colors.green;
        break;
    }
    final statusValue = entity.status.value;
    final label = statusValue == null
        ? 'unknown'
        : statusValue.toString().split('.').last;
    return Badge(
      label: Text(label),
      textStyle: Theme.of(context).textTheme.labelSmall,
      textColor: Colors.white,
      backgroundColor: backgroundColor,
    );
  }
}
