import 'service_model.dart';
import 'apotek_model.dart';
import 'customer_model.dart';

class DetailTransaksi {
  Service service;
  int jumlah;
  DetailTransaksi();

  DetailTransaksi.fromSnapshot(Map<dynamic, dynamic> snapshot)
      : service = snapshot["produk"] == null
            ? null
            : Service.fromSnapshot(snapshot["produk"]),
        jumlah = snapshot["jumlah"];
}
