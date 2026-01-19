import 'package:flutter/material.dart';

class SpacedContainer extends StatelessWidget {
  final Widget horizontalBody;

  const SpacedContainer({super.key, required this.horizontalBody});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.5),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(7.5),
                child: Container(
                  child: horizontalBody,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
