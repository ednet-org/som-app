import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SomSvgIcon extends StatelessWidget {
  const SomSvgIcon(
    this.asset, {
    super.key,
    this.size = 20,
    this.color,
    this.semanticLabel,
    this.fit = BoxFit.contain,
  });

  final String asset;
  final double size;
  final Color? color;
  final String? semanticLabel;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      fit: fit,
      semanticsLabel: semanticLabel,
      colorFilter:
          color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
