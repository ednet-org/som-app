import 'package:flutter/material.dart';

class Debuggable extends StatefulWidget {
  var component;

  Debuggable({this.component});

  @override
  State<Debuggable> createState() => _DebuggableState();
}

class _DebuggableState extends State<Debuggable> {
  @override
  build(BuildContext context) {
    return Text('khm');
  }
}
