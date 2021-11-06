import 'package:flutter/material.dart';
import 'package:som/main/model/AppModel.dart';
import 'package:som/main/screens/ScreenListing.dart';

Map<String, WidgetBuilder> routes() {
  return <String, WidgetBuilder>{
    ScreenListing.tag: (context) => ScreenListing(ThemeConfiguration()),
  };
}
