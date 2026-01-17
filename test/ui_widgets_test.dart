import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:som/ui/widgets/app_toolbar.dart';
import 'package:som/ui/widgets/empty_state.dart';

void main() {
  testWidgets('AppToolbar renders title and actions', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: AppToolbar(
            title: const Text('Offers'),
            actions: [
              TextButton(onPressed: () {}, child: const Text('Refresh')),
              FilledButton(onPressed: () {}, child: const Text('Create')),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Offers'), findsOneWidget);
    expect(find.text('Refresh'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
  });

  testWidgets('EmptyState renders title, message, and action', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: EmptyState(
            icon: Icons.inbox_outlined,
            title: 'No items',
            message: 'Create your first item',
            action: TextButton(
              onPressed: () {},
              child: const Text('Create'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('No items'), findsOneWidget);
    expect(find.text('Create your first item'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
  });
}
