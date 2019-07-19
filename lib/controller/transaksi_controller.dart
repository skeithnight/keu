import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:keu/data.dart' as data1;

import 'package:keu/model/transaksi_model.dart';
import 'package:keu/model/status_model.dart';

import 'package:keu/screen/widget/dialog_widget.dart';
import 'package:keu/screen/main_screen.dart';

class TransaksiController {
  SharedPreferences prefs;
  BuildContext context;
  TransaksiController(this.context);
  Dio dio = new Dio();
  Transaksi transaksi;

  Future<String> getToken() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<Status> getStatusKeu(String start, String end) async {
    int longStart = DateTime.parse(start).millisecondsSinceEpoch;
    int longEnd = DateTime.parse(end).millisecondsSinceEpoch;

    prefs = await SharedPreferences.getInstance();
    dio.options.headers = {
      "Authorization": "Bearer " + prefs.getString('token') ?? ''
    };
    dio.options.baseUrl = data1.urlTransaksi;

    var response = await dio.get('/status/${longStart}/${longEnd}');

    Status status = Status.fromSnapshot(response.data);

    return status;
  }

  // Transaksi
  Future<List<Transaksi>> getAllTransaksi(String start, String end) async {
    int longStart = DateTime.parse(start).millisecondsSinceEpoch;
    int longEnd = DateTime.parse(end).millisecondsSinceEpoch;

    // print(longStart);
    // print(longEnd);

    // print('/transaksi/by-tanggal/${longStart}/${longEnd}');

    prefs = await SharedPreferences.getInstance();
    dio.options.headers = {
      "Authorization": "Bearer " + prefs.getString('token') ?? ''
    };
    dio.options.baseUrl = data1.urlTransaksi;

    var response = await dio.get('/by-tanggal/${longStart}/${longEnd}');

    List<dynamic> map = response.data;
    List<Transaksi> listTransaksi = new List();
    for (var i = 0; i < map.length; i++) {
      listTransaksi.add(Transaksi.fromSnapshot(map[i]));
    }

    return listTransaksi;
  }

  Future<List<Transaksi>> getTransaksiByKategori(
      String kategori, String start, String end) async {
    int longStart = DateTime.parse(start).millisecondsSinceEpoch;
    int longEnd = DateTime.parse(end).millisecondsSinceEpoch;

    prefs = await SharedPreferences.getInstance();
    dio.options.headers = {
      "Authorization": "Bearer " + prefs.getString('token') ?? ''
    };
    dio.options.baseUrl = data1.urlTransaksi;

    var response = await dio
        .get('/by-status-and-tanggal/${kategori}/${longStart}/${longEnd}');

    List<dynamic> map = response.data;
    List<Transaksi> listTransaksi = new List();
    for (var i = 0; i < map.length; i++) {
      listTransaksi.add(Transaksi.fromSnapshot(map[i]));
    }

    return listTransaksi;
  }

  void sendData(Transaksi _transaksi) async {
    transaksi = _transaksi;

    if (checkData() && checkData() != null) {
      // print(user.toJsonRegister());
      prefs = await SharedPreferences.getInstance();
      dio.options.headers = {
        "Authorization": "Bearer " + prefs.getString('token') ?? ''
      };
      dio.options.baseUrl = data1.urlTransaksi;
      try {
        var response = await dio.post('', data: transaksi.toJson());
        if (response.statusCode == 200) {
          // If server returns an OK response, parse the JSON
          DialogWidget(context: context, dismiss: true)
              .tampilDialog("Success", "Success to save data..", MainScreen());
        }
      } on DioError catch (e) {
        DialogWidget(context: context, dismiss: true)
            .tampilDialog("Failed", e.message.toString(), () {});
      }
    } else {
      DialogWidget(context: context, dismiss: true)
          .tampilDialog("Failed", "The Data cannot empty!", () {});
    }
  }

  void editData(Transaksi _transaksi) async {
    transaksi = _transaksi;

    if (checkData() && checkData() != null) {
      print(transaksi.toJsonEdit());
      prefs = await SharedPreferences.getInstance();
      dio.options.headers = {
        "Authorization": "Bearer " + prefs.getString('token') ?? ''
      };
      dio.options.baseUrl = data1.urlTransaksi;
      try {
        var response = await dio.put('', data: transaksi.toJsonEdit());
        if (response.statusCode == 200) {
          // If server returns an OK response, parse the JSON
          DialogWidget(context: context, dismiss: true)
              .tampilDialog("Success", "Success to edit data..", MainScreen());
        }
      } on DioError catch (e) {
        DialogWidget(context: context, dismiss: true)
            .tampilDialog("Failed", e.message.toString(), () {});
      }
    } else {
      DialogWidget(context: context, dismiss: true)
          .tampilDialog("Failed", "The Data cannot empty!", () {});
    }
  }

  void hapusData(Transaksi _transaksi) async {
    transaksi = _transaksi;

    if (checkData() && checkData() != null) {
      // print(user.toJsonRegister());
      prefs = await SharedPreferences.getInstance();
      dio.options.headers = {
        "Authorization": "Bearer " + prefs.getString('token') ?? ''
      };
      dio.options.baseUrl = data1.urlTransaksi;
      try {
        var response = await dio.delete('/${transaksi.id}');
        if (response.statusCode == 200) {
          // If server returns an OK response, parse the JSON
          DialogWidget(context: context, dismiss: true)
              .tampilDialog("Success", "Success to delete data..", MainScreen());
        }
      } on DioError catch (e) {
        DialogWidget(context: context, dismiss: true)
            .tampilDialog("Failed", e.message.toString(), () {});
      }
    } else {
      DialogWidget(context: context, dismiss: true)
          .tampilDialog("Failed", "The Data cannot empty!", () {});
    }
  }

  bool checkData() {
    bool result = false;
    if (transaksi != null) {
      if (transaksi.status != null &&
          transaksi.keterangan != null &&
          transaksi.jumlah != null &&
          transaksi.tanggal != null) {
        result = true;
      }
    }
    return result;
  }
}
