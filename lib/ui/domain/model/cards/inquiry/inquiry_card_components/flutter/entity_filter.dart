import 'package:flutter/material.dart';

import '../../../../forms/som_drop_down.dart';
import '../../../../forms/som_text_input.dart';
import '../core/i_filter.dart';

class EntityFilter<T extends IFilter> extends StatelessWidget {
  final T filter;

  // on changed
  final onChanged;

  const EntityFilter(
    this.filter, {
    super.key,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 295,
      child: Column(
        children: [
          getRender(),
        ],
      ),
    );
  }

  Widget getRender() {
    switch (filter.mode) {
      case DisplayMode.label:
        return renderLabel();
      case DisplayMode.input:
        return renderInput();
      case DisplayMode.dropdown:
        return renderSelect();
      case DisplayMode.checkbox:
        return renderCheckBox();
      case DisplayMode.list:
        return renderList();
      case DisplayMode.grid:
        return renderGrid();
      default:
        return renderLabel();
    }
  }

  Checkbox renderCheckBox() {
    return Checkbox(
      value: filter.value as bool,
      onChanged: onChanged,
    );
  }

  SomDropDown renderSelect() {
    return SomDropDown(
      // key: key,
      items: filter.allowedValues?.map((a) => a.name).toList(),
      label: filter.name,
      onChanged: onChanged,
    );
  }

  SomTextInput renderInput() {
    return SomTextInput(
      key: key,
      label: filter.name,
      onChanged: (value) {
        print(value);
      },
    );
  }

  // filter string summary
  Text renderLabel() {
    return Text(
      '${filter.name}: ${filter.value}',
    );
  }

  Widget renderList() {
    throw Exception('Not implemented');
  }

  Widget renderGrid() {
    throw Exception('Not implemented');
  }
}
