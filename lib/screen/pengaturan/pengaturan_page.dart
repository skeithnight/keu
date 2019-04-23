import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:keu/utils/draweritem.dart';

class PengaturanPage extends StatefulWidget {
  final DrawerItem drawerItem;

  PengaturanPage({Key key, @required this.drawerItem}) : super(key: key);

  @override
  FirstScreenState createState() {
    return new FirstScreenState();
  }
}

class FirstScreenState extends State<PengaturanPage> {
  bool _value1 = false;
  bool _value2 = false;

  void _onChanged1(bool value) => setState(() => _value1 = value);
  void _onChanged2(bool value) => setState(() => _value2 = value);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Container(
        height: 400.0,
        width: double.infinity,
        child: new Card(
          child: Center(
            child: Container(
              width: double.infinity,
              height: 200.0,
              child: new Column(
                children: <Widget>[
                  new SwitchListTile(
                    value: _value2,
                    onChanged: _onChanged2,
                    title: new Text('Set Notifikasi Produk Murah',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                  ),
                  new SwitchListTile(
                    value: _value2,
                    onChanged: _onChanged2,
                    title: new Text('Set Notifikasi Wish List',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                  ),
                  new ListTile(
                    title: new Text('Tambah Jenis pemasukan dan pengeluaran',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                    trailing: RaisedButton(
                      padding: EdgeInsets.all(12.0),
                      shape: StadiumBorder(),
                      child: Text(
                        "Tambah",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: ((context) => SignUpPage())));
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        decoration: new BoxDecoration(boxShadow: [
          new BoxShadow(
            color: Colors.black,
            blurRadius: 20.0,
          ),
        ]),
      ),
    );
  }
}
