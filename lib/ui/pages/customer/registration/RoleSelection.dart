import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/model/customer-management/registration_request.dart';
import 'package:som/domain/model/customer-management/roles.dart';
import 'package:som/main.dart';
import 'package:som/template_storage/main/utils/AppColors.dart';
import 'package:som/template_storage/main/utils/AppWidget.dart';

class RoleSelection extends StatefulWidget {
  RoleSelection();

  @override
  State<RoleSelection> createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {
  var registrationRequest;

  @override
  Widget build(BuildContext context) {
    registrationRequest = Provider.of<RegistrationRequest>(context);

    return Observer(
      builder: (_) => Container(
        // width: 800,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text('Please select which type of company are you registering'),
            16.height,
            selectionCards,
            8.height,
          ],
        ),
      ),
    );
  }

  Widget get selectionCards {
    return ContainerX(web: web(), mobile: mobile());
  }

  ElevatedButton providerSelector() {
    final ButtonStyle providerStyle = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 12), primary: appColorPrimaryDark);

    return ElevatedButton(
        style: providerStyle,
        onPressed: () => registrationRequest.company.switchRole(Roles.Provider),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('Provider', style: boldTextStyle(size: 24)),
              Switch(
                  value: registrationRequest.company.isProvider,
                  onChanged: registrationRequest.company.activateProvider),
            ],
          ),
        ));
  }

  ElevatedButton buyerSelector() {
    final ButtonStyle buyerStyle = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 12),
        primary: appIconTintDark_purple);

    return ElevatedButton(
        style: buyerStyle,
        onPressed: () => registrationRequest.switchRole(Roles.Buyer),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('Buyer ', style: boldTextStyle(size: 24)),
              Switch(
                  value: registrationRequest.company.isBuyer,
                  onChanged: registrationRequest.company.activateBuyer),
            ],
          ),
        ));
  }

  web() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: appStore.buttonWidth,
          child: buyerSelector(),
        ),
        40.width,
        Container(
          width: appStore.buttonWidth,
          child: providerSelector(),
        ),
      ],
    );
  }

  mobile() {
    return Column(
      children: [
        buyerSelector(),
        10.height,
        providerSelector(),
      ],
    );
  }
}
