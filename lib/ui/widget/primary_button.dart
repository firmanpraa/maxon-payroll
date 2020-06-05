import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  Color color;
  String text;
  Function onClick;

  PrimaryButton(
      {@required this.color, @required this.text, @required this.onClick});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onClick,
      color: color,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(50.0)),
      child: new Text(text,
          style: new TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold)),
    );
  }
}
