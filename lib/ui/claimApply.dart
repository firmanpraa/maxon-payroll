import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClaimApply extends StatefulWidget{
  static String route= '/claim';
  _claimStatePage createState() => _claimStatePage();
}

class _claimStatePage extends State<ClaimApply> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Claim Apply Page',
            ),
          ],
        ),
      ),
    );
  }
}