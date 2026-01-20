import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:som/ui/widgets/selectable_list_view.dart';

void main() {
  testWidgets('SelectableListView supports keyboard navigation', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: _SelectableListHarness(),
        ),
      ),
    );

    await tester.tap(find.text('Alpha'));
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(_selectedText(tester), 'Alpha');

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(_selectedText(tester), 'Beta');

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();
    expect(_selectedText(tester), 'Alpha');
  });
}

String _selectedText(WidgetTester tester) {
  final text = tester.widget<Text>(find.byKey(const Key('selected')));
  return text.data ?? '';
}

class _SelectableListHarness extends StatefulWidget {
  const _SelectableListHarness();

  @override
  State<_SelectableListHarness> createState() => _SelectableListHarnessState();
}

class _SelectableListHarnessState extends State<_SelectableListHarness> {
  final _items = const ['Alpha', 'Beta', 'Gamma'];
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final selectedLabel =
        _selectedIndex == null ? '' : _items[_selectedIndex!];
    return Column(
      children: [
        Text(selectedLabel, key: const Key('selected')),
        Expanded(
          child: SelectableListView<String>(
            items: _items,
            selectedIndex: _selectedIndex,
            onSelectedIndex: (index) =>
                setState(() => _selectedIndex = index),
            enableStaggeredAnimation: false,
            itemBuilder: (context, item, isSelected) {
              return ListTile(title: Text(item));
            },
          ),
        ),
      ],
    );
  }
}
