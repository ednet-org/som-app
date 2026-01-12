import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class SomDropDown extends StatelessWidget {
  final String? value;
  final onChanged;
  final String? hint;
  final items;

  final String? label;

  const SomDropDown({
    Key? key,
    this.label,
    this.onChanged,
    this.value,
    this.hint,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DropdownSearchOnFind<String>? resolvedItems = items is List<String>
        ? (String filter, LoadProps? loadProps) => items as List<String>
        : items as DropdownSearchOnFind<String>?;

    return DropdownSearch<String>(
      popupProps: PopupProps.modalBottomSheet(
        showSelectedItems: true,
        modalBottomSheetProps: ModalBottomSheetProps(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
          elevation: 10,
        ),
        itemBuilder: (context, value, isDisabled, isSelected) {
          return ListTile(
            // style: ListTileTheme.of(context).style,
            title: Text(
              value,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          );
        },
        emptyBuilder: (context, _) {
          return Center(
            child: Text(
              textAlign: TextAlign.center,
              'No data found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          );
        },
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          padding: const EdgeInsets.all(20),
          autofocus: true,
          style: Theme.of(context).textTheme.labelLarge,
          decoration: InputDecoration(
            filled: true,
            hintText: 'Search here...',
            hintStyle: Theme.of(context).textTheme.labelLarge,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        containerBuilder: (BuildContext context, widget) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: widget,
          );
        },
      ),
      dropdownBuilder: (context, value) {
        return Text(value ?? 'n/a',
            style: Theme.of(context).textTheme.labelLarge);
      },
      items: resolvedItems,
      onChanged: onChanged,
      selectedItem: value,
      decoratorProps: DropDownDecoratorProps(
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        baseStyle: Theme.of(context).textTheme.labelLarge,
        decoration: InputDecoration(
          icon: const Icon(Icons.edit_location),
          labelText: label,
          hintText: hint,
        ),
      ),
      // clearButtonProps: ClearButtonProps(
      //   icon: const Icon(Icons.clear),
      //   color: Theme.of(context).colorScheme.secondary,
      // ),
    );
  }
}
