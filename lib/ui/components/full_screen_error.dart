import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FullScreenError extends StatelessWidget {
  const FullScreenError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return showMaterialModalBottomSheet(
        context: context, builder: (builderContext) {
      return Container();
    })
  }
}
