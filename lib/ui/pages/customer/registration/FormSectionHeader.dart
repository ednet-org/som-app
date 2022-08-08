import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FormSectionHeader extends StatelessWidget {
  final String label;

  const FormSectionHeader({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        40.height,
        Text(label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.9))),
      ],
    );
  }
}
