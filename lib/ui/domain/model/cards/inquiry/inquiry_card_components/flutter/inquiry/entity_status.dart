import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/enums/inquiry_status.dart';

import '../entity.dart';

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
    return Badge(
      label: Text(entity.status.toString().split('.').last),
      textStyle: Theme.of(context).textTheme.labelSmall,
      textColor: Colors.white,
      backgroundColor: backgroundColor,
    );
  }
}
