import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/main/utils/AppConstant.dart';

import '../../../domain/model/customer-management/roles.dart';
import 'Role.dart';

class RoleSelection extends StatelessWidget {
  final Roles selectedRole;
  final Function selectRole;

  RoleSelection(this.selectRole, this.selectedRole);

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
              onTap: () {
                selectRole(selectedRole);
              },
              child: Card(
                child: Role(
                  selectRole: selectRole,
                  selectedRole: selectedRole,
                  role: roleValue,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  // hack approach to container spacing to parent constraints
  LayoutBuilder get selectionLayoutBuilder {
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Provider selection
          Container(
            padding: EdgeInsets.all(20.0),
            constraints: BoxConstraints(
                // 1/4 is ratio of container view of max constraint
                minWidth: constraints.maxWidth / 4,
                minHeight: constraints.maxHeight),
            child: Center(
              child: Role(
                selectRole: selectRole,
                selectedRole: selectedRole,
                role: Roles.Provider,
              ),
            ),
          ),
          // Buyer selection
          Container(
            padding: EdgeInsets.all(20.0),
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth / 4,
                minHeight: constraints.maxHeight),
            child: Center(
              child: Role(
                selectRole: selectRole,
                selectedRole: selectedRole,
                role: Roles.Buyer,
              ),
            ),
          )
        ],
      ),
    );
  }
}
