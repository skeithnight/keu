import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import 'package:keu/data.dart' as data1;
// import 'package:keu/model/courier_model.dart';
import 'package:keu/screen/widget/dialog_widget.dart';
import 'package:keu/screen/main_screen.dart';
import 'package:keu/model/obat_model.dart';
class ProductController {
  SharedPreferences prefs;
  BuildContext context;
  ProductController(this.context);
  Dio dio = new Dio();

  Future<String> getToken() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  // Obat
  Future<List<Obat>> getDataObat() async {
    prefs = await SharedPreferences.getInstance();
    dio.options.headers = {
      "Authorization": "Bearer " + prefs.getString('token') ?? ''
    };
    dio.options.baseUrl = data1.urlObat;

    var response = await dio.get('/apotek/${prefs.getString('idApotek')}');

    log('data: ${prefs.getString('idApotek')}');
    List<dynamic> map = response.data;
    List<Obat> listObat = new List();
    for (var i = 0; i < map.length; i++) {
      listObat.add(Obat.fromSnapshot(map[i]));
    }
    log('data: ${prefs.getString('idApotek')}');

    return listObat;
  }
  void sendDataObat(Obat obat) async {
    if (checkDataObat(obat)) {
      getToken().then((onValue) {
        insertDataObat(obat, onValue);
      });
    } else {
      DialogWidget(context: context, dismiss: true)
          .tampilDialog("Failed", "The Data cannot empty!", () {});
    }
  }

  void insertDataObat(Obat obat, String token) async {
    prefs = await SharedPreferences.getInstance();
    obat.idApotek = prefs.getString("idApotek");
    // print(obat.toJsonInsert());
    // print(token);
    // print(data1.urlObat);
    dio.options.headers["Authorization"] = {"Bearer " + token};
    dio.options.headers["Content-Type"] = {"application/json"};
    dio.options.data = obat.toJsonInsert();
    dio.options.baseUrl = data1.urlObat;

    var response = await dio.post('');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      DialogWidget(context: context, dismiss: true)
          .tampilDialog("Success", "Success on saving data...", MainScreen());
    } else {
      // If that response was not OK, throw an error.
      DialogWidget(context: context, dismiss: true)
          .tampilDialog("Failed", "Error on saving data", () {});
    }
  }

  bool checkDataObat(Obat obat) {
    if (obat.nama == null ||
        obat.harga == null) {
      return false;
    }
    return true;
  }

}
