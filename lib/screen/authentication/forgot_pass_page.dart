import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:keu/utils/uidata.dart';

import 'package:keu/model/apotek_model.dart';
import 'login_page.dart';
import 'package:keu/controller/register_controller.dart';

class ForgotPassPage extends StatefulWidget {
  _ForgotPassPageState createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  Apotek apotek = new Apotek();
  Size deviceSize;

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: signUpBody(context),
      ),
    );
  }

  signUpBody(context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[signUpHeader(), signUpFields(context)],
        ),
      );

  signUpHeader() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 80.0,
            height: 80.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage("${UIData.uriIcon}")),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      );

  signUpFields(context) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    this.apotek.name = text;
                  });
                },
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Email ....",
                  labelText: "Email Anda:",
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            FlatButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: ((context) => LoginPage())));
              },
              child: Text(
                "Login",
                style: TextStyle(
                    color: Colors.grey, decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              width: double.infinity,
              child: isloading == false
                  ? RaisedButton(
                      padding: EdgeInsets.all(12.0),
                      shape: StadiumBorder(),
                      child: Text(
                        "Send",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.green,
                      onPressed: () {
                        setState(() {
                          this.isloading = true;
                        });
                        RegisterController(context).sendData(apotek);
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      );
}
