import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/components/high/funny_logo.dart';

import '../components/low/buttons/action_button.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.error,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FunnyLogo(
              color: Theme.of(context).colorScheme.onError,
            ),
            Text(
              'Page not found 404',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onError,
                  ),
            ),
            const SizedBox(
              height: 10,
            ),
            ActionButton(
              width: 320.0,
              onPrimary: Theme.of(context).colorScheme.onError,
              primary: Theme.of(context).colorScheme.error,
              textContent: "Home",
              onPressed: () => context.beamToNamed('/'),
            ),
          ],
        ),
      ),
    );
  }
}
