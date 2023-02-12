import 'package:flutter/material.dart';
import 'package:som/ui/utils/AppWidget.dart';

class MainBody extends StatelessWidget {
  final child;

  const MainBody({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: SizedBox(
            width: dynamicWidth(context),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
