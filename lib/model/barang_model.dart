class Barang {
  String id;
  String ecommerce;
  String url;
  String judul;
  int harga;
  int stok;
  List<dynamic> gambar;

  Barang();

  Barang.fromSnapshot(Map<dynamic, dynamic> snapshot)
      : id = snapshot["id"],
        ecommerce = snapshot["ecommerce"],
        url = snapshot["url"],
        judul = snapshot["judul"],
        harga = snapshot["harga"],
        stok = snapshot["stok"],
        gambar = snapshot["gambar"];
}
