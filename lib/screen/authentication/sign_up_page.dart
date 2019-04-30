import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:keu/utils/uidata.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:keu/utils/changeDate.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:keu/model/user_model.dart';
import 'package:keu/controller/register_controller.dart';

class SignUpPage extends StatefulWidget {
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  User user = new User();
  Size deviceSize;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<String>(
      future: _firebaseMessaging.getToken(),
      builder: ((context, snapshot) {
        this.user.fcmtoken =snapshot.data;
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: registerBody(context),
            ),
          );
        } else if (snapshot.hasError) {
          // throw(snapshot.error);
          return new Center(
              child: Container(
            height: 500.0,
            child: Text("${snapshot.error}"),
          ));
        }

        return new Center(child: CircularProgressIndicator());
      }),
    );
  }

  registerBody(context) => Container(
        height: 500.0,
        child: new Card(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[registerHeader(), registerFields(context)],
            ),
          ),
        ),
        decoration: new BoxDecoration(boxShadow: [
          new BoxShadow(
            color: Colors.black,
            blurRadius: 20.0,
          ),
        ]),
      );

  registerHeader() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 80.0,
            height: 80.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: new ExactAssetImage('assets/icon/logo.png'),
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      );

  registerFields(context) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextField(
                maxLines: 1,
                onChanged: (text) {
                  setState(() {
                    this.user.nama = text;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  labelText: "Nama",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextField(
                maxLines: 1,
                onChanged: (text) {
                  setState(() {
                    this.user.email = text;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  labelText: "Email",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              child: TextField(
                maxLines: 1,
                onChanged: (text) {
                  setState(() {
                    this.user.password = text;
                  });
                },
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  labelText: "Password",
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              width: double.infinity,
              child: RaisedButton(
                padding: EdgeInsets.all(12.0),
                shape: StadiumBorder(),
                child: Text(
                  "Daftar",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: () {
                  RegisterController(context).sendData(user);
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: ((context) => SignUpPage())));
                },
              ),
            ),
          ],
        ),
      );
}
