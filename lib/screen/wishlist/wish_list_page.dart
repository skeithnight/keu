import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:keu/utils/draweritem.dart';

class WishListPage extends StatefulWidget {
  final DrawerItem drawerItem;

  WishListPage({Key key, @required this.drawerItem}) : super(key: key);

  @override
  FirstScreenState createState() {
    return new FirstScreenState();
  }
}

class FirstScreenState extends State<WishListPage> {
  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Icon(
          Icons.ac_unit,
          size: 54.0,
        ),
        new Text(
          widget.drawerItem.title,
          style: new TextStyle(fontSize: 48.0, fontWeight: FontWeight.w300),
        ),
      ],
    ));
  }
}