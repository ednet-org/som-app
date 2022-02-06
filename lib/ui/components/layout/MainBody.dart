import 'package:flutter/material.dart';
import 'package:som/template_storage/main/utils/AppWidget.dart';

class MainBody extends StatelessWidget {
  final child;

  const MainBody({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Container(
          width: dynamicWidth(context),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
