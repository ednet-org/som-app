import 'package:flutter/material.dart';

class SpacedContainer extends StatelessWidget {
  final horizontalBody;

  const SpacedContainer({Key? key, this.horizontalBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: horizontalBody,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
