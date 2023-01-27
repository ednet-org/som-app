import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/model/customer_management/registration_request.dart';
import 'package:som/domain/model/customer_management/roles.dart';
import 'package:som/main.dart';
import 'package:som/ui/utils/AppWidget.dart';

class RoleSelection extends StatelessWidget {
  const RoleSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registrationRequest = Provider.of<RegistrationRequest>(context);

    return Observer(
      builder: (_) => Container(
        // width: 800,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please select which type of company are you registering',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            16.height,
            selectionCards(context, registrationRequest),
            8.height,
          ],
        ),
      ),
    );
  }

  Widget selectionCards(context, registrationRequest) {
    return ContainerX(
        web: web(context, registrationRequest),
        mobile: mobile(context, registrationRequest));
  }

  ElevatedButton providerSelector(context, registrationRequest) {
    return ElevatedButton(
      onPressed: () => registrationRequest.company.switchRole(Roles.Provider),
      style: ElevatedButton.styleFrom(
        backgroundColor: registrationRequest.company.isProvider
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
        foregroundColor: registrationRequest.company.isProvider
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSecondary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text('Provider', style: Theme.of(context).textTheme.titleLarge),
            Switch(
                value: registrationRequest.company.isProvider,
                onChanged: registrationRequest.company.activateProvider),
          ],
        ),
      ),
    );
  }

  ElevatedButton buyerSelector(context, registrationRequest) {
    return ElevatedButton(
      onPressed: () => registrationRequest.switchRole(Roles.Buyer),
      style: ElevatedButton.styleFrom(
        backgroundColor: registrationRequest.company.isBuyer
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
        foregroundColor: registrationRequest.company.isBuyer
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSecondary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text('Buyer ', style: Theme.of(context).textTheme.titleLarge),
            Switch(
                value: registrationRequest.company.isBuyer,
                onChanged: registrationRequest.company.activateBuyer),
          ],
        ),
      ),
    );
  }

  web(context, registrationRequest) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: appStore.buttonWidth,
          child: buyerSelector(context, registrationRequest),
        ),
        40.width,
        SizedBox(
          width: appStore.buttonWidth,
          child: providerSelector(context, registrationRequest),
        ),
      ],
    );
  }

  mobile(context, registrationRequest) {
    return Column(
      children: [
        buyerSelector(context, registrationRequest),
        10.height,
        providerSelector(context, registrationRequest),
      ],
    );
  }
}
