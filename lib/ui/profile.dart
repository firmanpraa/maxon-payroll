import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  static String route = '/profile';

  _profileStatePage createState() => _profileStatePage();
}

class _profileStatePage extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Row(
          children: <Widget>[
            Container(
                width: 80,
                color: Color(0xff00317C),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.home, color: Colors.white30),
                      Text("Home", style: TextStyle(color: Colors.white30))
                    ],
                  ),
                )),
            Container(
                width: 80,
                color: Color(0xff00317C),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.account_box, color: Colors.white),
                      Text("Profil", style: TextStyle(color: Colors.white))
                    ],
                  ),
                )),
            Container(
                width: 80,
                color: Color(0xff00317C),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/setting');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.settings, color: Colors.white30),
                      Text("Setting", style: TextStyle(color: Colors.white30))
                    ],
                  ),
                )),
            Container(
                width: 80,
                color: Color(0xff00317C),
                child: InkWell(
                  onTap: () {

                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.exit_to_app, color: Colors.white30),
                      Text("Sign Out", style: TextStyle(color: Colors.white30))
                    ],
                  ),
                )),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Profile Page',
            ),
          ],
        ),
      ),
    );
  }
}
