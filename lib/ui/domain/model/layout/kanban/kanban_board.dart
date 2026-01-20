import 'package:flutter/material.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';

class AdaptiveLayout extends StatefulWidget {
  final Widget? header;
  final Widget? mainMenu;
  final Widget? footer;
  final int maxSplits;

  const AdaptiveLayout({
    super.key,
    this.header,
    this.mainMenu,
    this.footer,
    this.maxSplits = 3,
  });

  @override
  State<AdaptiveLayout> createState() => _AdaptiveLayoutState();
}

class _AdaptiveLayoutState extends State<AdaptiveLayout> {
  late ScrollController _scrollController;
  late List<ScrollController> _bodyControllers;
  late List<Widget> _bodyWidgets;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _bodyControllers = List.generate(
      widget.maxSplits,
      (_) => ScrollController(),
    );
    _bodyWidgets = List.generate(
      widget.maxSplits,
      (_) => Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.transparent,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (var controller in _bodyControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addSplit() {
    setState(() {
      _bodyWidgets.add(
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.transparent,
        ),
      );
      _bodyControllers.add(ScrollController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.header ?? const SizedBox.shrink(),
        Expanded(
          child: _bodyWidgets.isEmpty
              ? Container()
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: Row(
                    children: List.generate(
                      _bodyWidgets.length,
                      (index) => Expanded(
                        child: SingleChildScrollView(
                          controller: _bodyControllers[index],
                          child: _bodyWidgets[index],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        widget.footer ?? const SizedBox.shrink()
      ],
    );
  }
}

class KanbanBoard extends StatelessWidget {
  const KanbanBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      header: SizedBox(
        height: 50,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              tooltip: 'Add column',
              icon: SomSvgIcon(
                SomAssets.iconChevronRight,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onPressed: () => _AdaptiveLayoutState()._addSplit(),
            ),
          ],
        ),
      ),
      mainMenu: const SizedBox.shrink(),
      footer: SizedBox(
        height: 50,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              tooltip: 'Add column',
              icon: SomSvgIcon(
                SomAssets.iconChevronRight,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onPressed: () => _AdaptiveLayoutState()._addSplit(),
            ),
          ],
        ),
      ),
    );
  }
}
