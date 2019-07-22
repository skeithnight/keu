import 'user_model.dart';
import 'package:intl/intl.dart';

class Transaksi {
  String id;
  User user;
  String tanggal;
  String status;
  String kategori;
  int jumlah;
  String keterangan;

  Transaksi();

  Transaksi.fromSnapshot(Map<dynamic, dynamic> snapshot)
      : id = snapshot["id"],
        user = User.fromSnapshot(snapshot["user"]),
        tanggal = snapshot["tanggal"],
        status = snapshot["status"],
        kategori = snapshot["kategori"],
        jumlah = snapshot["jumlah"],
        keterangan = snapshot["keterangan"];

  Transaksi.fromString(String _id) : id = _id;

  Map<String, dynamic> toJson() => {
        "tanggal": tanggal,
        "keterangan": keterangan,
        "status": status,
        "kategori": kategori,
        "jumlah": jumlah,
      };
  Map<String, dynamic> toJsonEdit() => {
        "id": id,
        "tanggal": tanggal,
        "keterangan": keterangan,
        "status": status,
        "kategori": kategori,
        "jumlah": jumlah,
      };
}
