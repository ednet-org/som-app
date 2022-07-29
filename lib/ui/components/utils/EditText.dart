import 'package:flutter/material.dart';
import 'package:som/template_storage/integrations/utils/colors.dart';
import 'package:som/template_storage/integrations/utils/constants.dart';

class EditText extends StatefulWidget {
  var isPassword;
  var isSecure;
  var fontSize;
  var textColor;
  var fontFamily;
  var text;
  var maxLine;
  TextEditingController? mController;

  VoidCallback? onPressed;

  EditText(
      {var this.fontSize = textSizeMedium,
      var this.textColor = textColorPrimary,
      var this.fontFamily = fontRegular,
      var this.isPassword = true,
      var this.isSecure = false,
      var this.text = "",
      var this.mController,
      var this.maxLine = 1});

  @override
  State<StatefulWidget> createState() {
    return EditTextState();
  }
}

class EditTextState extends State<EditText> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isSecure) {
      return TextFormField(
        controller: widget.mController,
        obscureText: widget.isPassword,
        cursorColor: textColorSecondary,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(16, 8, 4, 8),
          hintText: widget.text,
          labelText: widget.text,
        ),
        maxLines: widget.maxLine,
        style:
            TextStyle(fontSize: widget.fontSize, fontFamily: widget.fontFamily),
      );
    } else {
      return TextField(
        controller: widget.mController,
        obscureText: widget.isPassword,
        cursorColor: textColorSecondary,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                widget.isPassword = !widget.isPassword;
              });
            },
            child: Icon(
                widget.isPassword ? Icons.visibility : Icons.visibility_off),
          ),
          contentPadding: EdgeInsets.fromLTRB(16, 8, 4, 8),
          hintText: widget.text,
          labelText: widget.text,
        ),
        style:
            TextStyle(fontSize: widget.fontSize, fontFamily: widget.fontFamily),
      );
    }
  }
}
