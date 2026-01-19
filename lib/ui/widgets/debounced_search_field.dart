import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/som_assets.dart';
import '../theme/tokens.dart';
import 'design_system/som_svg_icon.dart';

class DebouncedSearchField extends StatefulWidget {
  const DebouncedSearchField({
    super.key,
    required this.onSearch,
    this.controller,
    this.hintText = 'Search',
    this.debounce = const Duration(milliseconds: 350),
  });

  final ValueChanged<String> onSearch;
  final TextEditingController? controller;
  final String hintText;
  final Duration debounce;

  @override
  State<DebouncedSearchField> createState() => _DebouncedSearchFieldState();
}

class _DebouncedSearchFieldState extends State<DebouncedSearchField> {
  late final TextEditingController _controller;
  Timer? _timer;

  bool get _hasExternalController => widget.controller != null;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleTextChange);
  }

  @override
  void didUpdateWidget(covariant DebouncedSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller && _hasExternalController) {
      oldWidget.controller?.removeListener(_handleTextChange);
      widget.controller?.addListener(_handleTextChange);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.removeListener(_handleTextChange);
    if (!_hasExternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleTextChange() {
    setState(() {});
    _timer?.cancel();
    _timer = Timer(widget.debounce, () {
      widget.onSearch(_controller.text.trim());
    });
  }

  void _clear() {
    _controller.clear();
    widget.onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: SomSvgIcon(
          SomAssets.iconSearch,
          size: SomIconSize.sm,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          semanticLabel: 'Search',
        ),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                tooltip: 'Clear search',
                icon: SomSvgIcon(
                  SomAssets.iconClearCircle,
                  size: SomIconSize.sm,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  semanticLabel: 'Clear',
                ),
                onPressed: _clear,
              )
            : null,
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (value) => widget.onSearch(value.trim()),
    );
  }
}
