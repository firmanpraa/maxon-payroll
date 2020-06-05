import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OvertimeApply extends StatefulWidget{
  static String route= '/over';
  _overtimeStatePage createState() => _overtimeStatePage();
}

class _overtimeStatePage extends State<OvertimeApply> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Overtime Apply Page',
            ),
          ],
        ),
      ),
    );
  }
}