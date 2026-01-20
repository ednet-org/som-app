import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/som_application.dart';
import 'package:som/ui/widgets/snackbars.dart';

import '../../domain/application/application.dart';
import '../../domain/model/login.dart';

class AuthLoginPage extends StatelessWidget {
  static String tag = '/DTLogin';

  const AuthLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    final emailLoginStore = Provider.of<Application>(context);
    return Observer(
      builder: (_) => appStore.isAuthenticated
          ? const SomApplication()
          : SafeArea(
              child: ReactionBuilder(
                builder: (BuildContext context) {
                  return reaction((_) => appStore.isAuthenticated, (result) {
                    final message = result == true
                        ? 'You\'re authenticated'
                        : 'You\'re not authenticated';
                    SomSnackBars.info(context, message);
                  }, delay: 4000);
                },
                child: Scaffold(
                  body: LayoutBuilder(
                    builder: (buildContext, BoxConstraints constraints) {
                      final is4K = constraints.maxWidth > 2200;
                      if (is4K) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: expandedItems(
                            is4K,
                            context,
                            emailLoginStore,
                            constraints,
                          ),
                        );
                      }
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: expandedItems(
                            is4K,
                            context,
                            emailLoginStore,
                            constraints,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }

  List<Widget> expandedItems(
    bool is4K,
    BuildContext context,
    Application emailLoginStore,
    BoxConstraints constraints,
  ) {
    final logo = splitWithLogo(context, emailLoginStore, is4K, constraints);
    final login = splitWithLogin(context, is4K, constraints);

    if (!is4K) {
      return [logo, login];
    }

    return [Expanded(flex: 5, child: logo), Expanded(flex: 7, child: login)];
  }

  Widget splitWithLogo(
    BuildContext context,
    Application emailLoginStore,
    bool is4K,
    BoxConstraints constraints,
  ) {
    final double maxLogoHeight = constraints.maxHeight.isFinite
        ? (constraints.maxHeight * 0.6).clamp(360.0, 640.0)
        : 520.0;
    final double logoSize = math.min(240.0, maxLogoHeight * 0.22);
    final double heroSize = math.min(300.0, maxLogoHeight * 0.45);
    return Container(
      width: double.infinity,
      constraints: is4K
          ? const BoxConstraints.expand()
          : const BoxConstraints(minHeight: 420),
      child: Stack(
        children: [
          // Background Layer
          Positioned.fill(
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: Opacity(
                opacity: 0.12,
                child: SvgPicture.asset(
                  SomAssets.patternSubtleMesh,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          // Content Layer
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        SomAssets.logoPng,
                        width: logoSize,
                        height: logoSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Smart offer management'.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w300,
                                letterSpacing: 2.0,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SvgPicture.asset(
                      SomAssets.illustrationLoginHero,
                      width: heroSize,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 18),
                    _buildFeatureRow(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _featureTile(
          context,
          label: 'Analytics',
          child: SvgPicture.asset(
            SomAssets.illustrationFeatureAnalytics,
            width: 80,
            height: 80,
            fit: BoxFit.contain,
          ),
        ),
        _featureTile(
          context,
          label: 'Secure Auth',
          child: SvgPicture.asset(
            SomAssets.illustrationFeatureSecureAuth,
            width: 80,
            height: 80,
            fit: BoxFit.contain,
          ),
        ),
        _featureTile(
          context,
          label: 'Smart Offers',
          child: SvgPicture.asset(
            SomAssets.iconOffers,
            width: 42,
            height: 42,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }

  Widget _featureTile(
    BuildContext context, {
    required String label,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 56, child: Center(child: child)),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget splitWithLogin(
    BuildContext context,
    bool is4K,
    BoxConstraints constraints,
  ) {
    return Container(
      padding: const EdgeInsets.all(50.0),
      color: Theme.of(context).colorScheme.surface,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: is4K
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          if (!is4K) SizedBox(height: constraints.maxHeight * 0.02),
          const Login(key: Key('Login')),
        ],
      ),
    );
  }
}
