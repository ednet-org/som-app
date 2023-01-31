import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:som/domain/model/customer_management/roles.dart';

part 'application.g.dart';

class Application = _Application with _$Application;

abstract class _Application with Store {
  @observable
  double applicationWidth = 600;

  @observable
  double buttonWidth = 200;

  @observable
  double textScaleFactor = 1.0;

  @action
  void setTextScaleFactor(double value) => textScaleFactor = value;

  @observable
  bool isDarkModeOn = true;

  @observable
  String selectedLanguage = 'de';

  @observable
  var selectedDrawerItem = -1;

  @action
  void toggleDarkMode() {
    isDarkModeOn = !isDarkModeOn;
  }

  @action
  void setLanguage(String aLanguage) => selectedLanguage = aLanguage;

  @action
  void setDrawerItemIndex(int aIndex) {
    selectedDrawerItem = aIndex;
  }

  @computed
  get isAuthenticated => authorization != null;

  @action
  logout() {
    authorization = null;
  }

  @action
  login(Authorization aAuthorization) async {
    authorization = aAuthorization;
  }

  @observable
  Authorization? authorization;

  @observable
  BoxConstraints? boxConstraints;

  @computed
  CurrentLayoutAndUIConstraints get layout {
    return boxConstraints == null
        ? CurrentLayoutAndUIConstraints.fromBoxConstraints(
            const BoxConstraints())
        : CurrentLayoutAndUIConstraints.fromBoxConstraints(boxConstraints!);
  }
}

class Authorization {
  Roles? companyRole;
  UserRoles? userRole;
  String token;
  String refreshToken;
  var user;

  Authorization({
    this.companyRole,
    this.userRole,
    this.user,
    required this.token,
    required this.refreshToken,
  });
}

enum UserRoles {
  employee,
  admin,
}

enum UIDensity {
  /// 0.0 - 1.0 density, low density, e.g. LDPI
  upToLDPI(0.0, 1.0),

  /// 1.0 - 1.5 density, low density, e.g. MDPI
  upToMDPI(1.0, 1.5),

  /// 1.5 - 2.0 density, medium density, e.g. HDPI
  upToHDPI(1.5, 2.0),

  /// 2.0 - 3.0 density, medium density, e.g. XHDPI
  upToXHDPI(2.0, 3.0),

  /// 3.0 - 4.0 density, high density, e.g. XXHDPI
  upToXXHDPI(3.0, 4.0),

  /// 4.0 - 5.0 density, high density, e.g. XXXHDPI
  upToXXXHDPI(4.0, 5.0);

  const UIDensity(this.min, this.max);

  final double min;
  final double max;
}

enum DisplayResolution {
  /// 0.0 - 480.0 pixels, low resolution, e.g. 240p
  upTo144p(0.0, 144.0),

  /// 144.0 - 240.0 pixels, low resolution, e.g. 240p
  upTo240p(144.0, 240.0),

  /// 240.0 - 360.0 pixels, low resolution, e.g. 360p
  upTo360p(240.0, 360.0),

  /// 360.0 - 480.0 pixels, low resolution, e.g. 480p
  upTo480p(360.0, 480.0),

  /// 480.0 - 720.0 pixels, medium resolution, e.g. 720p
  upTo720p(480.0, 720.0),

  /// 720.0 - 1080.0 pixels, medium resolution, e.g. 1080p
  upTo1080p(720.0, 1080.0),

  /// 1080.0 - 1920.0 pixels, high resolution, e.g. 2K
  upTo2K(1080.0, 1920.0),

  /// 1920.0 - 2560.0 pixels, high resolution, e.g. 3K
  upTo3K(1920.0, 2560.0),

  /// 2560.0 - 3840.0 pixels, high resolution, e.g. 4K
  upTo4K(2560.0, 3840.0),

  /// 3840.0 - 7680.0 pixels, high resolution, e.g. 8K
  upTo8K(3840.0, 7680.0),

  /// 7680.0 - 15360.0 pixels, high resolution, e.g. 16K
  upTo16K(7680.0, 15360.0);

  const DisplayResolution(this.min, this.max);

  final double min;
  final double max;
}

/// Classification based on actual screen size in inches to be inhered from enviroment available data of running Flutter context
enum PhysicalViewPortSize {
  /// 0.0 - 5.0 inches, IoT displays various capabilities, mono, color, touch,
  /// no touch, etc.
  micro(0.0, 5.0),

  /// 4.0 - 7.0 inches, small mobile phones, small tablets
  /// (e.g. 7" Kindle Fire)
  mini(4.0, 7.0),

  /// 7.0 - 12.0 inches, large mobile phones, small tablets
  /// (e.g. 9.7" iPad)
  small(7.0, 12.0),

  /// 12.0 - 17.0 inches, small laptops, large tablets
  /// (e.g. 12.9" iPad Pro)
  medium(12.0, 17.0),

  /// 13.0 - 17.0 inches, large laptops, small desktops
  /// (e.g. 16" MacBook Pro)
  large(17.0, 28.0),

  /// 17.0 - 22.0 inches, large desktops, small TVs
  /// (e.g. 21.5" iMac)
  xlarge(28.0, 40.0),

  /// 36.0 - 60.0 inches, medium TVs, projectors
  /// (e.g. 40" Samsung TV)
  smallProjector(40.0, 60.0);

  const PhysicalViewPortSize(this.min, this.max);

  final double min;
  final double max;
}

/// Based on BoxConstraints we inhere or use best approximation of:
///  - [PhysicalViewPortSize],
///  - [DeviceType],
///  - [DisplayResolution],
///  - [UIDensity] and
///  - [UIScale] and provide a Layout object to the UI
///  to know max and min constraints for single UI patterns like:
///  - how much splits main container should support for parallel display of full fledged Documents (up to 1080p pro full document)
///  - what shall be general app density expressed in common paddings, margins, font sizes, icon sizes, etc.
///  - what shall be general app scale expressed as static scale factor, most basic crude scale for UI's which are not responsive in true sense.
///  - what shall be general app layout expressed as adaptive layout, do we prefer columns or rows, do we prefer to display 2 or 3 columns, etc.
/// Display host, resolution, density and adaptive layout
class CurrentLayoutAndUIConstraints {
  final PhysicalViewPortSize physicalViewPortSize;
  final DeviceType deviceType;
  final DisplayResolution displayResolution;
  final UIDensity uiDensity;

  const CurrentLayoutAndUIConstraints(
      {required this.physicalViewPortSize,
      required this.deviceType,
      required this.displayResolution,
      required this.uiDensity});

  factory CurrentLayoutAndUIConstraints.fromBoxConstraints(
      BoxConstraints constraints) {
    var physicalViewPortSize = PhysicalViewPortSize.small;
    var deviceType = DeviceType.mobile;
    var displayResolution = DisplayResolution.upTo1080p;
    var uiDensity = UIDensity.upToXXHDPI;

    /// How to get from Flutter environment physicalViewPortSize?

    // deviceType
    if (constraints.maxWidth < 500.0) {
      deviceType = DeviceType.mobile;
    } else if (constraints.maxWidth < 1000.0) {
      deviceType = DeviceType.tablet;
    } else if (constraints.maxWidth < 1500.0) {
      deviceType = DeviceType.laptop;
    } else {
      deviceType = DeviceType.desktop;
    }

    // displayResolution
    if (constraints.maxWidth < DisplayResolution.upTo240p.max) {
      displayResolution = DisplayResolution.upTo240p;
    } else if (constraints.maxWidth < DisplayResolution.upTo360p.max) {
      displayResolution = DisplayResolution.upTo360p;
    } else if (constraints.maxWidth < DisplayResolution.upTo480p.max) {
      displayResolution = DisplayResolution.upTo480p;
    } else if (constraints.maxWidth < DisplayResolution.upTo720p.max) {
      displayResolution = DisplayResolution.upTo720p;
    } else if (constraints.maxWidth < DisplayResolution.upTo1080p.max) {
      displayResolution = DisplayResolution.upTo1080p;
    } else if (constraints.maxWidth < DisplayResolution.upTo2K.max) {
      displayResolution = DisplayResolution.upTo2K;
    } else if (constraints.maxWidth < DisplayResolution.upTo4K.max) {
      displayResolution = DisplayResolution.upTo4K;
    } else if (constraints.maxWidth < DisplayResolution.upTo8K.max) {
      displayResolution = DisplayResolution.upTo8K;
    } else {
      displayResolution = DisplayResolution.upTo8K;
    }

    // uiDensity
    if (constraints.maxWidth < UIDensity.upToLDPI.max) {
      uiDensity = UIDensity.upToLDPI;
    } else if (constraints.maxWidth < UIDensity.upToMDPI.max) {
      uiDensity = UIDensity.upToMDPI;
    } else if (constraints.maxWidth < UIDensity.upToHDPI.max) {
      uiDensity = UIDensity.upToHDPI;
    } else if (constraints.maxWidth < UIDensity.upToXHDPI.max) {
      uiDensity = UIDensity.upToXHDPI;
    } else if (constraints.maxWidth < UIDensity.upToXXHDPI.max) {
      uiDensity = UIDensity.upToXXHDPI;
    } else {
      uiDensity = UIDensity.upToXXXHDPI;
    }

    return CurrentLayoutAndUIConstraints(
      physicalViewPortSize: physicalViewPortSize,
      deviceType: deviceType,
      displayResolution: displayResolution,
      uiDensity: uiDensity,
    );
  }

  /// Based on [CurrentLayoutAndUIConstraints] we provide a Layout object to the UI
  /// to know max and min constraints for single UI patterns like:
  bool is4K() {
    return displayResolution == DisplayResolution.upTo4K;
  }

  Layout get constraints {
    return Layout(
      physicalViewPortSize: physicalViewPortSize,
      deviceType: deviceType,
      displayResolution: displayResolution,
      uiDensity: uiDensity,
    );
  }
}

class Layout {
  final ContainerLayout containerLayout;

  Layout({
    required PhysicalViewPortSize physicalViewPortSize,
    required DeviceType deviceType,
    required DisplayResolution displayResolution,
    required UIDensity uiDensity,
  }) : containerLayout = ContainerLayout(
          CurrentLayoutAndUIConstraints(
            physicalViewPortSize: physicalViewPortSize,
            deviceType: deviceType,
            displayResolution: displayResolution,
            uiDensity: uiDensity,
          ),
        );
}

class ContainerLayout {
  final CurrentLayoutAndUIConstraints currentLayoutAndUIConstraints;
  final double minWidth;
  final double maxWidth;

  final double minHeight;
  final double maxHeight;

  /// default constructor for absent constraints, based on mobile defaults
  ContainerLayout(this.currentLayoutAndUIConstraints)
      : minWidth = currentLayoutAndUIConstraints.displayResolution.min,
        maxWidth = currentLayoutAndUIConstraints.displayResolution.max,
        minHeight = currentLayoutAndUIConstraints.displayResolution.min,
        maxHeight = currentLayoutAndUIConstraints.physicalViewPortSize.max;
}

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
