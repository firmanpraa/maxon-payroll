import 'package:payroll/core/storage/local_model.dart';
import 'package:payroll/ui/widget/top_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../core/models/user_model.dart';
import '../core/services/auth_services.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    UserModel user = new UserModel();
    var _scaffoldKey = GlobalKey<ScaffoldState>();
    bool _isCompleteLoad = false;

  final SnackBar userStatusSnackBar = SnackBar(
    content: Text("Please wait get user data ..."),
    duration: Duration(days: 365),
  );
  Future<void> _logout() async {
    final LocalStorage storage = new LocalStorage(storageName);
    bool storageReady = await storage.ready;
    if(storageReady){
      storage.clear();
    }
    Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
  }
  
  @override
  void initState() {
    super.initState();
    fetchUserModel().then((value) {
      user = value;
    });
  }
  
  Future<UserModel> fetchUserModel() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey.currentState.showSnackBar(userStatusSnackBar);
    });
    LocalStorage storage = new LocalStorage(storageName);
    UserModel _response;
    if (await storage.ready) {
      UserLocal local = UserLocal();
      local.fromJson(await storage.getItem(keyUserLocal));
      _response = await AuthServices.getUserInformation(local.token);
      setState(() {
        _isCompleteLoad = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scaffoldKey.currentState.hideCurrentSnackBar();
      });
    }
    return _response;
  }
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                    Navigator.pushNamed(context, '/home');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.home, color: Colors.white),
                      Text("Home", style: TextStyle(color: Colors.white))
                    ],
                  ),
                )),
            Container(
                width: 80,
                color: Color(0xff00317C),
                child: InkWell(
                  onTap: () {
//                    Navigator.pushNamed(context, '/profile');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.account_box, color: Colors.white30),
                      Text("Profil", style: TextStyle(color: Colors.white30))
                    ],
                  ),
                )),
            Container(
                width: 80,
                color: Color(0xff00317C),
                child: InkWell(
                  onTap: () {
//                    Navigator.pushNamed(context, '/setting');
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
                    _logout();
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
      backgroundColor: Color(0xff00317C),
      body: Container(
        color: Colors.white,
        child: CustomScrollView(slivers: <Widget>[
           TopProfile(
            photoPath: user.photo,
            nameEmployee: user.name,
            department: user.department,
            position: user.position,
            isBackButton: false,
          ),
          SliverGrid(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              delegate: SliverChildListDelegate([
                DashMenu(
                    title: "Attendance",
                    images: 'images/schedule.png',
                    route: '/attendance'),
                DashMenu(
                    title: "Customer Visit",
                    images: 'images/map.png',
                    route: '/customer'),
                DashMenu(
                    title: "Leave Apply",
                    images: 'images/writing.png',
                    route: '/leave'),
                DashMenu(
                    title: "Overtime Apply",
                    images: 'images/writing.png',
                    route: '/overtime'),
                DashMenu(
                    title: "Claim Apply",
                    images: 'images/money.png',
                    route: '/claim'),
                DashMenu(
                    title: "Message",
                    images: 'images/message.png',
                    route: '/message'),
              ])),
        ]),
      ),
    );
  }
}

class DashMenu extends StatelessWidget {
  DashMenu({this.title, this.images, this.route});

  final String title;
  final String images;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        splashColor: Colors.blueAccent,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                images,
                width: 60,
                height: 60,
              ),
              SizedBox(
                height: 10,
              ),
              Text(title,
                  style: new TextStyle(
                      fontSize: 10.0, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}
