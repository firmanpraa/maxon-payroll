import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payroll/core/config/endpoint.dart';

class TopProfile extends StatelessWidget {
  final String nameEmployee;
  final String department;
  final String position;
  final String photoPath;
  final bool isBackButton;

  TopProfile(
      {this.nameEmployee,
      this.department,
      this.position,
      this.photoPath,
      this.isBackButton});

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate([
      Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            color: Color(0xff00317C),
            padding: new EdgeInsets.only(top: 70.0, bottom: 20),
            child: Image.asset(
              "images/payrollLogo.png",
              height: 80.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Visibility(
                  child: Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0)),
                    elevation: 18.0,
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    // Add This
                    child: MaterialButton(
                      minWidth: 10.0,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  visible: isBackButton,
                ),
              ],
            ),
          )
        ],
      ),
      new Container(
        color: Color(0xff00317C),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: 170,
                ),
                Container(
                  color: Color(0xff00317C),
                  height: 80,
                ),
                new Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    Container(
                      child: CircleAvatar(
                          radius: 70.0,
                          backgroundImage: NetworkImage(
                              Endpoint.basePhotoUrl + this.photoPath)),
                    ),
                  ],
                )),
              ],
            ),
            Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 0.0, bottom: 10.0),
                          child: new Text(
                            nameEmployee,
                            style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 0.0, bottom: 10.0),
                          child: new Text(
                            department,
                            style: new TextStyle(
                              fontSize: 15.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 0.0, bottom: 10.0),
                          child: new Text(
                            " | ",
                            style: new TextStyle(
                              fontSize: 15.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 0.0, bottom: 10.0),
                          child: new Text(
                            position,
                            style: new TextStyle(
                              fontSize: 15.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    ]));
  }
}
