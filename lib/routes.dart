import 'package:flutter/material.dart';
import 'package:som/main/model/AppModel.dart';
import 'package:som/main/screens/ProKitScreenListing.dart';

Map<String, WidgetBuilder> routes() {
  return <String, WidgetBuilder>{
    ProKitScreenListing.tag: (context) => ProKitScreenListing(ProTheme()),
  };
}
