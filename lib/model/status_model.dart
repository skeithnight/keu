class Status {
  int saldo;
  int k1;
  int k2;
  int k3;

  Status();

  Status.fromSnapshot(Map<dynamic, dynamic> snapshot)
      : saldo = snapshot["saldo"],
        k1 = snapshot["k1"],
        k2 = snapshot["k2"],
        k3 = snapshot["k3"];
}
