import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color gray700 = fromHex('#625b71');

  static Color black900 = fromHex('#000000');

  static Color lightGreenA700 = fromHex('#78ea33');

  static Color gray900 = fromHex('#1c1b1e');

  static Color indigo900 = fromHex('#381e72');

  static Color whiteA701 = fromHex('#ffffff');

  static Color whiteA700 = fromHex('#fffbff');

  static Color black90026 = fromHex('#26000000');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
