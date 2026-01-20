import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:som/ui/widgets/debounced_search_field.dart';

void main() {
  testWidgets('DebouncedSearchField calls onSearch after debounce', (tester) async {
    String value = '';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DebouncedSearchField(
            debounce: const Duration(milliseconds: 50),
            onSearch: (text) => value = text,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '  hello ');
    await tester.pump(const Duration(milliseconds: 20));
    expect(value, '');
    await tester.pump(const Duration(milliseconds: 40));
    expect(value, 'hello');
  });

  testWidgets('DebouncedSearchField clear button resets value', (tester) async {
    String value = 'initial';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DebouncedSearchField(
            debounce: const Duration(milliseconds: 50),
            onSearch: (text) => value = text,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'query');
    await tester.pump();
    await tester.tap(find.byTooltip('Clear search'));
    await tester.pump();
    expect(value, '');
  });
}
