import 'package:flutter/material.dart';

enum Position { upperLeft, upperRight, lowerLeft, lowerRight }

enum Direction { horizontal, vertical }

class AppFooter {
  Widget? leftThumb;
  Widget? rightThumb;

  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Row(
        children: [
          if (leftThumb != null) leftThumb!,
          if (rightThumb != null) rightThumb!,
        ],
      ),
    );
  }
}

enum DisplaySize {
  /// 0 - 599
  mobile(0, 599),

  /// 600 - 1023
  tablet(600, 1023),

  /// 1024 - 1920
  laptop(1024, 1919),

  /// 1K - 2K
  desktop(1920, 2047),

  /// 2K - 4K
  projector(2048, 4095),

  ///above 4K
  billboard(4096, 9999);

  final int min;

  final int max;

  const DisplaySize(this.min, this.max);
}

/// Media breakpoints extension for [MediaQueryData]
extension MediaBreakPointsExtension on MediaQueryData {
  /// Returns [DisplaySize] for current [MediaQueryData]
  DisplaySize get mediaBreakPoints {
    final size = this.size;
    final width = size.width;

    if (width >= DisplaySize.mobile.min && width <= DisplaySize.mobile.max) {
      return DisplaySize.mobile;
    } else if (width >= DisplaySize.tablet.min &&
        width <= DisplaySize.tablet.max) {
      return DisplaySize.tablet;
    } else if (width >= DisplaySize.laptop.min &&
        width <= DisplaySize.laptop.max) {
      return DisplaySize.laptop;
    } else if (width >= DisplaySize.desktop.min &&
        width <= DisplaySize.desktop.max) {
      return DisplaySize.desktop;
    } else if (width >= DisplaySize.projector.min &&
        width <= DisplaySize.projector.max) {
      return DisplaySize.projector;
    } else if (width >= DisplaySize.billboard.min &&
        width <= DisplaySize.billboard.max) {
      return DisplaySize.billboard;
    } else {
      return DisplaySize.mobile;
    }
  }
}

abstract class ResponsiveWidget extends StatelessWidget {
  final DisplaySize displaySize;

  const ResponsiveWidget({
    super.key,
    required this.displaySize,
  });

  @override
  Widget build(BuildContext context) {
    switch (displaySize) {
      case DisplaySize.mobile:
        return mobile(context);
      case DisplaySize.tablet:
        return tablet(context);
      case DisplaySize.laptop:
        return laptop(context);
      case DisplaySize.desktop:
        return desktop(context);
      case DisplaySize.projector:
        return projector(context);
      case DisplaySize.billboard:
        return billboard(context);
      default:
        return mobile(context);
    }
  }

  Widget mobile(BuildContext context);

  Widget tablet(BuildContext context);

  Widget laptop(BuildContext context);

  Widget desktop(BuildContext context);

  Widget projector(BuildContext context);

  Widget billboard(BuildContext context);
}

/// Layout configuration template of basic application
///
/// # Configuration
///
/// It is used to configure, constrain and position:
///    * [AppContainer],
///
/// # [AppContainer]
///    * [AppHeader]
///    * [AppBody],
///    * [AppFooter]
///
/// # [AppHeader]
///    * [MainMenuButton]
///
/// ## [AppBody]
///    * [ItemCard]
///    * [ItemDocument]
///
/// ## [AppFooter]
abstract class ResponsiveLayout extends ResponsiveWidget {
  final AppContainer appContainer;
  final AppHeader appHeader;
  final AppFooter appFooter;
  final AppBody appBody;
  final ItemCard itemCard;
  final ItemDocument itemDocument;

  const ResponsiveLayout({
    super.key,
    required super.displaySize,
    required this.appContainer,
    required this.appHeader,
    required this.appFooter,
    required this.appBody,
    required this.itemCard,
    required this.itemDocument,
  });
}

/// # Small devices of size class [DisplaySize.mobile]
///
/// ## How it used?
/// It is used to configure, constrain and position [AppBody], [MainMenuButton]
/// and [AppFooter] in Material [Scaffold]
///
/// ## Configurations
///
/// ### [AppContainer] configuration
/// [AppContainer] have discrete positioned floating [MainMenuButton] in
/// [Position.upperRight] or [Position.upperLeft] corner.
///
/// ### [AppHeader] contains discrete unobtrusive visible current state of the application
/// which is of interest for us in UX sense, like current Path, current User,
/// current Company, current Item (e.g. shopping card specialization [ItemHeaderSummary])... etc.
///
/// ### [AppFooter] configuration
/// [AppFooter] is reserved for [AppFooter.leftThumb] and [AppFooter.rightThumb]
/// by providing action Widget in left and right side of the footer
/// be that single action buttons or some List<[ContextMenuButtonItem]>
///
/// ### [AppBody] configuration
/// [AppBody] contains single main [ItemCard] which is positioned in the
/// center of the screen inside [SingleChildScrollView] and [Column] with
/// [Directionality] set to [TextDirection.ltr]
///
/// ### [ItemCard] configuration
/// [ItemCard] is positioned in the center of the screen and it is rendered in [ItemSummary] state.
///
/// #### [ItemDocument] configuration
/// [ItemDocument] is [ItemCard] full screen view and in small devices
/// ([AppBody.itemCardinality] == 1) it is implemented as scrollable list of [ItemCardField]s.
class SmallDeviceLayout extends ResponsiveLayout {
  const SmallDeviceLayout({
    super.key,
    required super.displaySize,
    required super.appContainer,
    required super.appHeader,
    required super.appFooter,
    required super.appBody,
    required super.itemCard,
    required super.itemDocument,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appHeader.appBar,
      body: appContainer.build(context),
      floatingActionButton: appContainer.mainMenuButton,
      floatingActionButtonLocation: appContainer.mainMenuButtonPosition,
      bottomNavigationBar: appFooter.build(context),
    );
  }

  @override
  Widget billboard(BuildContext context) {
    // TODO: implement billboard
    throw UnimplementedError();
  }

  @override
  Widget desktop(BuildContext context) {
    // TODO: implement desktop
    throw UnimplementedError();
  }

  @override
  Widget laptop(BuildContext context) {
    // TODO: implement laptop
    throw UnimplementedError();
  }

  @override
  Widget mobile(BuildContext context) {
    // TODO: implement mobile
    throw UnimplementedError();
  }

  @override
  Widget projector(BuildContext context) {
    // TODO: implement projector
    throw UnimplementedError();
  }

  @override
  Widget tablet(BuildContext context) {
    // TODO: implement tablet
    throw UnimplementedError();
  }
}

enum LayoutType {
  icon,
  label,
  input,
  button,
  container,
  split,
  body,
  itemCard,
  itemCardField,
  itemDocument,
  itemDocumentField
}

/// Material 3 Floating Action Button
class MainMenuButton extends StatelessWidget {
  final Widget? icon;
  final Widget? label;
  final void Function()? onPressed;

  final Position position;
  final LayoutConstraints constraints;

  const MainMenuButton({
    super.key,
    this.icon,
    this.label,
    this.position = Position.upperRight,
    this.constraints = const LayoutConstraints.icon(
      parentWidth: 100.0,
      parentHeight: 10.0,
    ),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: constraints.width,
      height: constraints.height,
      child: FloatingActionButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon ?? const SizedBox(),
            label ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class LayoutConstraints {
  final double? minWidth;
  final double? maxWidth;

  final double? minHeight;
  final double? maxHeight;

  const LayoutConstraints({
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
  });

  get width {
    if (maxWidth != null && minWidth != null) {
      return maxWidth! + (maxWidth! - minWidth!) / 2;
    } else if (maxWidth != null) {
      return maxWidth!;
    } else if (minWidth != null) {
      return minWidth!;
    } else {
      // Icon size, minimal element size
      return 40;
    }
  }

  get height {
    if (maxHeight != null && minHeight != null) {
      return maxHeight! + (maxHeight! - minHeight!) / 2;
    } else if (maxHeight != null) {
      return maxHeight!;
    } else if (minHeight != null) {
      return minHeight!;
    } else {
      // Icon size, minimal element size
      return 40;
    }
  }

  const LayoutConstraints.icon({parentWidth, parentHeight})
      : this(
            minWidth: parentWidth + 40,
            maxWidth: parentWidth + 40,
            minHeight: parentHeight + 40,
            maxHeight: parentHeight + 40);

  get size {
    return Size(width, height);
  }

  get rect {
    return Rect.fromLTWH(0, 0, width, height);
  }

  get boxConstraints {
    return BoxConstraints(
      minWidth: minWidth ?? width,
      maxWidth: maxWidth ?? width,
      minHeight: minHeight ?? height,
      maxHeight: maxHeight ?? height,
    );
  }
}

class AppHeader {
  final AppBar appBar;

  const AppHeader({
    required this.appBar,
  });
}

class AppBody {
  final int itemCardinality = 1;
}

class ItemHeaderSummary {
  final String label;
  final String? subtitle;
  final String? description;
  final String? badgeValue;

  const ItemHeaderSummary({
    required this.label,
    this.subtitle,
    this.description,
    this.badgeValue,
  });
}

/// Media breakpoints mapped

class ItemDocument {}

class AppContainer {
  final Widget mainMenuButton;

  final FloatingActionButtonLocation? mainMenuButtonPosition;

  const AppContainer({
    required this.mainMenuButton,
    required this.mainMenuButtonPosition,
  });

  build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Text('$index');
          },
        ),
      ),
    ]);
  }
}

class ItemCard {}

class ItemCardField {}

class ItemSummary {}
