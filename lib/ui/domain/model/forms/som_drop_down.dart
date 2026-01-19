import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:som/ui/theme/som_assets.dart';

class SomDropDown<T> extends StatelessWidget {
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final List<T>? items;
  final String Function(T)? itemAsString;
  final bool Function(T, T)? compareFn;
  final String? label;
  final String? errorText;
  final PopupMode popupMode;
  final BoxConstraints? popupConstraints;
  final bool showSearchBox;

  const SomDropDown({
    super.key,
    this.label,
    this.onChanged,
    this.value,
    this.hint,
    this.items,
    this.itemAsString,
    this.compareFn,
    this.popupMode = PopupMode.modalBottomSheet,
    this.popupConstraints,
    this.showSearchBox = true,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Common decoration for the dropdown
    final inputDecoration = InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: errorText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      // Use futuristic icons
      icon: SvgPicture.asset(
        SomAssets.iconMenu,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(theme.iconTheme.color!, BlendMode.srcIn),
      ),
      suffixIcon: SvgPicture.asset(
        SomAssets.iconChevronDown,
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(theme.iconTheme.color!, BlendMode.srcIn),
      ),
    );

    Widget popupItemBuilder(
      BuildContext context,
      T item,
      bool isDisabled,
      bool isSelected,
    ) {
      final text = itemAsString?.call(item) ?? item.toString();
      return ListTile(
        title: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? SvgPicture.asset(
                SomAssets.offerStatusAccepted,
                width: 20,
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.primary,
                  BlendMode.srcIn,
                ),
              )
            : null,
      );
    }

    Widget popupEmptyBuilder(BuildContext context, String searchEntry) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(SomAssets.illustrationEmptyState, height: 100),
            const SizedBox(height: 16),
            Text('No data found', style: theme.textTheme.titleMedium),
          ],
        ),
      );
    }

    TextFieldProps popupSearchFieldProps() {
      return TextFieldProps(
        padding: const EdgeInsets.all(16),
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          filled: true,
          hintText: 'Search...',
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(SomAssets.iconSearch, width: 20),
          ),
        ),
      );
    }

    PopupProps<T> popupProps;
    switch (popupMode) {
      case PopupMode.menu:
        popupProps = PopupProps<T>.menu(
          showSelectedItems: true,
          showSearchBox: showSearchBox,
          constraints: popupConstraints ?? const BoxConstraints(maxHeight: 350),
          itemBuilder: popupItemBuilder,
          emptyBuilder: popupEmptyBuilder,
          searchFieldProps: popupSearchFieldProps(),
          containerBuilder: (BuildContext context, widget) {
            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: widget,
            );
          },
        );
        break;
      case PopupMode.dialog:
        popupProps = PopupProps<T>.dialog(
          showSelectedItems: true,
          showSearchBox: showSearchBox,
          constraints:
              popupConstraints ??
              BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.5,
                maxWidth: MediaQuery.of(context).size.width * 0.7,
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
          itemBuilder: popupItemBuilder,
          emptyBuilder: popupEmptyBuilder,
          searchFieldProps: popupSearchFieldProps(),
          containerBuilder: (BuildContext context, widget) {
            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: widget,
            );
          },
        );
        break;
      case PopupMode.modalBottomSheet:
      case PopupMode.bottomSheet:
        popupProps = PopupProps<T>.modalBottomSheet(
          showSelectedItems: true,
          showSearchBox: showSearchBox,
          modalBottomSheetProps: ModalBottomSheetProps(
            backgroundColor: theme.colorScheme.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            elevation: 10,
          ),
          itemBuilder: popupItemBuilder,
          emptyBuilder: popupEmptyBuilder,
          constraints:
              popupConstraints ??
              BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
          searchFieldProps: popupSearchFieldProps(),
          containerBuilder: (BuildContext context, widget) {
            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: widget,
            );
          },
        );
        break;
    }

    return DropdownSearch<T>(
      popupProps: popupProps,
      compareFn: compareFn ?? (a, b) => a == b,
      dropdownBuilder: (context, item) {
        final text = item != null
            ? (itemAsString?.call(item) ?? item.toString())
            : (hint ?? 'Select option');
        return Text(text, style: theme.textTheme.bodyMedium);
      },
      items: (filter, loadProps) => items ?? <T>[],
      itemAsString: itemAsString,
      onChanged: onChanged,
      selectedItem: value,
      decoratorProps: DropDownDecoratorProps(
        textAlign: TextAlign.start,
        baseStyle: theme.textTheme.bodyMedium,
        decoration: inputDecoration,
      ),
    );
  }
}
