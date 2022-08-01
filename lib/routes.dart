import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routes() {
  return <String, WidgetBuilder>{
    ScreenListing.tag: (context) => ScreenListing(ThemeConfiguration()),
  };
}
