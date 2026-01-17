import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/model.dart';

const List<String> _providerTypeOptions = [
  'haendler',
  'hersteller',
  'dienstleister',
  'grosshaendler',
];

/// Step widget for provider branches selection in registration flow.
class ProviderBranchesStep extends StatelessWidget {
  const ProviderBranchesStep({super.key});

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<RegistrationRequest>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SomTags(
          tags: request.som.availableBranches,
          selectedTags: request.som.requestedBranches,
          onAdd: request.som.requestBranch,
          onRemove: request.som.removeRequestedBranch,
        ),
        const SizedBox(height: 20),
        SomDropDown<String>(
          value: request.company.providerData.providerType,
          onChanged: (val) {
            if (val != null) request.company.providerData.setProviderType(val);
          },
          hint: 'Select provider type',
          label: 'Provider type',
          items: _providerTypeOptions,
        ),
      ],
    );
  }
}
