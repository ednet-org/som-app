import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class SomSkeleton extends StatelessWidget {
  const SomSkeleton({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.borderRadius,
    this.margin,
  });

  const SomSkeleton.circle({
    super.key,
    required double size,
    this.margin,
  })  : height = size,
        width = size,
        borderRadius = const BorderRadius.all(Radius.circular(999));

  final double height;
  final double width;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHigh;
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius ?? BorderRadius.circular(SomRadius.sm),
      ),
    );
  }
}

class SomSkeletonList extends StatelessWidget {
  const SomSkeletonList({
    super.key,
    this.itemCount = 6,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: SomSpacing.sm),
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SomSpacing.md,
          vertical: SomSpacing.xs,
        ),
        child: Row(
          children: [
            const SomSkeleton.circle(size: 32),
            const SizedBox(width: SomSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SomSkeleton(height: 14, width: 180),
                  SizedBox(height: SomSpacing.xs),
                  SomSkeleton(height: 12, width: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
