import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:som/template_storage/main/store/application.dart';

class FunnyLogo extends StatelessWidget {
  final height;

  const FunnyLogo(this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);

    return GestureDetector(
        onTap: () {
          appStore.toggleDarkMode();
        },
        child: Container(
          alignment: Alignment.center,
          child: Image.asset(
            'images/som/logo.png',
            height: height,
            fit: BoxFit.fitHeight,
            color: Theme.of(context).colorScheme.primary,
          ),
        ));
  }
}
