import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Attendance extends StatefulWidget {
  static String route= '/attendance';

  _attendanceState createState() => _attendanceState();
}

class _attendanceState extends State<Attendance>  {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Attendance Page',
            ),
          ],
        ),
      ),
    );
  }
}