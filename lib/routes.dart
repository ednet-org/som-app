import 'package:flutter/material.dart';
import 'package:som/template_storage/main/model/AppModel.dart';
import 'package:som/template_storage/main/screens/ScreenListing.dart';

Map<String, WidgetBuilder> routes() {
  return <String, WidgetBuilder>{
    ScreenListing.tag: (context) => ScreenListing(ThemeConfiguration()),
  };
}
