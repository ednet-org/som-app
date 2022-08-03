import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/model/customer-management/registration_request.dart';
import 'package:som/domain/model/customer-management/roles.dart';
import 'package:som/main.dart';
import 'package:som/ui/utils/AppWidget.dart';

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
    return ElevatedButton(
      onPressed: () => registrationRequest.company.switchRole(Roles.Provider),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text('Provider',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
            Switch(
                activeColor: Theme.of(context).colorScheme.onPrimary,
                value: registrationRequest.company.isProvider,
                onChanged: registrationRequest.company.activateProvider),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).colorScheme.primary,
        onPrimary: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  ElevatedButton buyerSelector() {
    return ElevatedButton(
      onPressed: () => registrationRequest.switchRole(Roles.Buyer),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text('Buyer ',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary)),
            Switch(
                activeColor: Theme.of(context).colorScheme.onSecondary,
                value: registrationRequest.company.isBuyer,
                onChanged: registrationRequest.company.activateBuyer),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).colorScheme.secondary,
        onPrimary: Theme.of(context).colorScheme.secondary,
      ),
    );
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
