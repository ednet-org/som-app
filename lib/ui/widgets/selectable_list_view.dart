import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';

class SelectableListView<T> extends StatefulWidget {
  const SelectableListView({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelectedIndex,
    required this.itemBuilder,
    this.controller,
    this.enableKeyboardNavigation = true,
    this.enableStaggeredAnimation = true,
    this.staggerDelay = const Duration(milliseconds: 40),
    this.maxAnimatedItems = 15,
    this.cacheExtent = 500,
  });

  final List<T> items;
  final int? selectedIndex;
  final ValueChanged<int> onSelectedIndex;
  final Widget Function(BuildContext context, T item, bool isSelected)
      itemBuilder;
  final ScrollController? controller;
  final bool enableKeyboardNavigation;
  final bool enableStaggeredAnimation;
  final Duration staggerDelay;
  /// Maximum number of items to animate for performance (items beyond this show instantly)
  final int maxAnimatedItems;
  /// Cache extent for ListView.builder virtualization
  final double cacheExtent;

  @override
  State<SelectableListView<T>> createState() => _SelectableListViewState<T>();
}

class _SelectableListViewState<T> extends State<SelectableListView<T>> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(debugLabel: 'SelectableListView');
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget list = ListView.builder(
      controller: widget.controller,
      itemCount: widget.items.length,
      cacheExtent: widget.cacheExtent,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final isSelected = index == widget.selectedIndex;
        final child = widget.itemBuilder(context, item, isSelected);
        // Only animate first N items for performance - beyond that show instantly
        if (!widget.enableStaggeredAnimation || index >= widget.maxAnimatedItems) {
          return child;
        }
        return _StaggeredListItem(
          index: index,
          delay: widget.staggerDelay,
          child: child,
        );
      },
    );

    if (!widget.enableKeyboardNavigation) {
      return list;
    }

    return FocusableActionDetector(
      focusNode: _focusNode,
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowDown): _ListNavIntent(1),
        SingleActivator(LogicalKeyboardKey.arrowUp): _ListNavIntent(-1),
      },
      actions: <Type, Action<Intent>>{
        _ListNavIntent: CallbackAction<_ListNavIntent>(
          onInvoke: (intent) {
            _moveSelection(intent.direction);
            return null;
          },
        ),
      },
      child: GestureDetector(
        onTap: () => _focusNode.requestFocus(),
        behavior: HitTestBehavior.translucent,
        child: list,
      ),
    );
  }

  void _moveSelection(int direction) {
    if (widget.items.isEmpty) return;
    final current = widget.selectedIndex ?? -1;
    int next = current + direction;
    if (current == -1) {
      next = direction > 0 ? 0 : widget.items.length - 1;
    }
    next = next.clamp(0, widget.items.length - 1);
    if (next != current) {
      widget.onSelectedIndex(next);
    }
  }
}

class _ListNavIntent extends Intent {
  const _ListNavIntent(this.direction);
  final int direction;
}

class _StaggeredListItem extends StatefulWidget {
  const _StaggeredListItem({
    required this.index,
    required this.child,
    required this.delay,
  });

  final int index;
  final Widget child;
  final Duration delay;

  @override
  State<_StaggeredListItem> createState() => _StaggeredListItemState();
}

class _StaggeredListItemState extends State<_StaggeredListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: SomDuration.slow,
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(_fade);

    _timer = Timer(
      Duration(milliseconds: widget.delay.inMilliseconds * widget.index),
      () {
      if (mounted) _controller.forward();
    },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}
