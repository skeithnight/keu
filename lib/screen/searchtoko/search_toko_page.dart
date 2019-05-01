import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:keu/utils/draweritem.dart';

import 'package:keu/model/barang_model.dart';
import 'package:keu/controller/barang_controller.dart';

class SearchToko extends StatefulWidget {
  final DrawerItem drawerItem;

  SearchToko({Key key, @required this.drawerItem}) : super(key: key);

  @override
  FirstScreenState createState() {
    return new FirstScreenState();
  }
}

class FirstScreenState extends State<SearchToko> {
  TextEditingController editingController = TextEditingController();

  List<Barang> data = new List<Barang>();

  Widget gridData() {
    return Expanded(
      child: new GridView.builder(
          itemCount: data.length,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              child: new Card(
                elevation: 5.0,
                child: new Container(
                    alignment: Alignment.center,
                    child: new Stack(
                      children: <Widget>[
                        new Image.network(
                          data[index].gambar[0].toString(),
                          fit: BoxFit.cover,
                        ),
                        new Positioned(
                          child: new Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Card(
                              child: showDataRow(data[index].judul, 3,
                                  data[index].harga.toString(), 1),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              onTap: () {
                _settingModalBottomSheet(context, data[index]);
              },
            );
          }),
    );
  }

  Widget searchData() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onSubmitted: (value) {
          filterSearchResults(value);
        },
        onChanged: (value) {},
        controller: editingController,
        decoration: InputDecoration(
            labelText: "Search",
            hintText: "Cari Sesuatu",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
    );
  }

  Widget bodyContent() {
    return Container(
      child: Column(
        children: <Widget>[searchData(), gridData()],
      ),
    );
  }

  Widget showDataRow(String right, int flR, String left, int flL) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: flR,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(right),
            )),
        Expanded(
          flex: flL,
          child: Text(left),
        ),
      ],
    );
  }

  void _settingModalBottomSheet(context, Barang barang) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: new Wrap(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(barang.gambar[0]),
                      ),
                    ),
                  ),
                  Text(
                    barang.judul,
                    style: new TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  showDataRow("Harga", 1, barang.harga.toString(), 3),
                  showDataRow("Stok", 1, barang.stok.toString(), 3),
                  showDataRow("E-Commerce", 1, barang.ecommerce, 3),
                  new Center(
                    child: new RaisedButton(
                      onPressed: () {
                        _launchURL(barang.url);
                      },
                      child: new Text('Lihat URL'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void filterSearchResults(String query) async {
    if (query.isNotEmpty) {
      List<Barang> result =
          await BarangController(context).getDataBarang(query);
      setState(() {
        data.clear();
        data.addAll(result);
      });
      return;
    } else {
      setState(() {
        data.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return bodyContent();
  }
}
