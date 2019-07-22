import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:keu/model/transaksi_model.dart';
import 'package:keu/model/barang_model.dart';
import 'package:keu/model/wishlist_model.dart';

import 'package:keu/controller/barang_controller.dart';
import 'package:keu/data.dart' as Data;

class KebHiburanPage extends StatefulWidget {
  String startDate;
  String endDate;
  KebHiburanPage({Key key, @required this.startDate, @required this.endDate})
      : super(key: key);
  @override
  _KebHiburanPageState createState() => _KebHiburanPageState();
}

class _KebHiburanPageState extends State<KebHiburanPage> {
  TextEditingController _textFieldController = TextEditingController();
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'IDR');
  bool isLoadingInput = false;
  bool isLoadingHapus = false;

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

  Widget listRekomendasi(List<Barang> listRekom) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text("Rekomendasi"),
        ),
        Expanded(
          flex: 5,
          child: new ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listRekom.length,
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (context, index) {
                return new Container(
                  child: new GestureDetector(
                    child: new Card(
                      elevation: 5.0,
                      child: new Container(
                          alignment: Alignment.center,
                          child: new Stack(
                            children: <Widget>[
                              new Image.network(
                                listRekom[index].gambar[0].toString(),
                                fit: BoxFit.cover,
                              ),
                              new Positioned(
                                child: new Align(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Card(
                                    child:
                                        Text(listRekom[index].harga.toString()),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                    onTap: () {
                      _settingModalBottomSheet(context, listRekom[index]);
                    },
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget listData(List<WishList> data) {
    return new ListView.builder(
      itemCount: data.length,
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (context, i) {
        return new Container(
          height: 300,
          child: new Card(
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child:
                                    Text('Keb. Hiburan' + (i + 1).toString()),
                              ),
                              Expanded(
                                flex: 1,
                                child:
                                    showDataRow("Nama :", 1, data[i].nama, 2),
                              ),
                              Expanded(
                                flex: 1,
                                child: showDataRow(
                                    "Transaksi :",
                                    1,
                                    data[i].transaksi[0].status +
                                        "   |   " +
                                        data[i].transaksi[0].keterangan,
                                    2),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: listRekomendasi(data[i].rekomendasi),
                        )
                      ],
                    ),
                    new Positioned(
                      child: new Align(
                          alignment: FractionalOffset.topRight,
                          child: RaisedButton(
                            color: Colors.red,
                            child: Icon(Icons.remove),
                            shape: new CircleBorder(),
                            onPressed: () {
                              _displayDeleteDialog(context, data[i].id);
                            },
                          )),
                    ),
                  ],
                )),
          ),
          decoration: new BoxDecoration(boxShadow: [
            new BoxShadow(
              color: Colors.black,
              blurRadius: 20.0,
            ),
          ]),
        );
      },
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

  _displayDeleteDialog(BuildContext context, String id) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Information'),
            content: Text('Apakah anda yakin akan menghapus data ini?'),
            actions: <Widget>[
              isLoadingHapus
                  ? new Center(child: CircularProgressIndicator())
                  : new FlatButton(
                      child: new Text('Hapus'),
                      onPressed: () {
                        setState(() {
                          this.isLoadingHapus = true;
                        });
                        BarangController(context).deleteDataKeb(id);
                      },
                    ),
              new FlatButton(
                child: new Text('Batal'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<WishList>>(
      future: BarangController(context)
          .getDataBarangKeb(widget.startDate, widget.endDate, Data.kebHiburan),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return listData(snapshot.data);
          } else if (snapshot.hasError) {
            return new Center(
                child: Container(
              height: 500.0,
              child: Text("${snapshot.error}"),
            ));
          }
        }

        return new Center(child: CircularProgressIndicator());
      }),
    );
  }
}
