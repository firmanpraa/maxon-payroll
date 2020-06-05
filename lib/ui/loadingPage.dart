import 'package:flutter/material.dart';
import 'package:payroll/core/services/auth_services.dart';
import 'package:payroll/core/storage/local_model.dart';
import 'package:payroll/core/utils/toast_utils.dart';
import 'package:payroll/ui/loginPage.dart';
import 'dart:async';

import 'package:localstorage/localstorage.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingPage> {
  final LocalStorage storage = new LocalStorage(storageName);
  UserLocal userLocal = new UserLocal();

  @override
  void initState() {
    super.initState();
    getUserLocal().whenComplete(() => startSplashScreen());
  }

  Future<void> getUserLocal() async {
    bool isReady = await storage.ready;
    if (isReady) {
      userLocal.fromJson(storage.getItem(keyUserLocal));
    }
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () async {
      if (userLocal.isLogin != null) {
        if(userLocal.isLogin == true){
          var _response = await AuthServices.checkStillAuth(userLocal);
          if(_response == false){
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) {
                return LoginPage();
              }),
            );
          }else{
            Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
          }
        }
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) {
            return LoginPage();
          }),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xff00317C),
      body: Center(
        child: Container(
          child: Column(children: <Widget>[
            SizedBox(
              height: 200,
            ),
            Image.asset(
              "images/payrollLogo.png",
              width: 200.0,
              height: 100.0,
            ),
            SizedBox(
              height: 200,
            ),
            Text(
              '... Loading ...',
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ]),
        ),
      ),
    );
  }
}
