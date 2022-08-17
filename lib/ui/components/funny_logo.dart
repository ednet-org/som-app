import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:som/template_storage/main/store/application.dart';

class FunnyLogo extends StatelessWidget {
  final height;

  final Color? primary;
  final Color? onPrimary;

  const FunnyLogo({Key? key, this.height = 300.0, this.primary, this.onPrimary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);

    return GestureDetector(
        onTap: () {
          appStore.toggleDarkMode();
        },
        child: Container(
          color: this.primary ?? Theme.of(context).colorScheme.primary,
          alignment: Alignment.center,
          child: Image.asset(
            'images/som/logo.png',
            height: height,
            fit: BoxFit.fitHeight,
            color: this.onPrimary ?? Theme.of(context).colorScheme.onPrimary,
          ),
        ));
  }
}
