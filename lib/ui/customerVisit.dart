import 'dart:async';
import 'package:payroll/core/services/customer_visit_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payroll/core/models/user_model.dart';
import 'package:payroll/core/services/auth_services.dart';
import 'package:payroll/core/storage/local_model.dart';
import 'package:payroll/core/utils/toast_utils.dart';
import 'package:payroll/ui/widget/top_profile.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';

import 'loginPage.dart';

class CustomerVisit extends StatefulWidget {
  static String route = '/customer';

  _CustomerStatePage createState() => _CustomerStatePage();
}

class _CustomerStatePage extends State<CustomerVisit> {
  String _time;
  String _dateTime;
  String _timeStart = "-";
  String _timeDuration = "-";
  MaterialColor _statsColor = Colors.grey;
  UserModel _userModel = UserModel();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isCompleteLoad = false;
  LocalStorage storage = new LocalStorage(storageName);
  String _statsTap = "OUT";
  String token = "";

  final SnackBar userStatusSnackBar = SnackBar(
    content: Text("Please wait get user data ..."),
    duration: Duration(days: 365),
  );

  Future<void> validatingAuth(UserLocal userLocal) async {
    var _response = await AuthServices.checkStillAuth(userLocal);
    if (_response == false) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return LoginPage();
        }),
      );
    } else {
      fetchUserModel(userLocal).then((value) {
        _userModel = value;
      });
      getCustomerVisit().then((value) {
        print("hasil value ${value.status}");
        if (value.status == "IN") {
          _statsTap = value.status;
          _timeStart =
              DateFormat('hh:mm:ss').format(DateTime.parse(value.startIn));
          _statsColor = Colors.green;
        }
      });
    }
  }

  Future<UserLocal> getUserLocal() async {
    UserLocal local = UserLocal();
    if (await storage.ready) {
      local.fromJson(await storage.getItem(keyUserLocal));
    }
    return local;
  }

  @override
  void initState() {
    super.initState();
    _time = _formatDateTime(DateTime.now());
    _dateTime = _formatDate(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    getUserLocal().then((local) {
      token = local.token;
      validatingAuth(local);
    });
  }

  Future<UserModel> fetchUserModel(UserLocal local) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey.currentState.showSnackBar(userStatusSnackBar);
    });
    UserModel _response;
    _response = await AuthServices.getUserInformation(local.token);
    _isCompleteLoad = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
    });
    return _response;
  }

  Future<void> getStatusVisit() async {
    LocalCustomerVisit localCustomerVisit = await getCustomerVisit();
    if (localCustomerVisit.status != null) {
      _timeStart = localCustomerVisit.startIn;
      _statsTap = localCustomerVisit.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
            color: Colors.white,
            child: CustomScrollView(
              slivers: <Widget>[
                TopProfile(
                  photoPath: _userModel.photo,
                  nameEmployee: _userModel.name,
                  department: _userModel.department,
                  position: _userModel.position,
                  isBackButton: true,
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 10),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              onPressed: () {
                                onTapIn();
                              },
                              color: Color(0xff00317C),
                              textColor: Colors.white,
                              child: Text("IN"),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              onPressed: () {
                                onTapOut();
                              },
                              color: Color(0xff00317C),
                              textColor: Colors.white,
                              child: Text("OUT"),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.drafts,
                                color: Colors.yellowAccent[400],
                                size: 30.0,
                              ),
                              Text(
                                'Note',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.lightBlueAccent,
                                  fontFamily: 'RobotoBold',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                              ),
                              Icon(
                                Icons.assignment,
                                color: Colors.yellowAccent[400],
                                size: 30.0,
                              ),
                              Text(
                                'History',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.lightBlueAccent,
                                  fontFamily: 'RobotoBold',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _time,
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.blue[900],
                              fontFamily: 'RobotoBold',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _dateTime,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.lightBlueAccent),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                //waktu
                                Text(
                                  _timeStart,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.blue[900],
                                    fontFamily: 'RobotoBold',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Start Time',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.lightBlueAccent,
                                    fontFamily: 'RobotoBold',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                // onTap: () {message();},
                                child: ClipOval(
                                  child: Container(
                                    color: _statsColor,
                                    height: 30.0,
                                    width: 30,
                                  ),
                                ),
                              ),
                              Text(
                                _statsTap,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.lightBlueAccent,
                                  fontFamily: 'RobotoBold',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  _timeDuration,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.blue[900],
                                    fontFamily: 'RobotoBold',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Duration',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.lightBlueAccent,
                                    fontFamily: 'RobotoBold',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ])
                        ],
                      )
                    ]),
                  ),
                )
              ],
            )));
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }

  String _formatDate(DateTime datetime) {
    return DateFormat('d MMMM y, E').format(datetime);
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _time = formattedDateTime;
    });
  }

  Future<LocalCustomerVisit> getCustomerVisit() async {
    LocalCustomerVisit custVisit = new LocalCustomerVisit();
    if (await storage.ready) {
      var json = await storage.getItem(keyCustomerVisitLocal);
      print("hasil check json $json");
      if (json != null) {
        custVisit.fromJson(json);
      }
    }
    print("cust visit $custVisit");
    return custVisit;
  }

  Future<void> onTapIn() async {
    if (_isCompleteLoad) {
      LocalCustomerVisit custVisit = await getCustomerVisit();
      print("hasil status check ${custVisit.status}");
      if (custVisit.status == null) {
        _statsTap = "IN";
        _timeDuration = "-";
        DateTime dateTime = DateTime.now();
        _timeStart = DateFormat('hh:mm:ss').format(dateTime);
        _statsColor = Colors.green;
        LocalCustomerVisit writeCustomerLocal =
            LocalCustomerVisit(status: "IN", startIn: dateTime.toString());
        print(
            "hasil write ${writeCustomerLocal.status} : ${writeCustomerLocal.startIn}");
        await storage.setItem(
            keyCustomerVisitLocal, writeCustomerLocal.toJsonEncodeAble());
      }
      Navigator.pushNamed(context, "/userVerification");
    } else {
      ToastUtils.show("Please wait ...");
    }
  }

  Future<void> onTapOut() async {
    if(_statsTap == "OUT"){
      ToastUtils.show("Please tap in first");
    }else{
      LocalCustomerVisit localCustomerVisit = await getCustomerVisit();
      if(localCustomerVisit.items.isEmpty){
        ToastUtils.show("no data submit, report visit is empty");
      }else{
        localCustomerVisit.items.forEach((element) {
          Map<String, dynamic> data = {
            "latitude": element.latitude,
            "longitude": element.longitude,
            "report": element.message
          };
          var response =  CustomerVisitService.submitVisit(data,token);
          print("submit response $response");
        });
        ToastUtils.show("data has been submitted");
      }
      _statsTap = "OUT";
      _statsColor = Colors.grey;
      var timeStart = DateTime.parse(localCustomerVisit.startIn);
      var timeNow = DateTime.now();
      var differTime = timeNow.difference(timeStart).toString();
      _timeDuration= differTime.substring(0, differTime.indexOf('.'));
      await storage.setItem(keyCustomerVisitLocal, null);
    }
  }
}
