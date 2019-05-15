import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

import 'package:keu/utils/draweritem.dart';

import 'all_page.dart';
import 'pemasukan_page.dart';
import 'pengeluaran_page.dart';
import 'detail_keu_page.dart';

import 'package:keu/controller/transaksi_controller.dart';

import 'package:keu/model/status_model.dart';

class KelolaKeuPage extends StatefulWidget {
  final DrawerItem drawerItem;

  KelolaKeuPage({Key key, @required this.drawerItem}) : super(key: key);

  @override
  FirstScreenState createState() {
    return new FirstScreenState();
  }
}

class FirstScreenState extends State<KelolaKeuPage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'IDR');

  String startDate;
  String endDate;

  static const List<IconData> icons = const [
    Icons.add,
    Icons.filter_list,
  ];

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    setState(() {
      this.startDate = "2018-07-10 12:04:35";
      this.endDate = DateTime.now().toString();
    });
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Filter Data"),
          content: new MaterialButton(
              color: Colors.redAccent,
              onPressed: () async {
                final List<DateTime> picked =
                    await DateRagePicker.showDatePicker(
                        context: context,
                        initialFirstDate: new DateTime.now(),
                        initialLastDate:
                            (new DateTime.now()).add(new Duration(days: 7)),
                        firstDate: new DateTime(2015),
                        lastDate: new DateTime(2020));
                if (picked != null && picked.length == 2) {
                  setState(() {
                    this.startDate = picked[0].toLocal().toString();
                    this.endDate = picked[1].toLocal().toString();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: new Text("Pick date range")),
        );
      },
    );
  }

  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Widget floatingAB() {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(icons.length, (int index) {
        Widget child = new Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
              curve: new Interval(0.0, 1.0 - index / icons.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: new FloatingActionButton(
              backgroundColor: backgroundColor,
              mini: true,
              child: new Icon(icons[index], color: foregroundColor),
              onPressed: () {
                switch (index) {
                  case 0:
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => DetailKeuPage(
                                  level: 'Tambah',
                                ))));
                    break;
                  case 1:
                    _showDialog();
                    break;
                }
              },
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          new FloatingActionButton(
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform:
                      new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(
                      _controller.isDismissed ? Icons.more_vert : Icons.close),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ),
    );
  }

  Widget statusKeuangan() {
    return new FutureBuilder<Status>(
      future: TransaksiController(context).getStatusKeu(startDate, endDate),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return new Container(
            height: 120,
            width: double.infinity,
            child: new Card(
              color: Colors.redAccent,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(formatCurrency.format(snapshot.data.saldo),
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 36.0)),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Pokok",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16.0),
                              ),
                              Text(
                                formatCurrency.format(snapshot.data.k1),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Hiburan",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16.0),
                              ),
                              Text(
                                formatCurrency.format(snapshot.data.k2),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Tabungan",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16.0),
                              ),
                              Text(
                                formatCurrency.format(snapshot.data.k3),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.0),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
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

  Widget listTransaksi() {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: 50.0,
            color: Colors.red,
            child: TabBar(
              tabs: [Text("All"), Text("Pemasukan"), Text("Pengeluaran")],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                AllPage(
                  startDate: startDate,
                  endDate: endDate,
                ),
                PemasukanPage(
                  startDate: startDate,
                  endDate: endDate,
                ),
                PengeluaranPage(
                  startDate: startDate,
                  endDate: endDate,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: <Widget>[statusKeuangan(), listTransaksi()],
        ),
        floatingActionButton: floatingAB(),
      ),
    );
  }
}
