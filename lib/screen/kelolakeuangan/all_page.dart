import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:keu/model/transaksi_model.dart';

import 'package:keu/controller/transaksi_controller.dart';

import 'detail_keu_page.dart';

class AllPage extends StatefulWidget {
  String startDate;
  String endDate;
  AllPage({Key key, @required this.startDate, @required this.endDate})
      : super(key: key);
  @override
  _AllPageState createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'IDR');

  Widget cardData(Transaksi transaksi) => new Container(
        height: 100,
        width: double.infinity,
        child: new GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: ((context) => DetailKeuPage(
                          level: 'Detail',
                          transaksi: transaksi,
                        ))));
          },
          child: new Card(
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: ListTile(
                  leading: transaksi.status.contains('Pemasukan')
                      ? Icon(Icons.add_circle_outline)
                      : Icon(Icons.remove_circle_outline),
                  title: Text(
                    transaksi.keterangan,
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
                  ),
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
            color: Colors.black,
            blurRadius: 20.0,
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Transaksi>>(
      future: TransaksiController(context)
          .getAllTransaksi(widget.startDate, widget.endDate),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return new ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return cardData(snapshot.data[index]);
              },
            );
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
