import 'package:som/template_storage/integrations/screens/MonthlySale1Screen.dart';
import 'package:som/template_storage/integrations/screens/Shimmer/SHomePage.dart';
import 'package:som/template_storage/main/model/AppModel.dart';
import 'package:som/template_storage/widgets/animationAndMotionWidgets/AMAnimatedBuilderScreen.dart';
import 'package:som/template_storage/widgets/animationAndMotionWidgets/AMAnimatedContainerScreen.dart';
import 'package:som/template_storage/widgets/animationAndMotionWidgets/AMAnimatedCrossFadeScreen.dart';
import 'package:som/template_storage/widgets/animationAndMotionWidgets/AMAnimatedOpacityScreen.dart';
import 'package:som/template_storage/widgets/animationAndMotionWidgets/AMAnimatedPositionedScreen.dart';
import 'package:som/template_storage/widgets/animationAndMotionWidgets/AMAnimatedSizeScreen.dart';
import 'package:som/template_storage/widgets/animationAndMotionWidgets/AMFadeTransitionScreen.dart';
import 'package:som/template_storage/widgets/animationAndMotionWidgets/AMHeroScreen.dart';
import 'package:som/template_storage/widgets/animationAndMotionWidgets/AMScaleTransitionScreen.dart';
import 'package:som/template_storage/widgets/cupertinoWidgets/CWActionSheetScreen.dart';
import 'package:som/template_storage/widgets/cupertinoWidgets/CWActivityIndicatorScreen.dart';
import 'package:som/template_storage/widgets/cupertinoWidgets/CWAlertDialogScreen.dart';
import 'package:som/template_storage/widgets/cupertinoWidgets/CWButtonScreen.dart';
import 'package:som/template_storage/widgets/cupertinoWidgets/CWContextMenuScreen.dart';
import 'package:som/template_storage/widgets/cupertinoWidgets/CWDialogScreen.dart';
import 'package:som/template_storage/widgets/cupertinoWidgets/CWNavigationBarScreen.dart';
import 'package:som/template_storage/widgets/cupertinoWidgets/CWPickerScreen.dart';
import 'package:som/template_storage/widgets/cupertinoWidgets/CWSegmentedControlScreen.dart';
import 'package:som/template_storage/widgets/cupertinoWidgets/CWSliderScreen.dart';
import 'package:som/template_storage/widgets/cupertinoWidgets/CWSlidingSegmentedControlScreen.dart';
import 'package:som/template_storage/widgets/cupertinoWidgets/CWSwitchScreen.dart';
import 'package:som/template_storage/widgets/cupertinoWidgets/CWTabBarWidgets/CWTabBarScreen1.dart';
import 'package:som/template_storage/widgets/cupertinoWidgets/CWTabBarWidgets/CWTabBarScreen2.dart';
import 'package:som/template_storage/widgets/cupertinoWidgets/CWTabBarWidgets/CWTabBarScreen3.dart';
import 'package:som/template_storage/widgets/cupertinoWidgets/CWTextFieldScreen.dart';
import 'package:som/template_storage/widgets/interactionModelWidgets/IMGestureDetectorScreen.dart';
import 'package:som/template_storage/widgets/interactionModelWidgets/imDismissibleWidgets/IMDismissibleScreen1.dart';
import 'package:som/template_storage/widgets/interactionModelWidgets/imDismissibleWidgets/IMDismissibleScreen2.dart';
import 'package:som/template_storage/widgets/interactionModelWidgets/imDraggableWidgets/IMDraggableScreen1.dart';
import 'package:som/template_storage/widgets/interactionModelWidgets/imDraggableWidgets/IMDraggableScreen2.dart';
import 'package:som/template_storage/widgets/interactionModelWidgets/imLongPressDraggableWidgets/IMLongPressDraggableScreen1.dart';
import 'package:som/template_storage/widgets/interactionModelWidgets/imLongPressDraggableWidgets/IMLongPressDraggableScreen2.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwAppStrucutreWidgets/MWAppBarScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwAppStrucutreWidgets/MWDrawerWidgets/MWDrawerScreen1.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwAppStrucutreWidgets/MWDrawerWidgets/MWDrawerScreen2.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwAppStrucutreWidgets/MWSliverAppBarWidgets/MWSliverAppBarScreen1.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwAppStrucutreWidgets/MWSliverAppBarWidgets/MWSliverAppBarScreen2.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwAppStrucutreWidgets/MWTabBarWidgets/MWTabBarScreen1.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwAppStrucutreWidgets/MWTabBarWidgets/MWTabBarScreen2.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwAppStrucutreWidgets/MWTabBarWidgets/MWTabBarScreen3.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwAppStrucutreWidgets/MWTabBarWidgets/MWTabBarScreen4.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwAppStrucutreWidgets/mwBottomNavigationWidgets/MWBottomNavigationScreen1.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwAppStrucutreWidgets/mwBottomNavigationWidgets/MWBottomNavigationScreen2.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwAppStrucutreWidgets/mwBottomNavigationWidgets/MWBottomNavigationScreen3.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwButtonWidgets/MWDropDownButtonScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwButtonWidgets/MWFlatButtonScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwButtonWidgets/MWFloatingActionButtonScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwButtonWidgets/MWIconButtonScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwButtonWidgets/MWMaterialButtonScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwButtonWidgets/MWOutlineButtonScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwButtonWidgets/MWPopupMenuButtonScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwButtonWidgets/MWRaisedButtonScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwDialogAlertPanelWidgets/MWAlertDialogScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwDialogAlertPanelWidgets/MWBottomSheetScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwDialogAlertPanelWidgets/MWExpansionPanelScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwDialogAlertPanelWidgets/MWSimpleDialogScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwDialogAlertPanelWidgets/MWSnackBarScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwDialogAlertPanelWidgets/MWToastScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInformationDisplayWidgets/MWCardScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInformationDisplayWidgets/MWChipScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInformationDisplayWidgets/MWDataTableScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInformationDisplayWidgets/MWGridViewScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInformationDisplayWidgets/MWIconScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInformationDisplayWidgets/MWImageScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInformationDisplayWidgets/MWListViewWidget/MWListViewScreen1.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInformationDisplayWidgets/MWListViewWidget/MWListViewScreen2.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInformationDisplayWidgets/MWListViewWidget/MWListViewScreen3.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInformationDisplayWidgets/MWListViewWidget/MWListViewScreen4.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInformationDisplayWidgets/MWListViewWidget/MWListViewScreen5.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInformationDisplayWidgets/MWProgressBarScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInformationDisplayWidgets/MWRichTextScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInformationDisplayWidgets/MWTooltipScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInputSelectionWidgets/MWCheckboxScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInputSelectionWidgets/MWDatetimePickerScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInputSelectionWidgets/MWRadioScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInputSelectionWidgets/MWSliderScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInputSelectionWidgets/MWSwitchScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInputSelectionWidgets/MWTextFieldWidgets/MWTextFieldScreen1.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInputSelectionWidgets/MWTextFieldWidgets/MWTextFieldScreen2.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwInputSelectionWidgets/MWTextFormFieldScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwLayoutWidgtes/MWDividerScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwLayoutWidgtes/MWListTileScreen.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwLayoutWidgtes/MWStepperWidget/MWStepperScreen1.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwLayoutWidgtes/MWStepperWidget/MWStepperScreen2.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwLayoutWidgtes/MWStepperWidget/MWStepperScreen3.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwLayoutWidgtes/MWStepperWidget/MWStepperScreen4.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwLayoutWidgtes/MWUserAccountDrawerHeaderWidget/MWUserAccountDrawerHeaderScreen1.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwLayoutWidgtes/MWUserAccountDrawerHeaderWidget/MWUserAccountDrawerHeaderScreen2.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwLayoutWidgtes/MWUserAccountDrawerHeaderWidget/MWUserAccountDrawerHeaderScreen3.dart';
import 'package:som/template_storage/widgets/materialWidgets/mwLayoutWidgtes/MWUserAccountDrawerHeaderWidget/MWUserAccountDrawerHeaderScreen4.dart';
import 'package:som/template_storage/widgets/otherWidgets/InteractiveViewerScreen.dart';
import 'package:som/template_storage/widgets/otherWidgets/OpenContainerTransformScreen.dart';
import 'package:som/template_storage/widgets/paintingAndEffectWidgets/PEBackdropFilterScreen.dart';
import 'package:som/template_storage/widgets/paintingAndEffectWidgets/PEClipOvalScreen.dart';
import 'package:som/template_storage/widgets/paintingAndEffectWidgets/PEOpacityScreen.dart';
import 'package:som/template_storage/widgets/paintingAndEffectWidgets/PERotatedBoxScreen.dart';
import 'package:som/template_storage/widgets/paintingAndEffectWidgets/PETransformScreen.dart';

Future<AppTheme> getAllAppsAndThemes() async {
  AppTheme appTheme = AppTheme();

  appTheme.dashboard = getDashboards();
  appTheme.widgets = getWidgets();
  appTheme.template_storage = gettemplate_storage();
  appTheme.integrations = getIntegrations();
  appTheme.webApps = getWebApps();

  return appTheme;
}

//region Dashboard
ThemeConfiguration getDashboards() {
  ThemeConfiguration theme = ThemeConfiguration(
      sub_kits: [],
      name: 'Dashboard',
      title_name: 'Dashboard Screens',
      show_cover: true,
      type: '');
  List<ThemeConfiguration> list = [];
  theme.sub_kits!.addAll(list);
  return theme;
}

// endregion
//region Widgets
ThemeConfiguration getWidgets() {
  List<ThemeConfiguration> list = [];

  list.add(ThemeConfiguration(
      name: 'Material Widgets',
      type: '',
      show_cover: false,
      sub_kits: getMaterialWidgets(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Cupertino Widgets',
      type: '',
      show_cover: false,
      sub_kits: getCupertinoWidgets(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Painting and effect Widgets',
      type: '',
      show_cover: false,
      sub_kits: getPaintingAndEffectWidgets(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Animation and motion Widgets',
      type: '',
      show_cover: false,
      sub_kits: getAnimationAndMotionWidgets(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Interaction Model Widgets',
      type: '',
      show_cover: false,
      sub_kits: getInteractionModelWidgets(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Other Widgets',
      type: '',
      show_cover: false,
      sub_kits: getOtherWidgets(),
      darkThemeSupported: true));

  return ThemeConfiguration(
      name: 'Widgets',
      title_name: 'Widgets',
      type: '',
      show_cover: false,
      sub_kits: list);
}
//endregion
//region Material

List<ThemeConfiguration> getMaterialWidgets() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'App Structure',
      show_cover: false,
      type: '',
      sub_kits: getAppStructure(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Buttons',
      show_cover: false,
      type: '',
      sub_kits: getButtons(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Input & Selection',
      show_cover: false,
      type: '',
      sub_kits: getInputSelection(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Dialogs, Alerts & Panels',
      show_cover: false,
      type: '',
      sub_kits: getDialogs(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Information Display',
      show_cover: false,
      type: '',
      sub_kits: getInformationDisplay(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Layout',
      show_cover: false,
      type: '',
      sub_kits: getLayout(),
      darkThemeSupported: true));
  return list;
}

//region subMaterialWidgets
List<ThemeConfiguration> getAppStructure() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'AppBar',
      show_cover: false,
      type: '',
      widget: MWAppBarScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Bottom Navigation Bar',
      show_cover: false,
      type: '',
      sub_kits: getBottomNavigationBar(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Drawer',
      show_cover: false,
      type: '',
      sub_kits: getDrawer(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'SliverAppBar',
      show_cover: false,
      type: '',
      sub_kits: getSliverAppBar(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'TabBar',
      show_cover: false,
      type: '',
      sub_kits: getTabBar(),
      darkThemeSupported: true));
  return list;
}

List<ThemeConfiguration> getBottomNavigationBar() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'With Icon and Label',
      show_cover: false,
      type: '',
      widget: MWBottomNavigationScreen1(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'With Custom Image',
      show_cover: false,
      type: '',
      widget: MWBottomNavigationScreen2(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'With Shifting Label',
      show_cover: false,
      type: '',
      widget: MWBottomNavigationScreen3(),
      darkThemeSupported: true));
  return list;
}

List<ThemeConfiguration> getDrawer() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'With Multiple Account Selection ',
      show_cover: false,
      type: '',
      widget: MWDrawerScreen1(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'With Custom Shape ',
      show_cover: false,
      type: '',
      widget: MWDrawerScreen2(),
      darkThemeSupported: true));
  return list;
}

List<ThemeConfiguration> getSliverAppBar() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Sliver AppBar with ListView',
      show_cover: false,
      type: '',
      widget: MWSliverAppBarScreen1(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Parallax Sliver AppBar',
      show_cover: false,
      type: '',
      widget: MWSliverAppBarScreen2(),
      darkThemeSupported: true));

  return list;
}

List<ThemeConfiguration> getTabBar() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Simple TabBar',
      show_cover: false,
      type: '',
      widget: MWTabBarScreen1(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'TabBar with Title and Icon',
      show_cover: false,
      type: '',
      widget: MWTabBarScreen2(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'TabBar with Icon',
      show_cover: false,
      type: '',
      widget: MWTabBarScreen3(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Scrollable Tab',
      show_cover: false,
      type: '',
      widget: MWTabBarScreen4(),
      darkThemeSupported: true));
  return list;
}

List<ThemeConfiguration> getButtons() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'DropDownButton',
      show_cover: false,
      type: '',
      widget: MWDropDownButtonScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'MaterialButton',
      show_cover: false,
      type: '',
      widget: MWMaterialButtonScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'FlatButton',
      show_cover: false,
      type: '',
      widget: MWFlatButtonScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'FloatingActionButton',
      show_cover: false,
      type: '',
      widget: MWFloatingActionButtonScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'IconButton',
      show_cover: false,
      type: '',
      widget: MWIconButtonScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'OutlineButton',
      show_cover: false,
      type: '',
      widget: MWOutlineButtonScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'PopupMenuButton',
      show_cover: false,
      type: '',
      widget: MWPopupMenuButtonScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'RaisedButton',
      show_cover: false,
      type: '',
      widget: MWRaisedButtonScreen(),
      darkThemeSupported: true));
  return list;
}

List<ThemeConfiguration> getInputSelection() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Checkbox',
      show_cover: false,
      type: '',
      widget: MWCheckboxScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Datetime Picker',
      show_cover: false,
      type: '',
      widget: MWDatetimePickerScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Radio',
      show_cover: false,
      type: '',
      widget: MWRadioScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Slider',
      show_cover: false,
      type: '',
      widget: MWSliderScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Switch',
      show_cover: false,
      type: '',
      widget: MWSwitchScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'TextField',
      show_cover: false,
      type: '',
      sub_kits: getTextField(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'TextFormField',
      show_cover: false,
      type: '',
      widget: MWTextFormFieldScreen(),
      darkThemeSupported: true));
  return list;
}

List<ThemeConfiguration> getTextField() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Simple TextField ',
      show_cover: false,
      type: '',
      widget: MWTextFieldScreen1(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Rounded Border TextField ',
      show_cover: false,
      type: '',
      widget: MWTextFieldScreen2(),
      darkThemeSupported: true));
  return list;
}

List<ThemeConfiguration> getDialogs() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'AlertDialog',
      show_cover: false,
      type: '',
      widget: MWAlertDialogScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'BottomSheet',
      show_cover: false,
      type: '',
      widget: MWBottomSheetScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'ExpansionPanel',
      show_cover: false,
      type: '',
      widget: MWExpansionPanelScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Simple Dialog',
      show_cover: false,
      type: '',
      widget: MWSimpleDialogScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'SnackBar',
      show_cover: false,
      type: '',
      widget: MWSnackBarScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Toast',
      show_cover: false,
      type: '',
      widget: MWToastScreen(),
      darkThemeSupported: true));
  return list;
}

List<ThemeConfiguration> getInformationDisplay() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Card',
      show_cover: false,
      type: '',
      widget: MWCardScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Chip',
      show_cover: false,
      type: '',
      widget: MWChipScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Progress Bar',
      show_cover: false,
      type: '',
      widget: MWProgressBarScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Data Table',
      show_cover: false,
      type: '',
      widget: MWDataTableScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Grid View',
      show_cover: false,
      type: '',
      widget: MWGridViewScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'List View',
      show_cover: false,
      type: '',
      sub_kits: getListView(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Rich Text',
      show_cover: false,
      type: '',
      widget: MWRichTextScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Icon',
      show_cover: false,
      type: '',
      widget: MWIconScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Image (assets,Network,Placeholders)',
      show_cover: false,
      type: '',
      widget: MWImageScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Tooltip',
      show_cover: false,
      type: '',
      widget: MWTooltipScreen(),
      darkThemeSupported: true));
  return list;
}

List<ThemeConfiguration> getListView() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Simple List View',
      show_cover: false,
      type: '',
      widget: MWListViewScreen1(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'List Wheel ScrollView',
      show_cover: false,
      type: '',
      widget: MWListViewScreen2(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Horizontal List View',
      show_cover: false,
      type: '',
      widget: MWListViewScreen3(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Bouncing Scroll List View',
      show_cover: false,
      type: '',
      widget: MWListViewScreen4(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Reorderable List View',
      show_cover: false,
      type: '',
      widget: MWListViewScreen5(),
      darkThemeSupported: true));
  return list;
}

List<ThemeConfiguration> getLayout() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Divider',
      show_cover: false,
      type: '',
      widget: MWDividerScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'ListTile',
      show_cover: false,
      type: '',
      widget: MWListTileScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Stepper',
      show_cover: false,
      type: '',
      sub_kits: getStepper(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'User Accounts Drawer Header',
      show_cover: false,
      type: '',
      sub_kits: getUserAccountsDrawerHeader(),
      darkThemeSupported: true));
  return list;
}

List<ThemeConfiguration> getStepper() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Horizontal Stepper with Form',
      show_cover: false,
      type: '',
      widget: MWStepperScreen1(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Vertical Stepper',
      show_cover: false,
      type: '',
      widget: MWStepperScreen2(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Vertical Stepper with Form',
      show_cover: false,
      type: '',
      widget: MWStepperScreen3(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Simple Horizontal Stepper',
      show_cover: false,
      type: '',
      widget: MWStepperScreen4(),
      darkThemeSupported: true));
  return list;
}

List<ThemeConfiguration> getUserAccountsDrawerHeader() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'With Custom UI',
      show_cover: false,
      type: '',
      widget: MWUserAccountDrawerHeaderScreen1(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Simple User Account Drawer Header',
      show_cover: false,
      type: '',
      widget: MWUserAccountDrawerHeaderScreen2(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'With Multiple Account Selection',
      show_cover: false,
      type: '',
      widget: MWUserAccountDrawerHeaderScreen3(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'With Custom Background',
      show_cover: false,
      type: '',
      widget: MWUserAccountDrawerHeaderScreen4(),
      darkThemeSupported: true));
  return list;
}
//endregion

//endregion
//region Cupertino
List<ThemeConfiguration> getCupertinoWidgets() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Cupertino Action Sheet',
      show_cover: false,
      type: '',
      widget: CWActionSheetScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Cupertino Activity Indicator',
      show_cover: false,
      type: '',
      widget: CWActivityIndicatorScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Cupertino Alert Dialog',
      show_cover: false,
      type: '',
      widget: CWAlertDialogScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Cupertino Button',
      show_cover: false,
      type: '',
      widget: CWButtonScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Cupertino Context Menu',
      show_cover: false,
      type: '',
      widget: CWContextMenuScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Cupertino Dialog',
      show_cover: false,
      type: '',
      widget: CWDialogScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Cupertino Navigation Bar',
      show_cover: false,
      type: '',
      widget: CWNavigationBarScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Cupertino Picker',
      show_cover: false,
      type: '',
      widget: CWPickerScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Cupertino Segmented Control',
      show_cover: false,
      type: '',
      widget: CWSegmentedControlScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Cupertino Slider',
      show_cover: false,
      type: '',
      widget: CWSliderScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Cupertino Sliding Segmented Control',
      show_cover: false,
      type: '',
      widget: CWSlidingSegmentedControlScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Cupertino Switch',
      show_cover: false,
      type: '',
      widget: CWSwitchScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Cupertino TabBar',
      show_cover: false,
      type: '',
      sub_kits: getCupertinoTabBar(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Cupertino TextField',
      show_cover: false,
      type: '',
      widget: CWTextFieldScreen(),
      darkThemeSupported: true));
  return list;
}

List<ThemeConfiguration> getCupertinoTabBar() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Tab Bar with Icon ',
      show_cover: false,
      type: '',
      widget: CWTabBarScreen1(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Tab Bar with Icon and Label ',
      show_cover: false,
      type: '',
      widget: CWTabBarScreen2(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Tab Bar with Custom Image ',
      show_cover: false,
      type: '',
      widget: CWTabBarScreen3(),
      darkThemeSupported: true));
  return list;
}

//endregion
//region PaintingAndEffectWidgets
List<ThemeConfiguration> getPaintingAndEffectWidgets() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Backdrop Filter',
      show_cover: false,
      type: '',
      widget: PEBackdropFilterScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Clip Widget Demo',
      show_cover: false,
      type: '',
      widget: PEClipOvalScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Opacity',
      show_cover: false,
      type: '',
      widget: PEOpacityScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Rotated Box',
      show_cover: false,
      type: '',
      widget: PERotatedBoxScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Transform',
      show_cover: false,
      type: '',
      widget: PETransformScreen(),
      darkThemeSupported: true));
  return list;
}

//endregion
//region AnimationAndMotionWidgets
List<ThemeConfiguration> getAnimationAndMotionWidgets() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Animated Builder',
      show_cover: false,
      type: '',
      widget: AMAnimatedBuilderScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Animated Container',
      show_cover: false,
      type: '',
      widget: AMAnimatedContainerScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Animated Cross Fade',
      show_cover: false,
      type: '',
      widget: AMAnimatedCrossFadeScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Animated Opacity',
      show_cover: false,
      type: '',
      widget: AMAnimatedOpacityScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Fade Transition',
      show_cover: false,
      type: '',
      widget: AMFadeTransitionScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Hero Transition',
      show_cover: false,
      type: '',
      widget: AMHeroScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Scale Transition',
      show_cover: false,
      type: '',
      widget: AMScaleTransitionScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Animated Size',
      show_cover: false,
      type: '',
      widget: AMAnimatedSizeScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Animated Positioned',
      show_cover: false,
      type: '',
      widget: AMAnimatedPositionedScreen(),
      darkThemeSupported: true));
  return list;
}

//endregion
//region interaction
List<ThemeConfiguration> getInteractionModelWidgets() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Dismissible',
      show_cover: false,
      type: '',
      sub_kits: getDismissible(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Gesture Detector',
      show_cover: false,
      type: '',
      widget: IMGestureDetectorScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Draggable',
      show_cover: false,
      type: '',
      sub_kits: getDraggable(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Long Press Draggable',
      show_cover: false,
      type: '',
      sub_kits: getLongPressDraggable(),
      darkThemeSupported: true));
  return list;
}

List<ThemeConfiguration> getDismissible() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Dismissible with Both Side ',
      show_cover: false,
      type: '',
      widget: IMDismissibleScreen1(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Dismissible with One Side',
      show_cover: false,
      type: '',
      widget: IMDismissibleScreen2(),
      darkThemeSupported: true));
  return list;
}

List<ThemeConfiguration> getDraggable() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Simple Draggable',
      show_cover: false,
      type: '',
      widget: IMDraggableScreen1(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Draggable with Target',
      show_cover: false,
      type: '',
      widget: IMDraggableScreen2(),
      darkThemeSupported: true));
  return list;
}

List<ThemeConfiguration> getLongPressDraggable() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Simple Long Press Draggable ',
      show_cover: false,
      type: '',
      widget: IMLongPressDraggableScreen1(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Long Press Draggable with Target',
      show_cover: false,
      type: '',
      widget: IMLongPressDraggableScreen2(),
      darkThemeSupported: true));
  return list;
}

//endregion

//region Other Widgets
List<ThemeConfiguration> getOtherWidgets() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Interactive Viewer',
      show_cover: false,
      type: '',
      widget: InteractiveViewerScreen(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Open Container Transform Demo',
      show_cover: false,
      type: '',
      widget: OpenContainerTransformScreen(),
      darkThemeSupported: true));
  return list;
}

//endregion

//region Default Theme
ThemeConfiguration gettemplate_storage() {
  return ThemeConfiguration(
      name: "Default Theme",
      title_name: 'Default Theme',
      type: '',
      show_cover: false,
      darkThemeSupported: true);
}
//endregion

//region Interactions
ThemeConfiguration getIntegrations() {
  List<ThemeConfiguration> list = [];

  list.add(ThemeConfiguration(
      name: 'Chart',
      title_name: 'Integrations',
      show_cover: false,
      sub_kits: getChartList(),
      darkThemeSupported: true,
      type: 'New'));
  list.add(ThemeConfiguration(
      name: 'Integration',
      title_name: 'Integrations',
      type: '',
      show_cover: false,
      sub_kits: getIntegration(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'UI Interactions',
      title_name: 'Integrations',
      type: '',
      show_cover: false,
      sub_kits: getUI(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Lists',
      title_name: 'Integrations',
      type: '',
      show_cover: false,
      sub_kits: getLists(),
      darkThemeSupported: true));
  //list.add(ProTheme(name: 'Maps', title_name: 'Integrations', type: '', show_cover: false, sub_kits: getMaps(), darkThemeSupported: true));
  //list.add(ProTheme(name: 'Payment Gateways', title_name: 'Integrations', type: '', show_cover: false, sub_kits: getPayment(), darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Rest API Integration',
      title_name: 'Integrations',
      type: '',
      show_cover: false,
      sub_kits: getRestAPi(),
      darkThemeSupported: true));
  return ThemeConfiguration(
      name: 'Integration',
      title_name: 'Integration',
      type: '',
      show_cover: false,
      sub_kits: list);
}

List<ThemeConfiguration> getIntegration() {
  List<ThemeConfiguration> list = [];

  return list;
}

List<ThemeConfiguration> getUI() {
  List<ThemeConfiguration> list = [];

  return list;
}

List<ThemeConfiguration> getLists() {
  List<ThemeConfiguration> list = [];

  list.add(ThemeConfiguration(
      name: 'Shimmer',
      type: '',
      show_cover: false,
      widget: SHomePage(),
      darkThemeSupported: true));
  list.add(ThemeConfiguration(
      name: 'Sticky Header',
      type: '',
      show_cover: false,
      sub_kits: getSubStickyHeader(),
      darkThemeSupported: true));

  return list;
}

List<ThemeConfiguration> getSubStickyHeader() {
  List<ThemeConfiguration> list = [];

  return list;
}

List<ThemeConfiguration> getMaps() {
  List<ThemeConfiguration> list = [];

  //list.add(ProTheme(name: 'Google Maps with Clustering', type: '', show_cover: false, widget: GoogleMapScreen(), darkThemeSupported: true));
  //list.add(ProTheme(name: 'Google Maps with Slipping Panel', type: '', show_cover: false, widget: SlidingPanelScreen(), darkThemeSupported: true));

  return list;
}

List<ThemeConfiguration> getPayment() {
  List<ThemeConfiguration> list = [];

  // list.add(ProTheme(name: 'RazorPay Payment', type: '', show_cover: false, widget: RazorPayScreen(), darkThemeSupported: true));

  return list;
}

List<ThemeConfiguration> getRestAPi() {
  List<ThemeConfiguration> list = [];

  return list;
}
//endregion

//region Flutter Web

ThemeConfiguration getWebApps() {
  List<ThemeConfiguration> list = [];

  return ThemeConfiguration(
      name: 'Web',
      title_name: 'Flutter Web Apps',
      type: '',
      show_cover: false,
      sub_kits: list);
}

List<ThemeConfiguration> getChartList() {
  List<ThemeConfiguration> list = [];
  list.add(ThemeConfiguration(
      name: 'Monthly Sale Chart1',
      type: 'New',
      show_cover: false,
      widget: MonthlySale1Screen(),
      darkThemeSupported: true));

  return list;
}
//endregion
