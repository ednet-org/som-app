import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/components/high/funny_logo.dart';
import 'package:som/ui/som_application.dart';

import '../../components/high/Login.dart';
import '../../domain/app_config/application.dart';

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
                                  hasScrollBody: false,
                                  child: Column(
                                    // mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: expandedItems(is4K, context,
                                        emailLoginStore, constraints),
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
    return [
      Expanded(
          flex: is4K ? 5 : 1,
          child: splitWithLogo(context, emailLoginStore, is4K)),
      Expanded(
        flex: is4K ? 7 : 3,
        child: splitWithLogin(context, is4K, constraints),
      ),
    ];
  }

  splitWithLogo(context, emailLoginStore, is4K) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: !is4K ? Alignment.topCenter : Alignment.centerLeft,
          end: !is4K ? Alignment.bottomCenter : Alignment.centerRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.onPrimary,
          ],
        ),
      ),
      // color: Theme.of(context).colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FunnyLogo(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Smart offer management'.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ],
      ),
    );
  }

  splitWithLogin(context, is4K, constraints) {
    return Container(
      padding: const EdgeInsets.all(50.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: !is4K ? Alignment.bottomCenter : Alignment.centerRight,
          end: !is4K ? Alignment.topCenter : Alignment.centerLeft,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.onPrimary,
          ],
        ),
      ),
      alignment: Alignment.center,
      // color: Theme.of(context).colorScheme.primaryContainer,
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
