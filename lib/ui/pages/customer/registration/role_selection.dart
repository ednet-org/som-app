import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/main.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_button.dart';
import 'package:som/ui/widgets/design_system/som_card.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';

import '../../../domain/model/customer_management/registration_request.dart';
import '../../../domain/model/customer_management/roles.dart';

class RoleSelection extends StatefulWidget {
  const RoleSelection({Key? key}) : super(key: key);

  @override
  State<RoleSelection> createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {
  String? _hoveredRole;

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
              'Join SOM Network - Choose your path',
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

  Widget selectionCards(
    BuildContext context,
    RegistrationRequest registrationRequest,
  ) {
    return isMobile
        ? mobile(context, registrationRequest)
        : web(context, registrationRequest);
  }

  Widget _roleCard({
    required BuildContext context,
    required String roleKey,
    required String title,
    required String subtitle,
    required String iconAsset,
    required bool selected,
    required VoidCallback onTap,
    required String buttonText,
  }) {
    final isHovered = _hoveredRole == roleKey;
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredRole = roleKey),
      onExit: (_) => setState(() => _hoveredRole = null),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: isHovered ? 1.05 : 1.0,
        child: SomCard(
          padding: const EdgeInsets.all(20),
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  iconAsset,
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),
                Column(
                  children: [
                    Text(title, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SomButton(
                  text: buttonText,
                  type: selected
                      ? SomButtonType.primary
                      : SomButtonType.secondary,
                  onPressed: onTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget web(BuildContext context, RegistrationRequest registrationRequest) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: appStore.buttonWidth,
          child: _roleCard(
            context: context,
            roleKey: 'buyer',
            title: 'Buyer',
            subtitle: 'Source products & services.',
            iconAsset: SomAssets.authRoleBuyer,
            selected: registrationRequest.company.isBuyer,
            onTap: () => registrationRequest.company.setRole(Roles.Buyer),
            buttonText: 'Register as Buyer',
          ),
        ),
        40.width,
        SizedBox(
          width: appStore.buttonWidth,
          child: _roleCard(
            context: context,
            roleKey: 'provider',
            title: 'Provider',
            subtitle: 'Grow your business.',
            iconAsset: SomAssets.authRoleProvider,
            selected: registrationRequest.company.isProvider,
            onTap: () => registrationRequest.company.setRole(Roles.Provider),
            buttonText: 'Register as Provider',
          ),
        ),
      ],
    );
  }

  Widget mobile(BuildContext context, RegistrationRequest registrationRequest) {
    return Column(
      children: [
        _roleCard(
          context: context,
          roleKey: 'buyer',
          title: 'Buyer',
          subtitle: 'Source products & services.',
          iconAsset: SomAssets.authRoleBuyer,
          selected: registrationRequest.company.isBuyer,
          onTap: () => registrationRequest.company.setRole(Roles.Buyer),
          buttonText: 'Register as Buyer',
        ),
        10.height,
        _roleCard(
          context: context,
          roleKey: 'provider',
          title: 'Provider',
          subtitle: 'Grow your business.',
          iconAsset: SomAssets.authRoleProvider,
          selected: registrationRequest.company.isProvider,
          onTap: () => registrationRequest.company.setRole(Roles.Provider),
          buttonText: 'Register as Provider',
        ),
      ],
    );
  }
}
