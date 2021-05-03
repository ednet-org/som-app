import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/defaultTheme/model/CategoryModel.dart';
import 'package:som/defaultTheme/model/ProductModel.dart';
import 'package:som/defaultTheme/screen/CartScreen.dart';
import 'package:som/defaultTheme/screen/CategoryDetailScreen.dart';
import 'package:som/defaultTheme/screen/SearchScreen.dart';
import 'package:som/defaultTheme/screen/SignInScreen.dart';
import 'package:som/defaultTheme/utils/DTDataProvider.dart';
import 'package:som/defaultTheme/utils/DTWidgets.dart';
import 'package:som/main.dart';
import 'package:som/main/utils/AppColors.dart';
import 'package:som/main/utils/AppConstant.dart';
import 'package:som/main/utils/AppWidget.dart';
import 'package:som/main/utils/rating_bar.dart';

import 'ProductDetailScreen.dart';

class DashboardWidget extends StatefulWidget {
  static String tag = 'DashboardWidget';

  @override
  DashboardWidgetState createState() => DashboardWidgetState();
}

class DashboardWidgetState extends State<DashboardWidget> {
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
    categories.add(CategoryModel(name: 'Inquiries', icon: 'images/defaultTheme/category/electronics.png'));
    categories.add(CategoryModel(name: 'TV & Appliances', icon: 'images/defaultTheme/category/Tv.png'));
    categories.add(CategoryModel(name: 'Men', icon: 'images/defaultTheme/category/Man.png'));
    categories.add(CategoryModel(name: 'Women', icon: 'images/defaultTheme/category/women.png'));
    categories.add(CategoryModel(name: 'Baby & Kids', icon: 'images/defaultTheme/category/kids.png'));
    categories.add(CategoryModel(name: 'Home & Furniture', icon: 'images/defaultTheme/category/furniture.png'));
    categories.add(CategoryModel(name: 'Fashion', icon: 'images/defaultTheme/category/fashion.png'));
    categories.add(CategoryModel(name: 'Sports', icon: 'images/defaultTheme/category/sports.png'));
    categories.add(CategoryModel(name: 'Jewellery', icon: 'images/defaultTheme/category/jewelry.png'));
    categories.add(CategoryModel(name: 'Stationary', icon: 'images/defaultTheme/category/stationary.png'));
    categories.add(CategoryModel(name: 'Shoes', icon: 'images/defaultTheme/category/Shoes.png'));
    categories.add(CategoryModel(name: 'Watch', icon: 'images/defaultTheme/category/Watch.png'));
    categories.add(CategoryModel(name: 'Electronics', icon: 'images/defaultTheme/category/electronics.png'));
    categories.add(CategoryModel(name: 'TV & Appliances', icon: 'images/defaultTheme/category/Tv.png'));
    categories.add(CategoryModel(name: 'Men', icon: 'images/defaultTheme/category/Man.png'));
    categories.add(CategoryModel(name: 'Women', icon: 'images/defaultTheme/category/women.png'));
    categories.add(CategoryModel(name: 'Baby & Kids', icon: 'images/defaultTheme/category/kids.png'));
    categories.add(CategoryModel(name: 'Home & Furniture', icon: 'images/defaultTheme/category/furniture.png'));
    categories.add(CategoryModel(name: 'Fashion', icon: 'images/defaultTheme/category/fashion.png'));
    categories.add(CategoryModel(name: 'Sports', icon: 'images/defaultTheme/category/sports.png'));
    categories.add(CategoryModel(name: 'Jewellery', icon: 'images/defaultTheme/category/jewelry.png'));
    categories.add(CategoryModel(name: 'Stationary', icon: 'images/defaultTheme/category/stationary.png'));
    categories.add(CategoryModel(name: 'Shoes', icon: 'images/defaultTheme/category/Shoes.png'));
    categories.add(CategoryModel(name: 'Watch', icon: 'images/defaultTheme/category/Watch.png'));

    pages = [
      Container(child: Image.asset('images/som/connecting/shutterstock_725507023.jpg', height: isMobile ? 150 : 350, fit: BoxFit.fitWidth, cacheHeight: 350,)),
      Container(child: Image.asset('images/som/connecting/shutterstock_1006041130.jpg', height: isMobile ? 150 : 350, fit: BoxFit.fitWidth, cacheHeight: 350)),
      Container(child: Image.asset('images/som/connecting/shutterstock_1440765188.jpg', height: isMobile ? 150 : 350, fit: BoxFit.fitWidth, cacheHeight: 350)),
      Container(child: Image.asset('images/som/connecting/shutterstock_1528360379.jpg', height: isMobile ? 150 : 350, fit: BoxFit.fitWidth, cacheHeight: 350)),
    ];

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget mobileWidget() {
      return Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              10.height,
              Text('Please Sign in', style: boldTextStyle()).paddingAll(8),
              20.height,
              Text('in order to use Smart offer manager', style: boldTextStyle()).paddingAll(8),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              200.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome to the Smart offer management, please Sign in or Register!', style: primaryTextStyle(size: 30),),
                ],
              ),
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
