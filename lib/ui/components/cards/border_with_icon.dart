import 'dart:math' as math;

import 'package:flutter/material.dart';

class BorderWithIcon extends StatelessWidget {
  const BorderWithIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator BorderWithIcon - GROUP
    return Container(
        width: 628,
        height: 604,
        child: Stack(children: <Widget>[
          Positioned(
              top: 604,
              left: 0,
              child: Transform.rotate(
                angle: 90 * (math.pi / 180),
                child: Container(
                    width: 565,
                    height: 628,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                        bottomLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(103, 80, 164, 1),
                        width: 4,
                      ),
                    )),
              )),
          const Positioned(top: 0, left: 264, child: Text('Border with icon')),
        ]));
  }
}
