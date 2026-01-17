import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../application/application.dart';
import '../../theme/som_assets.dart';

class FunnyLogo extends StatelessWidget {
  final double height;

  final Color? color;

  const FunnyLogo({Key? key, this.height = 300.0, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    final Color? iconColor = color;

    return GestureDetector(
        onTap: () {
          appStore.toggleDarkMode();
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(height / 4),
              child: ImageIcon(
                size: height,
                const AssetImage(SomAssets.logoPng),
              ),
            ),
            ReactionBuilder(
              builder: (BuildContext context) => reaction(
                  (_) => appStore.isDarkModeOn,
                  (bool isOn) =>
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(isOn ? 'Dark mode' : 'Light mode'),
                        duration: const Duration(milliseconds: 1500),
                      ))),
              child: Container(),
            ),
          ],
        ));
  }
}
