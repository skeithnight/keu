import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:userpet/screens/dashboard/dashboard_one.page.dart';

import 'package:keu/utils/draweritem.dart';

import 'package:keu/data.dart' as data;

import 'package:keu/controller/login_controller.dart';

import 'package:keu/model/user_model.dart';

import 'package:keu/screen/authentication/login_page.dart';
import 'kelolakeuangan/kelola_keu_page.dart';
import 'wishlist/wish_list_page.dart';
import 'searchtoko/search_toko_page.dart';
import 'pengaturan/pengaturan_page.dart';

class MainScreen extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Kelola Keuangan", Icons.book),
    new DrawerItem("Wish List", Icons.shopping_basket),
    new DrawerItem("Cari di Toko Online", Icons.search),
    // new DrawerItem("Pengaturan", Icons.info)
  ];

  static String tag = 'main-page';
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedDrawerIndex = 0;
  String level;
  SharedPreferences prefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoginController(context).checkToken();
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new KelolaKeuPage(
          drawerItem: widget.drawerItems[_selectedDrawerIndex],
        );
      case 1:
        return new WishListPage(
          drawerItem: widget.drawerItems[_selectedDrawerIndex],
        );
      case 2:
        return new SearchToko(
          drawerItem: widget.drawerItems[_selectedDrawerIndex],
        );
      case 3:
        return new PengaturanPage(
          drawerItem: widget.drawerItems[_selectedDrawerIndex],
        );

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  Widget bodyContent() {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }
    return new SafeArea(
      child: Scaffold(
        appBar: new AppBar(
          // here we display the title corresponding to the fragment
          // you can instead choose to have a static title
          title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                LoginController(context).logout();
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: ((context) => LoginPage())));
              },
            )
          ],
        ),
        drawer: new Drawer(
          child: new Column(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: Text("Username"),
                accountEmail: Text("email"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).platform == TargetPlatform.iOS
                          ? Colors.blue
                          : Colors.white,
                  child: Text(
                    "U",
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
              new Column(children: drawerOptions)
            ],
          ),
        ),
        body: _getDrawerItemWidget(_selectedDrawerIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new FutureBuilder<User>(
        future: LoginController(context).checkSession(),
        builder: ((context, snapshot) {
          print(snapshot.data);
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return bodyContent();
            } else if (snapshot.hasError) {
              // throw(snapshot.error);
              return new Center(
                  child: Container(
                height: 500.0,
                child: Text("${snapshot.error}"),
              ));
            }
          }

          return new Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
