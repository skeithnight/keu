class Apotek {
  String id;
  String username;
  String noIjin;
  String password;
  String name;
  String address;
  double latitude;
  double longitude;
  bool enabled;

  Apotek();

  Apotek.fromSnapshot(Map<dynamic, dynamic> snapshot)
      : id = snapshot["id"],
        username = snapshot["username"],
        noIjin = snapshot["noIjin"],
        name = snapshot["name"],
        address = snapshot["address"],
        latitude = snapshot["latitude"],
        longitude = snapshot["longitude"],
        enabled = snapshot["enabled"];

  Map<String, dynamic> toJsonRegister() => {
        "noIjin": noIjin,
        "username": username,
        "password": password,
        "name": name,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "enabled": true,
      };
  Map<String, dynamic> toJsonLogin() => {
        "username": username,
        "password": password,
      };
}
