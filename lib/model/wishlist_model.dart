import 'barang_model.dart';
import 'user_model.dart';
import 'transaksi_model.dart';

class WishList {
  String id;
  User user;
  bool cariRekomendasi;
  String nama;
  String kategori;
  List<dynamic> rekomendasiid;
  List<Barang> rekomendasi;
  List<Transaksi> transaksi;

  WishList();

  WishList.fromSnapshot(Map<dynamic, dynamic> snapshot) {
    id = snapshot["id"];
    user = User.fromSnapshot(snapshot["user"]);
    cariRekomendasi = snapshot["cariRekomendasi"];
    nama = snapshot["nama"];
    kategori = snapshot["kategori"];
    rekomendasiid = snapshot["rekomendasiid"];
    var list = snapshot['rekomendasi'] as List;
    rekomendasi = list.map((i) => Barang.fromSnapshot(i)).toList();
  }

  WishList.fromSnapshotKeb(Map<dynamic, dynamic> snapshot) {
    id = snapshot["id"];
    user = User.fromSnapshot(snapshot["user"]);
    cariRekomendasi = snapshot["cariRekomendasi"];
    nama = snapshot["nama"];
    kategori = snapshot["kategori"];
    rekomendasiid = snapshot["rekomendasiid"];
    var list = snapshot['rekomendasi'] as List;
    var listTran = snapshot['transaksi'] as List;
    rekomendasi = list.map((i) => Barang.fromSnapshot(i)).toList();
    transaksi = listTran.map((i) => Transaksi.fromSnapshot(i)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "cariRekomendasi": cariRekomendasi,
        "nama": nama,
        "kategori": kategori,
        "rekomendasiid": rekomendasiid,
        "rekomendasi": rekomendasi,
        "transaksi": transaksi,
      };

  Map<String, dynamic> toJsonWishList() => {
        "cariRekomendasi": cariRekomendasi,
        "nama": nama,
        "kategori": kategori,
      };

  Map<String, dynamic> toJsonKeb() => {
        "cariRekomendasi": cariRekomendasi,
        "nama": nama,
        "kategori": kategori,
        "transaksi": [
          {"id": transaksi[0].id}
        ],
      };
}
