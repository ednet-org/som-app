import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class SomDropDown extends StatelessWidget {
  final String? value;
  final onChanged;
  final String? hint;
  final items;

  const SomDropDown(
      {Key? key, this.onChanged, this.value, this.hint, this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      popupProps: PopupProps.modalBottomSheet(
        modalBottomSheetProps: ModalBottomSheetProps(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
          // backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 10,
        ),
        itemBuilder: (context, value, displayValue) {
          return ListTile(
            title: Text(value,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    )),
          );
        },
        emptyBuilder: (context, _) {
          return Center(
            child: Text(
              textAlign: TextAlign.center,
              'No data found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          );
        },
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
          decoration: InputDecoration(
            filled: true,
            hintText: 'Search here...',
            hintStyle: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            fillColor: Theme.of(context).colorScheme.secondary,
            focusColor: Theme.of(context).colorScheme.onSecondary,
            hoverColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        containerBuilder: (BuildContext context, widget) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: widget,
          );
        },
        textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
      dropdownBuilder: (context, value) {
        return Text(value ?? 'n/a',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ));
      },
      items: items,
      onChanged: onChanged,
      selectedItem: value,
      dropdownDecoratorProps: DropDownDecoratorProps(
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          baseStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
          dropdownSearchDecoration: InputDecoration(
            icon: const Icon(Icons.edit_location),
            labelText: 'Country',
            hintText: hint,
            fillColor: Theme.of(context).colorScheme.secondary,
            focusColor: Theme.of(context).colorScheme.secondary,
          )),
    );
  }
}
