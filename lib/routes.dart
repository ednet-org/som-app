import 'package:flutter/material.dart';
import 'package:som/ui/utils/AppModel.dart';
import 'package:som/ui/utils/ScreenListing.dart';

Map<String, WidgetBuilder> routes() {
  return <String, WidgetBuilder>{
    ScreenListing.tag: (context) => ScreenListing(ProTheme()),
  };
}
