import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:keu/model/wishlist_model.dart';
import 'package:keu/model/transaksi_model.dart';

import 'package:keu/controller/transaksi_controller.dart';
import 'package:keu/controller/barang_controller.dart';

import 'package:keu/screen/main_screen.dart';

class DetailBarangKebPage extends StatefulWidget {
  DetailBarangKebPage();
  @override
  _DetailBarangKebPageState createState() => _DetailBarangKebPageState();
}

class _DetailBarangKebPageState extends State<DetailBarangKebPage> {
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'IDR');
  bool isLoading = false;
  bool isLoadingEdit = false;
  bool isLoadingHapus = false;

  // List<String> _status = ['Pemasukan', 'Pengeluaran']; // Option 1
  // String _selectedStatus;
  // List<String> _kategori = ['Kebutuhan_Pokok', 'Kebutuhan_Hiburan']; // Option 2
  // String _selectedKategori;

  String startDate;
  String endDate;

  WishList kebutuhan;
  List<Transaksi> _daftarTrans;
  List<Transaksi> _selectedListTransaksi = new List<Transaksi>();
  Transaksi _selectedTransaksi;

  final keteranganTEC = TextEditingController();
  final tanggalTEC = TextEditingController();
  final jumlahTEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    kebutuhan = new WishList();
    setState(() {
      this.startDate = "2018-07-10 12:04:35";
      this.endDate = DateTime.now().toString();
    });
    getDataTransaksi();
  }

  void getDataTransaksi() async {
    _daftarTrans = await TransaksiController(context)
        .getTransaksiByKategori("Pengeluaran", startDate, endDate);
  }

  Widget showButton() {
    return Container(
      width: double.infinity,
      child: isLoading
          ? new Center(child: CircularProgressIndicator())
          : new RaisedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  kebutuhan.kategori = _selectedTransaksi.kategori;
                  kebutuhan.transaksi = _selectedListTransaksi;
                });
                BarangController(context).inputDataKeb(kebutuhan,);
              },
              textColor: Colors.white,
              color: Colors.blue,
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                "Simpan",
              ),
            ),
    );
  }

  Widget bodyContent() => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Tambah Data"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: ((context) => MainScreen()))),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              width: double.infinity,
              height: 600.0,
              child: Card(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          padding: new EdgeInsets.all(18.0),
                        ),
                        new FutureBuilder<List<Transaksi>>(
                          future: TransaksiController(context)
                              .getTransaksiByKategori(
                                  "Pengeluaran", startDate, endDate),
                          builder: ((context, snapshot) {
                            // print(snapshot.data);
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                return Container(
                                  // width: double.infinity,
                                  child: _selectedTransaksi == null
                                      ? RaisedButton(
                                          onPressed: () {
                                            _displayOngkirDialog(context);
                                          },
                                          textColor: Colors.white,
                                          color: Colors.redAccent,
                                          padding: const EdgeInsets.all(8.0),
                                          child: new Text(
                                            "Pilih Transaksi",
                                          ),
                                        )
                                      : cardListTransaksi(
                                          _selectedTransaksi, false),
                                );
                              } else if (snapshot.hasError) {
                                // throw(snapshot.error);
                                return new Center(
                                    child: Container(
                                  height: 500.0,
                                  child: Text("${snapshot.error}"),
                                ));
                              }
                            }

                            return new Center(
                                child: CircularProgressIndicator());
                          }),
                        ),
                        new Container(
                          padding: new EdgeInsets.all(10.0),
                        ),
                        Container(
                          width: double.infinity,
                          child: TextField(
                              onChanged: (value) {
                                setState(() => kebutuhan.nama = value);
                              },
                              controller: keteranganTEC,
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nama Barang')),
                        ),
                        new Container(
                          padding: new EdgeInsets.all(50.0),
                        ),
                        showButton()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  _displayOngkirDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ongkos Kirim'),
            content: Container(
              width: double.maxFinite,
              height: 300.0,
              child: ListView(
                padding: EdgeInsets.all(8.0),
                //map List of our data to the ListView
                children: _daftarTrans
                    .map((data) => cardListTransaksi(data, true))
                    .toList(),
              ),
            ),
          );
        });
  }

  Widget cardListTransaksi(Transaksi transaksi, bool dialogOrNot) =>
      new Container(
        child: new GestureDetector(
          onTap: () {
            if (dialogOrNot) {
              Navigator.of(context).pop();
              setState(() {
                _selectedTransaksi = transaksi;
                _selectedListTransaksi.add(transaksi);
                // kebutuhan.transaksi.add(transaksi);
                // kebutuhan.kategori = transaksi.kategori;
              });
            } else {
              _displayOngkirDialog(context);
            }
          },
          child: new Card(
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        transaksi.tanggal,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 14.0),
                      ),
                      transaksi.kategori != null
                          ? Text(
                              transaksi.kategori,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 14.0),
                            )
                          : Container()
                    ],
                  ),
                  trailing: Text(formatCurrency.format(transaksi.jumlah)),
                )),
          ),
        ),
        decoration: new BoxDecoration(boxShadow: [
          new BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new WillPopScope(
        onWillPop: () async => false,
        child: bodyContent(),
      ),
    );
  }
}
