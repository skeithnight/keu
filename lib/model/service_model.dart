import 'apotek_model.dart';

class Service {
  String idApotek;
  String id;
  Apotek apotek;
  String nama;
  int harga;

  Service();
  

  Service.fromSnapshot(Map<dynamic, dynamic> snapshot) {
    id = snapshot["id"];
    apotek = Apotek.fromSnapshot(snapshot["apotek"]);
    nama = snapshot["nama"];
    harga = snapshot["harga"];
  }

  Map<String, dynamic> toJsonInsert() => {
        "apotek": {
          "id": idApotek,
        },
        "nama": nama,
        "harga": harga,
      };
}
