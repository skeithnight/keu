import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:keu/model/order_model.dart';

import 'package:keu/data.dart' as data1;
import 'package:keu/screen/widget/dialog_widget.dart';
import 'package:keu/main.dart';
import 'package:keu/model/detail_transaksi_model.dart';

class OrderController {
  SharedPreferences prefs;

  BuildContext context;
  OrderController(this.context);

  Dio dio = new Dio();
  // Get Data
  Future<List<Order>> getListData() async {
    prefs = await SharedPreferences.getInstance();
    dio.options.headers = {
      "Authorization": "Bearer " + prefs.getString('token') ?? ''
    };
    dio.options.baseUrl = data1.urlOrder;

    var response = await dio.get('/apotek/${prefs.getString('idApotek')}');
    List<dynamic> map = response.data;
    // print(map[0]['groomings']);
    List<Order> listOrder = new List();
    List<DetailTransaksi> listProduks = new List();
    for (var i = 0; i < map.length; i++) {
      for (var j = 0; j < map[i]['produk'].length; j++) {
        listProduks.add(DetailTransaksi.fromSnapshot(map[i]['produk'][j]));
      }
      listOrder.add(
          Order.fromSnapshot(map[i], listProduks));
    }
    return listOrder;
  }
}
