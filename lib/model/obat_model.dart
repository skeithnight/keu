import 'service_model.dart';
import 'apotek_model.dart';

class Obat extends Service {
  Obat();
  Obat.fromSnapshot(Map<dynamic, dynamic> snapshot) {
    id = snapshot["id"];
    apotek = Apotek.fromSnapshot(snapshot["apotek"]);
    nama = snapshot["nama"];
    harga = snapshot["harga"];
  }
}
