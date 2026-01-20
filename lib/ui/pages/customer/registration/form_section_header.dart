import 'package:flutter/material.dart';
import 'package:som/ui/theme/tokens.dart';

class FormSectionHeader extends StatelessWidget {
  final String label;

  const FormSectionHeader({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: SomSpacing.xl),
        Text(label, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
