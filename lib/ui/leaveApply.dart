import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeaveApply extends StatefulWidget{
  static String route= '/leave';
  _leaveStatePage createState() => _leaveStatePage();
}

class _leaveStatePage extends State<LeaveApply> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Leave Apply Page',
            ),
          ],
        ),
      ),
    );
  }
}