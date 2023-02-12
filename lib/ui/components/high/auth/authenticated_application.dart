import 'package:flutter/material.dart';

class AuthenticatedApplication extends StatelessWidget {
  const AuthenticatedApplication({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authenticated App'),
      ),
      body: Center(
        child: Text('Authenticated App'),
      ),
    );
  }
}
