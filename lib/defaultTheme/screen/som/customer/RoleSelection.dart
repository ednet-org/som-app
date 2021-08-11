import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/main/utils/AppConstant.dart';
import 'Role.dart';
import 'Roles.dart';

class CRoleSelection extends StatelessWidget {
  final Roles selectedRole;
  final Function selectRole;

  CRoleSelection(this.selectRole, this.selectedRole);

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
          height: 150,
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
              child: Role(
                selectRole: selectRole,
                selectedRole: selectedRole,
                role: roleValue,
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
