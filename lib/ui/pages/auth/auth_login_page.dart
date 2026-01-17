import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/som_application.dart';

import '../../domain/application/application.dart';
import '../../domain/model/login.dart';

class AuthLoginPage extends StatelessWidget {
  static String tag = '/DTLogin';

  const AuthLoginPage({Key? key}) : super(key: key);

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
                    final messenger = ScaffoldMessenger.of(context);

                    messenger.showSnackBar(SnackBar(
                        content: Text(result == true
                            ? 'You\'re authenticated'
                            : 'You\'re not authenticated')));
                  }, delay: 4000);
                },
                child: Scaffold(
                  body: LayoutBuilder(
                    builder: (buildContext, BoxConstraints constraints) {
                      final is4K = constraints.maxWidth > 2200;
                      return CustomScrollView(
                        slivers: !is4K
                            ? [
                                SliverFillRemaining(
                                  hasScrollBody: true,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      // mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: expandedItems(is4K, context,
                                          emailLoginStore, constraints),
                                    ),
                                  ),
                                )
                              ]
                            : [
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Row(
                                    // mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: expandedItems(is4K, context,
                                        emailLoginStore, constraints),
                                  ),
                                )
                              ],
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }

  List<Widget> expandedItems(bool is4K, BuildContext context,
      Application emailLoginStore, constraints) {
    final logo = splitWithLogo(context, emailLoginStore, is4K);
    final login = splitWithLogin(context, is4K, constraints);

    if (!is4K) {
      return [logo, login];
    }

    return [
      Expanded(flex: 5, child: logo),
      Expanded(flex: 7, child: login),
    ];
  }

  splitWithLogo(context, emailLoginStore, is4K) {
    return Stack(
      children: [
        // Background Layer
        Positioned.fill(
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: Opacity(
              opacity: 0.1, // Subtle pattern
              child: SvgPicture.asset(
                SomAssets.patternSubtleMesh,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary,
                   BlendMode.srcIn),
              ),
            ),
          ),
        ),
        // Content Layer
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: const EdgeInsets.all(20.0),
                child: SvgPicture.asset(SomAssets.logoFull, width: 250)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Smart offer management'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w300, letterSpacing: 2.0),
                ),
              ),
              const SizedBox(height: 24),
              SvgPicture.asset(
                SomAssets.illustrationLoginHero,
                width: 320,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(
                        SomAssets.illustrationFeatureAnalytics,
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Analytics',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SvgPicture.asset(
                        SomAssets.illustrationFeatureSecureAuth,
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Secure Auth',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  splitWithLogin(context, is4K, constraints) {
    return Container(
      padding: const EdgeInsets.all(50.0),
      color: Theme.of(context).colorScheme.surface, 
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment:
            is4K ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          if (!is4K) SizedBox(height: constraints.maxHeight * 0.02),
          const Login(
            key: Key('Login'),
          ),
        ],
      ),
    );
  }
}
