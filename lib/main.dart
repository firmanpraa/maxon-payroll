import 'package:flutter/material.dart';
import 'package:payroll/ui/attendance.dart';
import 'package:payroll/ui/claimApply.dart';
import 'package:payroll/ui/customerVisit.dart';
import 'package:payroll/ui/homepage.dart';
import 'package:payroll/ui/leaveApply.dart';
import 'package:payroll/ui/loadingPage.dart';
import 'package:payroll/ui/loginPage.dart';
import 'package:payroll/ui/message.dart';
import 'package:payroll/ui/overtimeApply.dart';
import 'package:payroll/ui/profile.dart';
import 'package:payroll/ui/setting.dart';
import 'package:payroll/ui/userVerification.dart';

void main(List<String> args) {
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => LoadingPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/attendance': (context) => Attendance(),
        '/customer': (context) => CustomerVisit(),
        '/userVerification': (context) => UserVerification(),
        '/leave': (context) => LeaveApply(),
        '/overtime': (context) => OvertimeApply(),
        '/claim': (context) => ClaimApply(),
        '/message': (context) => Message(),
        '/setting': (context) => Setting(),
        '/profile': (context) => Profile()

      },
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Payroll Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
