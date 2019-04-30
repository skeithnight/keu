import 'service_model.dart';
import 'user_model.dart';

class Obat extends Service {
  Obat();
  Obat.fromSnapshot(Map<dynamic, dynamic> snapshot) {
    id = snapshot["id"];
    user = User.fromSnapshot(snapshot["user"]);
    nama = snapshot["nama"];
    harga = snapshot["harga"];
  }
}
