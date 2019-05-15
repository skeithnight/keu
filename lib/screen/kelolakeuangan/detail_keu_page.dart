import 'package:flutter/material.dart';

import 'package:keu/model/transaksi_model.dart';

import 'package:keu/utils/changeDate.dart';

import 'package:keu/controller/transaksi_controller.dart';

import 'package:keu/screen/main_screen.dart';

class DetailKeuPage extends StatefulWidget {
  String level;
  Transaksi transaksi = new Transaksi();
  DetailKeuPage({Key key, @required this.level, this.transaksi})
      : super(key: key);
  @override
  _DetailKeuPageState createState() => _DetailKeuPageState();
}

class _DetailKeuPageState extends State<DetailKeuPage> {
  bool isLoading = false;
  bool isLoadingEdit = false;
  bool isLoadingHapus = false;

  List<String> _status = ['Pemasukan', 'Pengeluaran']; // Option 2
  String _selectedStatus;
  List<String> _kategori = ['Kebutuha_Pokok', 'Kebutuhan_Hiburan']; // Option 2
  String _selectedKategori;

  DateTime selectedDate = DateTime.now();

  Transaksi _transaksi = new Transaksi();

  final keteranganTEC = TextEditingController();
  final tanggalTEC = TextEditingController();
  final jumlahTEC = TextEditingController();

  @override
  void initState() {
    if (widget.level.contains('Detail')) {
      _transaksi = widget.transaksi;
      _selectedStatus = _transaksi.status;
      keteranganTEC.text = _transaksi.keterangan;
      tanggalTEC.text = _transaksi.tanggal;
      jumlahTEC.text = _transaksi.jumlah.toString();
      if (_transaksi.kategori != null) {
        _selectedKategori = _transaksi.kategori;
      }
    } else {
      _transaksi = new Transaksi();
      _selectedStatus = _status[0];
      _transaksi.status = _status[0];
    }
    super.initState();
  }

  Widget showButton() {
    if (widget.level.contains('Detail')) {
      return Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: isLoadingEdit
                ? new Center(child: CircularProgressIndicator())
                : new RaisedButton(
                    onPressed: () {
                      setState(() {
                        isLoadingEdit = true;
                      });
                      TransaksiController(context).editData(_transaksi);
                    },
                    textColor: Colors.white,
                    color: Colors.green,
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      "Edit",
                    ),
                  ),
          ),
          Container(
            width: double.infinity,
            child: isLoadingHapus
                ? new Center(child: CircularProgressIndicator())
                : new RaisedButton(
                    onPressed: () {
                      setState(() {
                        isLoadingHapus = true;
                      });
                      TransaksiController(context).hapusData(_transaksi);
                    },
                    textColor: Colors.white,
                    color: Colors.red,
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      "Hapus",
                    ),
                  ),
          )
        ],
      );
    } else {
      return Container(
        width: double.infinity,
        child: isLoading
            ? new Center(child: CircularProgressIndicator())
            : new RaisedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  TransaksiController(context).sendData(_transaksi);
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(widget.level + " Data"),
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
                          Container(
                            width: double.infinity,
                            child: DropdownButton(
                              hint: Text(
                                  '===== Pilih Jenis Keuangan ====='), // Not necessary for Option 1
                              value: _selectedStatus,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedStatus = newValue;
                                  _transaksi.status = newValue;
                                });
                              },
                              items: _status.map((location) {
                                return DropdownMenuItem(
                                  child: new Text(location),
                                  value: location,
                                );
                              }).toList(),
                            ),
                          ),
                          new Container(
                            padding: new EdgeInsets.all(18.0),
                          ),
                          _selectedStatus.contains("Pengeluaran")
                              ? Container(
                                  width: double.infinity,
                                  child: DropdownButton(
                                    hint: Text(
                                        '===== Pilih Jenis Kategori ====='), // Not necessary for Option 1
                                    value: _selectedKategori,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedKategori = newValue;
                                        _transaksi.kategori = newValue;
                                      });
                                    },
                                    items: _kategori.map((location) {
                                      return DropdownMenuItem(
                                        child: new Text(location),
                                        value: location,
                                      );
                                    }).toList(),
                                  ),
                                )
                              : Container(),
                          new Container(
                            padding: new EdgeInsets.all(10.0),
                          ),
                          Container(
                            width: double.infinity,
                            child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _transaksi.keterangan = value;
                                  });
                                },
                                controller: keteranganTEC,
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Keterangan')),
                          ),
                          new Container(
                            padding: new EdgeInsets.all(10.0),
                          ),
                          Container(
                            width: double.infinity,
                            child: TextField(
                                controller: tanggalTEC,
                                onTap: () async {
                                  final DateTime picked = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime(2015, 8),
                                      lastDate: DateTime(2101));
                                  if (picked != null &&
                                      picked != selectedDate) {
                                    setState(() {
                                      selectedDate = picked;
                                      tanggalTEC.text = changeDate(picked);
                                      _transaksi.tanggal = picked
                                          .millisecondsSinceEpoch
                                          .toString();
                                    });
                                    print(picked);
                                  }
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Tanggal')),
                          ),
                          new Container(
                            padding: new EdgeInsets.all(10.0),
                          ),
                          Container(
                            width: double.infinity,
                            child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _transaksi.jumlah = int.parse(value);
                                  });
                                },
                                controller: jumlahTEC,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Jumlah')),
                          ),
                          new Container(
                            padding: new EdgeInsets.all(20.0),
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
        ),
      ),
    );
  }
}
