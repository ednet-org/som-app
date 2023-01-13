import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../positioned _info.dart';

class InquiryCardDivider extends StatelessWidget {
  const InquiryCardDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return PositionedInfo(
        top: 51,
        left: 1,
        child: Transform.rotate(
          angle: 2.4848083448933725e-17 * (math.pi / 180),
          child: const Divider(color: Color.fromRGBO(0, 0, 0, 1), thickness: 1),
        ));
  }
}
