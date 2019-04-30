class User {
  String id;
  String email;
  String password;
  String nama;
  String fcmtoken;
  int saldo;

  User();

  User.fromSnapshot(Map<dynamic, dynamic> snapshot)
      : id = snapshot["id"],
        email = snapshot["email"],
        password = snapshot["password"],
        nama = snapshot["nama"],
        fcmtoken = snapshot["fcmtoken"],
        saldo = snapshot["saldo"];

  Map<String, dynamic> toJsonRegister() => {
        "email": email,
        "password": password,
        "nama": nama,
        "fcmtoken": fcmtoken,
      };
  Map<String, dynamic> toJsonLogin() => {
        "email": email,
        "password": password,
      };
}
