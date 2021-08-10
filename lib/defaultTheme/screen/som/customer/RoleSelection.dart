import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
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
        Text('Please select role.', style: primaryTextStyle(size: 18))
            .paddingOnly(left: 8, right: 8),
        16.height,
        Container(
          height: 150,
          child: LayoutBuilder(
            builder: (context, constraints) => ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  padding: EdgeInsets.all(20.0),
                  constraints: BoxConstraints(
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
          ),
        ),
        8.height,
      ],
    );
  }
}
