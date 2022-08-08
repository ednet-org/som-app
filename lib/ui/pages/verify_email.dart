import 'package:flutter/material.dart';
import 'package:som/ui/components/forms/som_text_input.dart';

class VerifyEmailPage extends StatefulWidget {
  static String tag = '/VerifyEmailPage';

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text('Your email has been verified',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.primary)),
            SizedBox(width: 10),
            SizedBox(height: 100),
            Text('Please set your password',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.primary)),
            Container(
              width: 350,
              child: SomTextInput(
                label: 'Password',
                isPassword: true,
              ),
            ),
            Container(
              width: 350,
              child: SomTextInput(
                label: 'Repeat password',
                hint: 'Please repeat your password',
                isPassword: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
