import 'ongkir_model.dart';

class Barang {
  String id;
  String ecommerce;
  String url;
  String judul;
  int harga;
  int stok;
  List<dynamic> gambar;
  List<Ongkir> ongkir;

  Barang();

  Barang.fromSnapshot(Map<dynamic, dynamic> snapshot) {
    id = snapshot["id"];
    ecommerce = snapshot["ecommerce"];
    url = snapshot["url"];
    judul = snapshot["judul"];
    harga = snapshot["harga"];
    stok = snapshot["stok"];
    gambar = snapshot["gambar"];
    var list = snapshot['ongkir'] as List;
    ongkir = list.map((i) => Ongkir.fromSnapshot(i)).toList();
  }
}
