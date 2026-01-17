import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_card.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';

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
        Text(
          'Provider type',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _typeCard(
              context,
              label: 'Wholesaler',
              value: 'grosshaendler',
              asset: SomAssets.authTypeWholesaler,
              selected: request.company.providerData.providerType == 'grosshaendler',
              onTap: () =>
                  request.company.providerData.setProviderType('grosshaendler'),
            ),
            _typeCard(
              context,
              label: 'Manufacturer',
              value: 'hersteller',
              asset: SomAssets.authTypeManufacturer,
              selected: request.company.providerData.providerType == 'hersteller',
              onTap: () =>
                  request.company.providerData.setProviderType('hersteller'),
            ),
            _typeCard(
              context,
              label: 'Service',
              value: 'dienstleister',
              asset: SomAssets.authTypeService,
              selected: request.company.providerData.providerType == 'dienstleister',
              onTap: () =>
                  request.company.providerData.setProviderType('dienstleister'),
            ),
          ],
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

  Widget _typeCard(
    BuildContext context, {
    required String label,
    required String value,
    required String asset,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: selected ? 2 : 1,
          ),
        ),
        child: SomCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SomSvgIcon(
                asset,
                size: 64,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(label, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
