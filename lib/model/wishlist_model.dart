import 'barang_model.dart';
import 'user_model.dart';

class WishList {
  String id;
  User user;
  bool cariRekomendasi;
  String nama;
  String kategori;
  List<dynamic> rekomendasiid;
  List<Barang> rekomendasi;

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

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "cariRekomendasi": cariRekomendasi,
        "nama": nama,
        "kategori": kategori,
        "rekomendasiid": rekomendasiid,
        "rekomendasi": rekomendasi,
      };

  Map<String, dynamic> toJsonWishList() => {
        "cariRekomendasi": cariRekomendasi,
        "nama": nama,
        "kategori": kategori,
      };
}
