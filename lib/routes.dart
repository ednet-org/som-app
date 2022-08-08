import 'package:flutter/material.dart';
import 'package:som/ui/pages/verify_email.dart';

Map<String, WidgetBuilder> routes() {
  return <String, WidgetBuilder>{
    VerifyEmailPage.tag: (context) => VerifyEmailPage(),
  };
}
