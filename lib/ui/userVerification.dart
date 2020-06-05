import 'dart:async';
import 'package:payroll/core/storage/local_model.dart';
import 'package:payroll/core/utils/toast_utils.dart';
import 'package:localstorage/localstorage.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payroll/core/models/user_model.dart';
import 'package:payroll/core/services/auth_services.dart';
import 'package:payroll/ui/widget/top_profile.dart';
import 'package:intl/intl.dart';

class UserVerification extends StatefulWidget {
  _UserVerification createState() => _UserVerification();
}

class _UserVerification extends State<UserVerification> {
  String _time;
  String _dateTime;
  double latitude;
  double longitude;
  UserModel _userModel = UserModel();
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  bool _isSuccessLocation = false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  LocalStorage storage = new LocalStorage(storageName);
  final TextEditingController _messageController = new TextEditingController();

  Future<LocalCustomerVisit> getCustomerVisit() async {
    LocalCustomerVisit custVisit = new LocalCustomerVisit();
    if(await storage.ready){
      var json = await storage.getItem(keyCustomerVisitLocal);
      print("hasil check json $json");
      if(json!=null){
        custVisit.fromJson(json);
      }
    }
    print("cust visit $custVisit");
    return custVisit;
  }

  final SnackBar statusLocationSnackBar = SnackBar(
    content: Text("Please wait get current location ..."),
    duration: Duration(days: 365),
  );

  Future<void> getLocation() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey.currentState.showSnackBar(statusLocationSnackBar);
    });
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

  @override
  void initState() {
    super.initState();
    getLocation();
    _time = _formatDateTime(DateTime.now());
    _dateTime = _formatDate(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    fetchUserModel().then((value) {
      _userModel = value;
    });
    location.onLocationChanged.listen((LocationData currentLocation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(_isSuccessLocation == false){
          _isSuccessLocation = true;
          _scaffoldKey.currentState.hideCurrentSnackBar();
        }
      });
      latitude = currentLocation.latitude;
      longitude = currentLocation.longitude;
    });
  }

  Future<UserModel> fetchUserModel() async {
    LocalStorage storage = new LocalStorage(storageName);
    UserModel _response;
    if (await storage.ready) {
      UserLocal local = UserLocal();
      local.fromJson(await storage.getItem(keyUserLocal));
      _response = await AuthServices.getUserInformation(local.token);
    }
    return _response;
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
                      Column(
                        children: <Widget>[
                          Divider(color: Colors.black),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 5.0),
                            child: Row(children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Colors.lightBlue[900],
                                size: 25.0,
                              ),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                    'Current Location:\nLatitude: $latitude, Longitude: $longitude',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                              )
                            ]),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 5.0),
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Message',
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 1.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Divider(color: Colors.black),
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                width: double.infinity,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  onPressed: () {
                                    submitMessage();
                                  },
                                  color: Color(0xff00317C),
                                  textColor: Colors.white,
                                  child: Text("SUBMIT"),
                                ),
                              )),
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

  void submitMessage() async {
    var msgText = _messageController.text;
    if(_isSuccessLocation == true && msgText.isNotEmpty){
      LocalCustomerVisit localCustomerVisit = await getCustomerVisit();
      TodoIn todoIn = TodoIn(
        latitude: latitude,
        longitude: longitude,
        message: msgText
      );
      localCustomerVisit.items.add(todoIn);
      await storage.setItem(keyCustomerVisitLocal, localCustomerVisit.toJsonEncodeAble());
      Navigator.of(context).pop();
      ToastUtils.show("Success submit message");
    }else{
      ToastUtils.show("Message and Location must not be empty");
    }
  }
}
