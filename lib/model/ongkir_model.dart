class Ongkir {
  String nama;
  String keterangan;
  int biaya;

  Ongkir();

  Ongkir.fromSnapshot(Map<dynamic, dynamic> snapshot)
      : nama = snapshot["nama"],
        keterangan = snapshot["keterangan"],
        biaya = snapshot["biaya"];
}
