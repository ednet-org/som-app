import 'package:flutter/material.dart';

class PositionedInfo extends StatelessWidget {
  final double top;
  final double left;
  final Widget child;

  const PositionedInfo(
      {super.key, required this.top, required this.left, required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: child,
    );
  }
}
