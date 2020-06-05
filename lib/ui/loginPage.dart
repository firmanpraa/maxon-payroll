import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:payroll/core/services/auth_services.dart';
import 'package:payroll/core/storage/local_model.dart';
import 'package:payroll/core/utils/toast_utils.dart';
import 'package:payroll/ui/widget/input_field.dart';
import 'package:payroll/ui/widget/primary_button.dart';
import 'package:localstorage/localstorage.dart';

import 'homepage.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var nikController = TextEditingController();
  var passwordController = TextEditingController();
  final LocalStorage storage = new LocalStorage(storageName);
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  bool _isSuccessLocation = false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    getLocation();
  }

 Future<void> getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Can't get location GPS service has not enabled"),
          ));
        });
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Can't get location permission was not granted"),
          ));
        });
      }
    }
  }

  Future<void> prosesLogin() async {
    if (nikController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      Map<String, dynamic> data = {
        "nik": nikController.text,
        "password": passwordController.text
      };

      var response = await AuthServices.login(data);
      if (response != null) {
        if (response.codeRespon == 200 && response.token != null) {
          bool storageReady = await storage.ready;
          if (storageReady) {
            final userLocal = UserLocal(token: response.token,
                isLogin: true,
                nikEmployee: nikController.text);
            await storage.setItem(keyUserLocal,userLocal.toJSONEncodeAble());
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                ModalRoute.withName('/home'));
            ToastUtils.show("Welcome");
          }
        }
      } else {
        ToastUtils.show("NIK/Password is Wrong");
      }
    } else {
      ToastUtils.show("NIK/Password must be filled");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xff00317C),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Image.asset(
              "images/payrollLogo.png",
              width: 200.0,
              height: 100.0,
            ),
            SizedBox(
              height: 30,
            ),
            new Container(
              color: Color(0xff003994),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                    child: new Text(
                      "EMPLOYEE SELF SERVICE",
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              color: Color(0xff003B99),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  InputField(
                      action: TextInputAction.done,
                      type: TextInputType.number,
                      controller: nikController,
                      hintText: "Insert NIK",
                      labelText: "Employee Main Number (NIK)"),
                  InputField(
                    action: TextInputAction.done,
                    type: TextInputType.number,
                    controller: passwordController,
                    hintText: "Insert password",
                    labelText: "Password",
                    secureText: true,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        color: Color(0xff77A5F8),
                        height: 130,
                      ),
                      Container(
                        color: Color(0xff003B99),
                        height: 50,
                      ),
                      new Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(top: 20.0)),
                              Container(
                                  height: 50,
                                  width: 300,
                                  child: PrimaryButton(
                                      color: Color(0xff0051FF),
                                      text: 'Sign In',
                                      onClick: () {
                                        prosesLogin();
                                      })),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ),
            new Container(
              color: Color(0xff003B99),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 70,
                  ),
                  Text(
                    'Don\'t have an account ?',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => null));
                    },
                    child: Text(
                      'Contact Us',
                      style: TextStyle(
                          color: Color(0xfff79c4f),
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
