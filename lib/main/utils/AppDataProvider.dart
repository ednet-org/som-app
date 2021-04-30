import 'package:som/main/model/AppModel.dart';
import 'package:som/main/utils/AppConstant.dart';
import 'package:som/webApps/portfolios/portfolio1/Portfolio1Screen.dart';
import 'package:som/webApps/portfolios/portfolio2/Portfolio2Screen.dart';
import 'package:som/webApps/portfolios/portfolio3/Portfolio3Screen.dart';
import 'package:som/widgets/materialWidgets/mwAppStrucutreWidgets/MWDrawerWidgets/MWDrawerScreen2.dart';

Future<AppTheme> getAllAppsAndThemes() async {
  AppTheme appTheme = AppTheme();

  appTheme.themes = getThemes();
  appTheme.screenList = getScreenList();
  appTheme.dashboard = getDashboards();
  appTheme.fullApp = getFullApps();
  appTheme.widgets = getWidgets();
  appTheme.defaultTheme = getDefaultTheme();
  appTheme.integrations = getIntegrations();
  //appTheme.webApps = getWebApps();

  return appTheme;
}

List<ProTheme> getThemes() {
  List<ProTheme> list = List();

  list.add(ProTheme(name: 'File Manager', title_name: 'Theme 1 Screens', type: '', show_cover: true, sub_kits: getFileManageScreens(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Exercise Tips', title_name: 'Theme 2 Screens', type: '', show_cover: true, sub_kits: getExerciseTips(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Food Recipe', title_name: 'Theme 3 Screens', type: '', show_cover: true, sub_kits: getFoodRecipe(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Feed App', title_name: 'Theme 4 Screens', type: '', show_cover: true, sub_kits: getFeedApp(), darkThemeSupported: true));
  list.add(ProTheme(name: 'e-wallet', title_name: 'Theme 5 Screens', type: '', show_cover: true, sub_kits: getEWallet(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Gym', title_name: 'Theme 6 Screens', type: '', show_cover: true, sub_kits: getGymApp(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Hotel Booking', title_name: 'Theme 7 Screens', type: '', show_cover: true, sub_kits: getHotelBooking(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Quiz', title_name: 'Theme 8 Screens', type: '', show_cover: true, sub_kits: getQuiz(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Learner', title_name: 'Theme 9 Screens', type: '', show_cover: true, sub_kits: getLearner(), darkThemeSupported: true));
  list.add(ProTheme(name: 'E-commerce', title_name: 'Theme 10 Screens', type: '', show_cover: true, sub_kits: getECommerce(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Music Streaming', title_name: 'Theme 11 Screens', type: '', show_cover: true, sub_kits: getMusicStreaming(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Digital Wallet', title_name: 'Theme 12 Screens', type: '', show_cover: true, sub_kits: getDigitalWallet(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Real State', title_name: 'Theme 13 Screens', type: '', show_cover: true, sub_kits: getRealState(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Diamond Kit', title_name: 'Theme 14 Screens', type: 'New', show_cover: true, sub_kits: getDiamondKit(), darkThemeSupported: true));

  return list;
}

//region Screens
List<ProTheme> getDigitalWallet() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getRealState() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getDiamondKit() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getMusicStreaming() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getECommerce() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getLearner() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getQuiz() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getHotelBooking() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getGymApp() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getEWallet() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getFeedApp() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getFoodRecipe() {
  List<ProTheme> list = List();

 return list;
}

List<ProTheme> getExerciseTips() {
  List<ProTheme> list = List();


  return list;
}

List<ProTheme> getFileManageScreens() {
  List<ProTheme> list = List();

  return list;
}
//endregion

//region ScreenList
List<ProTheme> getScreenList() {
  List<ProTheme> list = List();
  list.add(ProTheme(name: 'WalkThrough', title_name: 'WalkThrough Screens', type: '', show_cover: true, sub_kits: getWalkThrough(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Sign In', title_name: 'Sign In Screens', type: '', show_cover: true, sub_kits: getSignIn(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Sign Up', title_name: 'Sign Up Screens', type: '', show_cover: true, sub_kits: getSignUp(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Profile', title_name: 'Profile Screens', type: '', show_cover: true, sub_kits: getProfile(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Dashboard', title_name: 'Dashboard Screens', type: '', show_cover: true, sub_kits: getDashboard(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Side Menu', title_name: 'Side Menu Screens', type: '', show_cover: true, sub_kits: getSideMenu(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Bottom Navigation', title_name: 'Bottom Navigation Screens', type: '', show_cover: true, sub_kits: getBottomNavigation(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Detail Screen', title_name: 'Detail Screen Screens', type: '', show_cover: true, sub_kits: getDetailScreen(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Image Slider', title_name: 'Image Slider Screens', type: '', show_cover: true, sub_kits: getImageSlider(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Bottom Sheet', title_name: 'Bottom Sheet Screens', type: '', show_cover: true, sub_kits: getBottomSheet(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Search', title_name: 'Search Screens', type: '', show_cover: true, sub_kits: getSearch(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Listing', title_name: 'Listing Screens', type: '', show_cover: true, sub_kits: getListing(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Cards', title_name: 'Card Screens', type: '', show_cover: true, sub_kits: getCards(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Dialog', title_name: 'Dialog Screens', type: '', show_cover: true, sub_kits: getDialog(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Settings', title_name: 'Setting Screens', type: '', show_cover: true, sub_kits: getSettings(), darkThemeSupported: true));

  return list;
}

List<ProTheme> getWalkThrough() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getSignIn() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getSignUp() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getProfile() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getDashboard() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getSideMenu() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getBottomNavigation() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getDetailScreen() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getImageSlider() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getBottomSheet() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getSearch() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getListing() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getCards() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getDialog() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getSettings() {
  List<ProTheme> list = List();
  return list;
}
//endregion

//region Dashboard
ProTheme getDashboards() {
  ProTheme theme = ProTheme(sub_kits: [], name: 'Dashboard', title_name: 'Dashboard Screens', show_cover: true, type: '');
  List<ProTheme> list = [];

  theme.sub_kits.addAll(list);
  return theme;
}

// endregion

//region FullApps
ProTheme getFullApps() {
  ProTheme theme = ProTheme(name: "Full App", type: 'New', show_cover: true, sub_kits: []);
  List<ProTheme> list = [];

  theme.sub_kits.addAll(list);
  return theme;
}

//endregion

//region Widgets
ProTheme getWidgets() {
  List<ProTheme> list = List();

  list.add(ProTheme(name: 'Material Widgets', type: '', show_cover: false, sub_kits: getMaterialWidgets(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Cupertino Widgets', type: '', show_cover: false, sub_kits: getCupertinoWidgets(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Painting and effect Widgets', type: '', show_cover: false, sub_kits: getPaintingAndEffectWidgets(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Animation and motion Widgets', type: '', show_cover: false, sub_kits: getAnimationAndMotionWidgets(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Interaction Model Widgets', type: '', show_cover: false, sub_kits: getInteractionModelWidgets(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Other Widgets', type: '', show_cover: false, sub_kits: getOtherWidgets(), darkThemeSupported: true));

  return ProTheme(name: 'Widgets', title_name: 'Widgets', type: '', show_cover: false, sub_kits: list);
}

//region Material

List<ProTheme> getMaterialWidgets() {
  List<ProTheme> list = List();
  list.add(ProTheme(name: 'App Structure', show_cover: false, type: '', sub_kits: getAppStructure(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Buttons', show_cover: false, type: '', sub_kits: getButtons(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Input & Selection', show_cover: false, type: '', sub_kits: getInputSelection(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Dialogs, Alerts & Panels', show_cover: false, type: '', sub_kits: getDialogs(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Information Display', show_cover: false, type: '', sub_kits: getInformationDisplay(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Layout', show_cover: false, type: '', sub_kits: getLayout(), darkThemeSupported: true));
  return list;
}

//region subMaterialWidgets
List<ProTheme> getAppStructure() {
  List<ProTheme> list = List();
  list.add(ProTheme(name: 'Bottom Navigation Bar', show_cover: false, type: '', sub_kits: getBottomNavigationBar(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Drawer', show_cover: false, type: '', sub_kits: getDrawer(), darkThemeSupported: true));
  list.add(ProTheme(name: 'SliverAppBar', show_cover: false, type: '', sub_kits: getSliverAppBar(), darkThemeSupported: true));
  list.add(ProTheme(name: 'TabBar', show_cover: false, type: '', sub_kits: getTabBar(), darkThemeSupported: true));
  return list;
}

List<ProTheme> getBottomNavigationBar() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getDrawer() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getSliverAppBar() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getTabBar() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getButtons() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getInputSelection() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getTextField() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getDialogs() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getInformationDisplay() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getListView() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getLayout() {
  List<ProTheme> list = List();
  list.add(ProTheme(name: 'Stepper', show_cover: false, type: '', sub_kits: getStepper(), darkThemeSupported: true));
  list.add(ProTheme(name: 'User Accounts Drawer Header', show_cover: false, type: '', sub_kits: getUserAccountsDrawerHeader(), darkThemeSupported: true));
  return list;
}

List<ProTheme> getStepper() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getUserAccountsDrawerHeader() {
  List<ProTheme> list = List();

  return list;
}
//endregion

//endregion
//region Cupertino
List<ProTheme> getCupertinoWidgets() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getCupertinoTabBar() {
  List<ProTheme> list = List();

  return list;
}

//endregion
//region PaintingAndEffectWidgets
List<ProTheme> getPaintingAndEffectWidgets() {
  List<ProTheme> list = List();

  return list;
}

//endregion
//region AnimationAndMotionWidgets
List<ProTheme> getAnimationAndMotionWidgets() {
  List<ProTheme> list = List();

  return list;
}

//endregion
//region interaction
List<ProTheme> getInteractionModelWidgets() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getDismissible() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getDraggable() {
  List<ProTheme> list = List();
  return list;
}

List<ProTheme> getLongPressDraggable() {
  List<ProTheme> list = List();
  return list;
}

//endregion

//region Other Widgets
List<ProTheme> getOtherWidgets() {
  List<ProTheme> list = List();

  return list;
}
//endregion

//endregion

//region Default Theme
ProTheme getDefaultTheme() {
  return ProTheme(name: "Default Theme", title_name: 'Default Theme', type: '', show_cover: false, darkThemeSupported: true);
}
//endregion

//region Interactions
ProTheme getIntegrations() {
  List<ProTheme> list = List();

  list.add(ProTheme(name: 'Integration', title_name: 'Integrations', type: '', show_cover: false, sub_kits: getIntegration(), darkThemeSupported: true));
  list.add(ProTheme(name: 'UI Interactions', title_name: 'Integrations', type: '', show_cover: false, sub_kits: getUI(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Lists', title_name: 'Integrations', type: '', show_cover: false, sub_kits: getLists(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Maps', title_name: 'Integrations', type: '', show_cover: false, sub_kits: getMaps(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Payment Gateways', title_name: 'Integrations', type: '', show_cover: false, sub_kits: getPayment(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Rest API Integration', title_name: 'Integrations', type: '', show_cover: false, sub_kits: getRestAPi(), darkThemeSupported: true));

  return ProTheme(name: 'Integration', title_name: 'Integration', type: '', show_cover: false, sub_kits: list);
}

List<ProTheme> getIntegration() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getUI() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getLists() {
  List<ProTheme> list = List();

  list.add(ProTheme(name: 'Sticky Header', type: '', show_cover: false, sub_kits: getSubStickyHeader(), darkThemeSupported: true));

  return list;
}

List<ProTheme> getSubStickyHeader() {
  List<ProTheme> list = List();

  return list;
}

List<ProTheme> getMaps() {
  List<ProTheme> list = List();


  return list;
}

List<ProTheme> getPayment() {
  List<ProTheme> list = List();


  return list;
}

List<ProTheme> getRestAPi() {
  List<ProTheme> list = List();



  return list;
}
//endregion

//region Flutter Web

ProTheme getWebApps() {
  List<ProTheme> list = List();

  list.add(ProTheme(name: 'Portfolio', title_name: 'Single Page Websites', type: '', show_cover: false, sub_kits: getPortfolioSites(), darkThemeSupported: true));

  return ProTheme(name: 'Web', title_name: 'Flutter Web Apps', type: '', show_cover: false, sub_kits: list);
}

List<ProTheme> getPortfolioSites() {
  List<ProTheme> list = List();

  list.add(ProTheme(name: 'Portfolio 1', type: '', show_cover: false, widget: Portfolio1Screen(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Portfolio 2', type: '', show_cover: false, widget: Portfolio2Screen(), darkThemeSupported: true));
  list.add(ProTheme(name: 'Portfolio 3', type: '', show_cover: false, widget: Portfolio3Screen(), darkThemeSupported: true));

  return list;
}

//endregion
