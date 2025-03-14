class Dampak {
  final int id;
  final int formInputId;
  final double biayaBerobatSebelum;
  final double biayaBerobatSesudah;
  final double biayaAirBersihSebelum;
  final double biayaAirBersihSesudah;
  final double peningkatanEkonomiSebelum;
  final double peningkatanEkonomiSesudah;
  final int penurunanOrangSakitSebelum;
  final int penurunanOrangSakitSesudah;
  final int penurunanStuntingSebelum;
  final int penurunanStuntingSesudah;
  final double peningkatanIndeksKesehatanSebelum;
  final double peningkatanIndeksKesehatanSesudah;
  final double volumeLimbahDikelola;
  final bool prosesKonservasiAir;
  final double penurunanIndexPencemaranSebelum;
  final double penurunanIndexPencemaranSesudah;
  final String sumberAirSebelum;
  final String sumberAirSesudah;
  final double biayaListrikSebelum;
  final double biayaListrikSesudah;

  Dampak({
    required this.id,
    required this.formInputId,
    required this.biayaBerobatSebelum,
    required this.biayaBerobatSesudah,
    required this.biayaAirBersihSebelum,
    required this.biayaAirBersihSesudah,
    required this.peningkatanEkonomiSebelum,
    required this.peningkatanEkonomiSesudah,
    required this.penurunanOrangSakitSebelum,
    required this.penurunanOrangSakitSesudah,
    required this.penurunanStuntingSebelum,
    required this.penurunanStuntingSesudah,
    required this.peningkatanIndeksKesehatanSebelum,
    required this.peningkatanIndeksKesehatanSesudah,
    required this.volumeLimbahDikelola,
    required this.prosesKonservasiAir,
    required this.penurunanIndexPencemaranSebelum,
    required this.penurunanIndexPencemaranSesudah,
    required this.sumberAirSebelum,
    required this.sumberAirSesudah,
    required this.biayaListrikSebelum,
    required this.biayaListrikSesudah,
  });
}
