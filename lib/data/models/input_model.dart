class FormInput {
  final int id;
  final String lokasi;
  final double lat;
  final double long;
  final String? img;
  final int jmlhBantuan;
  final String jenisBantuan;
  final int jmlhKK;
  final int jmlhMasyarakat;
  final int jmlhPerempuan;
  final int jmlhLaki;
  final String debitAir;
  final String pemakaianAir;
  final String sistemPengelolaan; // 🔥 Ganti dari sanitasi
  final String sumberAir;
  final double hargaAir;
  final double? pH; // 🔥 Tambahan
  final double? TDS; // 🔥 Tambahan
  final double? EC; // 🔥 Tambahan
  final double? ORP; // 🔥 Tambahan
  final int userId;

  FormInput({
    required this.id,
    required this.lokasi,
    required this.lat,
    required this.long,
    this.img,
    required this.jmlhBantuan,
    required this.jenisBantuan,
    required this.jmlhKK,
    required this.jmlhMasyarakat,
    required this.jmlhPerempuan,
    required this.jmlhLaki,
    required this.debitAir,
    required this.pemakaianAir,
    required this.sistemPengelolaan, // 🔥 Perubahan
    required this.sumberAir,
    required this.hargaAir,
    this.pH, // 🔥 Tambahan
    this.TDS, // 🔥 Tambahan
    this.EC, // 🔥 Tambahan
    this.ORP, // 🔥 Tambahan
    required this.userId,
  });

  factory FormInput.fromJson(Map<String, dynamic> json) {
    return FormInput(
      id: json['id'],
      lokasi: json['lokasi'],
      lat: json['lat'].toDouble(),
      long: json['long'].toDouble(),
      img: json['img'],
      jmlhBantuan: json['jmlhBantuan'],
      jenisBantuan: json['jenisBantuan'],
      jmlhKK: json['jmlhKK'],
      jmlhMasyarakat: json['jmlhMasyarakat'],
      jmlhPerempuan: json['jmlhPerempuan'],
      jmlhLaki: json['jmlhLaki'],
      debitAir: json['debitAir'],
      pemakaianAir: json['pemakaianAir'],
      sistemPengelolaan: json['sistemPengelolaan'], // 🔥 Perubahan
      sumberAir: json['sumberAir'],
      hargaAir: json['hargaAir'].toDouble(),
      pH: json['pH'] != null ? json['pH'].toDouble() : null, // 🔥 Tambahan
      TDS: json['TDS'] != null ? json['TDS'].toDouble() : null, // 🔥 Tambahan
      EC: json['EC'] != null ? json['EC'].toDouble() : null, // 🔥 Tambahan
      ORP: json['ORP'] != null ? json['ORP'].toDouble() : null, // 🔥 Tambahan
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lokasi': lokasi,
      'lat': lat,
      'long': long,
      'img': img,
      'jmlhBantuan': jmlhBantuan,
      'jenisBantuan': jenisBantuan,
      'jmlhKK': jmlhKK,
      'jmlhMasyarakat': jmlhMasyarakat,
      'jmlhPerempuan': jmlhPerempuan,
      'jmlhLaki': jmlhLaki,
      'debitAir': debitAir,
      'pemakaianAir': pemakaianAir,
      'sistemPengelolaan': sistemPengelolaan, // 🔥 Perubahan
      'sumberAir': sumberAir,
      'hargaAir': hargaAir,
      'pH': pH, // 🔥 Tambahan
      'TDS': TDS, // 🔥 Tambahan
      'EC': EC, // 🔥 Tambahan
      'ORP': ORP, // 🔥 Tambahan
      'userId': userId,
    };
  }
}
