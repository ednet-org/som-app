import 'package:flutter/material.dart';

class MainBody extends StatelessWidget {
  final Widget? child;

  const MainBody({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: SizedBox(
            width: 800,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
