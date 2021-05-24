import 'package:flutter/material.dart';
import 'package:uts/pages/sign_in.dart';

import 'first_screen.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepOrange[200],
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text("D-Moneyku Indonesia",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black87,
                      fontFamily: "OpenSansSemiBold",
                    )),
              ),
              Container(
                child: Text("Let's start our journey, shall we?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontFamily: "OpenSansLight",
                    )),
              ),
              SizedBox(height: 25),
              Image(image: AssetImage("assets/piggy.png"), width: 300.0),
              SizedBox(height: 25),
              _signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return FlatButton(
      color: Colors.white,
      splashColor: Colors.orangeAccent,
      onPressed: () {
        signInWithGoogle().then((result) {
          if (result != null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (Route<dynamic> route) => false,
            );
          }
        });
      },
      child: Padding(
        padding: new EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 25.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign In',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
      ),
    );
  }
}
