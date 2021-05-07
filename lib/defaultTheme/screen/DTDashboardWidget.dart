import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/defaultTheme/model/CategoryModel.dart';
import 'package:prokit_flutter/defaultTheme/model/DTProductModel.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTCartScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTCategoryDetailScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTSearchScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTSignInScreen.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTWidgets.dart';
import 'package:prokit_flutter/main.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppConstant.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/main/utils/rating_bar.dart';

import 'DTProductDetailScreen.dart';

class DTDashboardWidget extends StatefulWidget {
  static String tag = '/DTDashboardWidget';

  @override
  DTDashboardWidgetState createState() => DTDashboardWidgetState();
}

class DTDashboardWidgetState extends State<DTDashboardWidget> {
  PageController pageController = PageController();

  List<Widget> pages = [];
  List<CategoryModel> categories = [];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget searchTxt() {
      return Container(
        width: dynamicWidth(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: viewLineColor),
          color: appStore.scaffoldBackground,
        ),
        margin: EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(AntDesign.search1, color: appStore.textSecondaryColor),
            10.width,
            Text('Search',
                style: boldTextStyle(color: appStore.textSecondaryColor)),
          ],
        ),
        padding: EdgeInsets.all(10),
      ).onTap(() {
        DTSearchScreen().launch(context);
      });
    }

    Widget horizontalList() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(right: 8, top: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: categories.map((e) {
            return Container(
              width: isMobile ? 100 : 120,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: appColorPrimary),
                    child: Image.asset(e.icon,
                        height: 30, width: 30, color: white),
                  ),
                  4.height,
                  Text(e.name,
                      style: primaryTextStyle(size: 12),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ).onTap(() {
              DTCategoryDetailScreen().launch(context);
            });
          }).toList(),
        ),
      );
    }

    Widget horizontalProductListView() {
      return ListView.builder(
        padding: EdgeInsets.all(8),
        itemBuilder: (_, index) {
          DTProductModel data = getProducts()[index];

          return Container(
            decoration: boxDecorationRoundedWithShadow(8,
                backgroundColor: appStore.appBarColor),
            width: 220,
            margin: EdgeInsets.only(right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                10.height,
                Stack(
                  children: [
                    Image.network(
                      data.image,
                      fit: BoxFit.fitHeight,
                      height: 180,
                      width: context.width(),
                    ).cornerRadiusWithClipRRect(8),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: data.isLiked.validate()
                          ? Icon(Icons.favorite, color: Colors.red, size: 16)
                          : Icon(Icons.favorite_border, size: 16),
                    ),
                  ],
                ).expand(),
                8.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data.name,
                        style: primaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    4.height,
                    Row(
                      children: [
                        IgnorePointer(
                          child: RatingBar(
                            onRatingChanged: (r) {},
                            filledIcon: Icons.star,
                            emptyIcon: Icons.star_border,
                            initialRating: data.rating,
                            maxRating: 5,
                            filledColor: Colors.yellow,
                            size: 14,
                          ),
                        ),
                        5.width,
                        Text('${data.rating}',
                            style: secondaryTextStyle(size: 12)),
                      ],
                    ),
                    4.height,
                    Row(
                      children: [
                        priceWidget(data.discountPrice),
                        8.width,
                        priceWidget(data.price, applyStrike: true),
                      ],
                    ),
                  ],
                ).paddingAll(8),
                10.height,
              ],
            ),
          ).onTap(() async {
            int index =
                await DTProductDetailScreen(productModel: data).launch(context);
            if (index != null) appStore.setDrawerItemIndex(index);
          });
        },
        /*gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: context.width() > 1550
                        ? 4
                        : context.width() > 1080
                            ? 3
                            : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: cardWidth / cardHeight,
                  ),*/
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: getProducts().length,
      );
    }

    Widget bannerWidget() {
      return Container(
        margin: EdgeInsets.only(left: 8),
        child: Row(
          children: [
            Image.asset('images/defaultTheme/banner/dt_advertise1.jpg',
                    fit: BoxFit.cover)
                .cornerRadiusWithClipRRect(8)
                .expand(),
            8.width,
            Image.asset('images/defaultTheme/banner/dt_advertise2.jpg',
                    fit: BoxFit.cover)
                .cornerRadiusWithClipRRect(8)
                .expand(),
            8.width,
            Image.asset('images/defaultTheme/banner/dt_advertise4.jpg',
                    fit: BoxFit.cover)
                .cornerRadiusWithClipRRect(8)
                .expand(),
            8.width,
            Image.asset('images/defaultTheme/banner/dt_advertise3.jpg',
                    fit: BoxFit.cover)
                .cornerRadiusWithClipRRect(8)
                .expand(),
          ],
        ),
      );
    }

    Widget mobileWidget() {
      return Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Smart offer management', style: boldTextStyle())
                  .paddingAll(8),
            ],
          ),
        ),
      );
    }

    Widget webWidget() {
      double cardWidth = (dynamicWidth(context)) / 2;
      double cardHeight = context.height() / 5;

      return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 60),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Smart Offer Management', style: boldTextStyle()).paddingAll(8),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: ContainerX(
        mobile: mobileWidget(),
        web: webWidget(),
      ),
    );
  }
}
