import 'package:flutter/material.dart';

/// # Default Layout configuration for mobile devices up to 500px and [DisplaySize] of up to [DisplaySize.small] (5.5 inches)
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
class SmallDeviceLayout {
  final DisplaySize displaySize;
  final AppContainer appContainer;
  final AppHeader appHeader;
  final AppFooter appFooter;
  final AppBody appBody;
  final ItemCard itemCard;
  final ItemDocument itemDocument;

  const SmallDeviceLayout({
    required this.displaySize,
    required this.appContainer,
    required this.appHeader,
    required this.appFooter,
    required this.appBody,
    required this.itemCard,
    required this.itemDocument,
  });
}

enum DisplaySize { small, medium, large }

enum DeviceType { iot, mobile, tablet, laptop, desktop, projector }

enum DefaultIoTWidth {
  icon(45),
  label(45),
  input(100),
  button(100),
  container(400),
  split(400),
  body(400),
  itemCard(375),
  itemCardField(150),
  itemDocument(400),
  itemDocumentField(150);

  final double value;
  final DeviceType deviceType = DeviceType.iot;

  const DefaultIoTWidth(
    this.value,
  );
}

enum DefaultMobileWidth {
  icon(45),
  label(45),
  input(100),
  button(100),
  container(400),
  split(400),
  body(400),
  itemCard(375),
  itemCardField(150),
  itemDocument(400),
  itemDocumentField(150);

  final double value;
  final DeviceType deviceType = DeviceType.mobile;

  const DefaultMobileWidth(this.value);
}

enum DefaultTabletWidth {
  icon(45),
  label(45),
  input(100),
  button(100),
  container(400),
  split(400),
  body(400),
  itemCard(375),
  itemCardField(150),
  itemDocument(400),
  itemDocumentField(150);

  final double value;

  const DefaultTabletWidth(this.value);
}

enum Direction { horizontal, vertical }

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

enum Position { upperLeft, upperRight, lowerLeft, lowerRight }

class AppHeader {}

class AppBody {
  final int itemCardinality = 1;
}

class AppFooter {
  Widget? leftThumb;
  Widget? rightThumb;
}

class ItemCard {}

class ItemCardField {}

class ItemSummary {}

/// Data for adaptive Material 3 condensed info widget with notification Badge on top right corner
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

class ItemDocument {}

class AppContainer {}

/// Media breakpoints mapped
enum MediaBreakPoints {
  
}
