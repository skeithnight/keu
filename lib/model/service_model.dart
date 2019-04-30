import 'user_model.dart';

class Service {
  String idApotek;
  String id;
  User user;
  String nama;
  int harga;

  Service();
  

  Service.fromSnapshot(Map<dynamic, dynamic> snapshot) {
    id = snapshot["id"];
    user = User.fromSnapshot(snapshot["user"]);
    nama = snapshot["nama"];
    harga = snapshot["harga"];
  }

  Map<String, dynamic> toJsonInsert() => {
        "user": {
          "id": idApotek,
        },
        "nama": nama,
        "harga": harga,
      };
}
