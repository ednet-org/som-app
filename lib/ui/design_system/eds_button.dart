import 'package:flutter/material.dart';
import 'package:som/main.dart';

class EdsButton extends StatelessWidget {
  EdsButton({super.key});

  @override
  Widget build(BuildContext context) {
    var textStyle = darkTheme!.textTheme.titleMedium;
    return Text(
      'Ovo je neki tekst',
      style: textStyle,
    );
  }
}
