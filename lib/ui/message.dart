import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget{
  static String route= '/leave';
  _messageStatePage createState() => _messageStatePage();
}

class _messageStatePage extends State<Message> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Message Page',
            ),
          ],
        ),
      ),
    );
  }
}