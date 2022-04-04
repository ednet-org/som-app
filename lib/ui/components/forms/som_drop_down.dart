import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'countries.dart';

class SomDropDown extends StatelessWidget {
  final value;
  final onChanged;

  const SomDropDown({this.onChanged, this.value}) : super();

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
        mode: Mode.MENU,
        items: countries,
        onChanged: onChanged,
        selectedItem: value,
        dropdownSearchDecoration: InputDecoration(
          prefixIcon: Icon(Icons.edit_location),
          label: Text('Country'),
        ));
  }
}
