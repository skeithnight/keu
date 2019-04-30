import 'service_model.dart';
import 'user_model.dart';
import 'customer_model.dart';
import 'detail_transaksi_model.dart';

class Order {
  String id;
  Customer customer;
  User user;
  String address;
  double latitude;
  double longitude;
  List<DetailTransaksi> produk;
  int tanggal;
  String note;
  String status;

  Order();

  Order.fromSnapshot(
      Map<dynamic, dynamic> snapshot,
      List<DetailTransaksi> produk)
      : id = snapshot["id"],
        customer = snapshot["customer"] == null
            ? null
            : Customer.fromSnapshot(snapshot["customer"]),
        user = snapshot["user"] == null
            ? null
            : User.fromSnapshot(snapshot["user"]),
        address = snapshot["address"],
        latitude = snapshot["latitude"],
        longitude = snapshot["longitude"],
        this.produk = produk,
        tanggal = snapshot["tanggal"],
        note = snapshot["note"],
        status = snapshot["status"];
  Map<String, dynamic> toJsonChangeStatus(
          String idCourier, String statusEdit) =>
      {
        "id": id,
        "customer": {"id": customer.id},
        "user": {"id": user.id},
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "tanggal": tanggal,
        "note": note,
        "status": statusEdit,
      };
}
