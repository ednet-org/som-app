import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class SomDropDown extends StatelessWidget {
  final String? value;
  final onChanged;
  final String? hint;
  final items;

  const SomDropDown({this.onChanged, this.value, this.hint, this.items})
      : super();

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      // mode: Mode.MENU,
      items: items,
      onChanged: onChanged,
      selectedItem: value,
      dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
        icon: Icon(Icons.edit_location),
        labelText: 'Country',
        hintText: hint,
      )),
    );
  }
}
