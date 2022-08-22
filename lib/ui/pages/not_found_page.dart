import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/components/ActionButton.dart';
import 'package:som/ui/components/funny_logo.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FunnyLogo(
              height: 200.0,
              onPrimary: Theme.of(context).colorScheme.error,
              primary: Theme.of(context).colorScheme.errorContainer,
            ),
            const SizedBox(
              height: 70,
            ),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
            const SizedBox(
              height: 7,
            ),
            ActionButton(
              width: 300.0,
              onPrimary: Theme.of(context).colorScheme.error,
              primary: Theme.of(context).colorScheme.errorContainer,
              textContent: "Home",
              onPressed: () => context.beamToNamed('/'),
            ),
          ],
        ),
      ),
    );
  }
}
