import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/template_storage/main/model/ListModels.dart';
import 'package:som/ui/components/utils/DTDataProvider.dart';
import 'package:som/ui/pages/dashboard_page.dart';

import '../../../../main.dart';

class MainMenu extends StatefulWidget {
  static String tag = '/MainMenu';

  @override
  MainMenuState createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu> {
  List<ListModel> drawerItems = getDrawerItems();
  var scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (appStore.selectedDrawerItem > 7) {
      await Future.delayed(Duration(milliseconds: 300));
      scrollController.jumpTo(appStore.selectedDrawerItem * 27.0);

      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipPath(
        child: Drawer(
          child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DrawerHeader(
                    child: Row(
                      children: [
                        50.width,
                        Column(
                          children: [
                            15.height,
                            Image.asset(
                              'images/som/logo.png',
                              height: 75,
                              width: 75,
                            ),
                            15.height,
                            Text('Smart Offer Manager'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text('Home',
                        style: boldTextStyle(
                            color: Theme.of(context).primaryColor)),
                  ).onTap(() {
                    appStore.setDrawerItemIndex(-1);
                    DashboardPage().launch(context, isNewTask: true);
                  }),
                  Divider(height: 16, color: viewLineColor),
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: appStore.selectedDrawerItem == index
                              ? Theme.of(context).primaryColor.withOpacity(0.3)
                              : Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: Text(
                          drawerItems[index].name!,
                          style: boldTextStyle(
                              color: appStore.selectedDrawerItem == index
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                        ),
                      ).onTap(() {
                        finish(context);
                        appStore.setDrawerItemIndex(index);

                        drawerItems[index].widget.launch(context);
                      });
                    },
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    itemCount: drawerItems.length,
                    shrinkWrap: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
