import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/main/utils/AppConstant.dart';

import '../../../../domain/model/customer-management/roles.dart';
import 'RoleSelector.dart';

class RoleSelection extends StatelessWidget {

  RoleSelection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Please select role.',
                style: primaryTextStyle(size: textSizeXLarge.toInt()))
            .paddingOnly(left: 8, top: 20, right: 8),
        16.height,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Card(
            child: Row(children: [
              Text('HMMMMM'),
            ]),
          ),
        ),
        16.height,
        Container(
          height: 100,
          child: selectionCards,
        ),
        8.height,
      ],
    );
  }

  Widget get selectionCards {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Roles.values
          .map(
            (roleValue) => InkWell(
              child: Card(
                child: RoleSelector(
                  role: roleValue,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
