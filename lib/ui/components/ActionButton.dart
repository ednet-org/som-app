// ignore: must_be_immutable
import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  var textContent;
  VoidCallback onPressed;

  ActionButton({required this.textContent, required this.onPressed});

  @override
  State<StatefulWidget> createState() {
    return ActionButtonState();
  }
}

class ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(color: Colors.white),
        elevation: 4,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        padding: const EdgeInsets.all(0.0),
      ),
      onPressed: widget.onPressed,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[Colors.blueAccent, Colors.lightBlueAccent]),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Text(
              widget.textContent,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
