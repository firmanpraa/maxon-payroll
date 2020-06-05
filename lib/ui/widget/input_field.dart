import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  TextEditingController controller;
  TextInputAction action;
  TextInputType type;
  String hintText;
  String labelText;
  bool secureText;
  bool readOnly;
  Function onTap;

  InputField(
      {this.controller,
      this.action,
      this.type,
      this.hintText,
      this.labelText,
      this.secureText = false,
      this.onTap,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
            child: TextField(
              controller: controller,
              onTap: () => onTap != null ? onTap() : {},
              // textInputAction: action,
              textInputAction: TextInputAction.next,
              keyboardType: type,
              obscureText: secureText,
              readOnly: readOnly,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 12),
                border: InputBorder.none,
                labelText: labelText,
                labelStyle: new TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
            )));
  }
}
