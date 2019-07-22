import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_dialogs/easy_dialogs.dart';

import 'package:keu/utils/draweritem.dart';

import 'package:keu/model/wishlist_model.dart';
import 'package:keu/model/barang_model.dart';
import 'package:keu/model/status_model.dart';
import 'package:keu/model/transaksi_model.dart';

import 'package:keu/controller/wishlist_controller.dart';
import 'package:keu/controller/barang_controller.dart';
import 'package:keu/controller/transaksi_controller.dart';

import 'keb_pokok_page.dart';
import 'keb_hiburan_page.dart';
import 'detail_barang_keb_page.dart';

class BarangPage extends StatefulWidget {
  final DrawerItem drawerItem;

  BarangPage({Key key, @required this.drawerItem}) : super(key: key);

  @override
  FirstScreenState createState() {
    return new FirstScreenState();
  }
}

class FirstScreenState extends State<BarangPage> {
  TextEditingController _textFieldController = TextEditingController();
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'IDR');
  bool isLoadingInput = false;
  bool isLoadingHapus = false;

  String startDate;
  String endDate;

  WishList kebutuhan;
  List<Transaksi> _daftarTrans;
  String _selectedTransaksi;

  List<String> _kategori = ['Kebutuhan_Pokok', 'Kebutuhan_Hiburan']; // Option 2
  String _selectedKategori;

  @override
  void initState() {
    super.initState();

    kebutuhan = new WishList();
    // _selectedKategori = _kategori[0];
    setState(() {
      this.startDate = "2018-07-10 12:04:35";
      this.endDate = DateTime.now().toString();
    });
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

  Widget listRekomendasi(List<Barang> listRekom) {
    return new ListView.builder(
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
                              child: Text(listRekom[index].harga.toString()),
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
        });
  }

  Widget listData(List<WishList> data) {
    return new ListView.builder(
      itemCount: data.length,
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (context, i) {
        return new Container(
          height: 200,
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
                                child: Text('Wish List' + (i + 1).toString()),
                              ),
                              showDataRow(
                                  "Nama Wish List :", 1, data[i].nama, 2),
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

  Widget statusKeuangan() {
    return new FutureBuilder<Status>(
      future: TransaksiController(context).getStatusKeu(startDate, endDate),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return new Container(
            height: 100,
            width: double.infinity,
            child: new Card(
              color: Colors.redAccent,
              child: Center(
                child: Container(
                  child: Text(formatCurrency.format(snapshot.data.saldo),
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 36.0)),
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
        } else if (snapshot.hasError) {
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

  Widget bodyContent() {
    return Column(
      children: <Widget>[
        statusKeuangan(),
        Expanded(
          flex: 8,
          child: new FutureBuilder<List<WishList>>(
            future: WishListController(context).getDataWishList(),
            builder: ((context, snapshot) {
              print(snapshot.data);
              if (snapshot.hasData) {
                return listData(snapshot.data);
              } else if (snapshot.hasError) {
                return new Center(
                    child: Container(
                  height: 500.0,
                  child: Text("${snapshot.error}"),
                ));
              }

              return new Center(child: CircularProgressIndicator());
            }),
          ),
        )
      ],
    );
  }

  Widget listTransaksi() {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: 50.0,
            color: Colors.red,
            child: TabBar(
              tabs: [Text("Keb. Pokok"), Text("Keb. Hiburan")],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                KebPokokPage(
                  startDate: startDate,
                  endDate: endDate,
                ),
                KebHiburanPage(
                  startDate: startDate,
                  endDate: endDate,
                ),
              ],
            ),
          )
        ],
      ),
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

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Tambah Barang'),
            content: new Container(
              height: 150.0,
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Expanded(
                    child: DropdownButton(
                      hint: Text(
                          '===== Pilih Kategori ====='), // Not necessary for Option 1
                      value: _selectedKategori,
                      onChanged: (String newValue) {
                        _selectedKategori = newValue;
                        print(newValue);
                        // setState(() {
                        //   _selectedKategori = newValue;
                        //   // _transaksi.status = newValue;
                        // });
                      },
                      items: _kategori.map((location) {
                        return DropdownMenuItem(
                          child: new Text(location),
                          value: location,
                        );
                      }).toList(),
                    ),
                  ),
                  new Expanded(
                    child: DropdownButton(
                      hint: Text(
                          '===== Pilih Transaksi ====='), // Not necessary for Option 1
                      value: _selectedTransaksi,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedTransaksi = newValue;
                          kebutuhan.transaksi[0] =
                              Transaksi.fromString(newValue);
                        });
                      },
                      items: _daftarTrans.map((item) {
                        return DropdownMenuItem(
                          child: new Text(item.id),
                          value: item.id,
                        );
                      }).toList(),
                    ),
                  ),
                  // new Expanded(
                  //   child: new RaisedButton(
                  //     onPressed: _openRingtoneDialog,
                  //     textColor: Colors.white,
                  //     color: Colors.red,
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: new Text(
                  //       "Pilih Transaksi",
                  //     ),
                  //   ),
                  // ),
                  new Expanded(
                    child: TextField(
                      controller: _textFieldController,
                      decoration: InputDecoration(hintText: "Nama Barang"),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              isLoadingInput
                  ? new Center(child: CircularProgressIndicator())
                  : new FlatButton(
                      child: new Text('Simpan'),
                      onPressed: () {
                        setState(() {
                          this.isLoadingInput = true;
                          kebutuhan.nama = _textFieldController.text;
                        });
                        BarangController(context).inputDataKeb(kebutuhan);
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
                        WishListController(context).deleteDataWishList(id);
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
    return new DefaultTabController(
      length: 2,
      child: Scaffold(
        // body: bodyContent(),
        body: Column(
          children: <Widget>[
            // statusKeuangan(),
            listTransaksi(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: ((context) => DetailBarangKebPage())));
            // _displayDialog(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
