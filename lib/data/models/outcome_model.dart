class Outcome {
  final int id;
  final int formInputId;
  final double konsumsiAirPerTahun;
  final String kualitasAir;
  final int rataRataTerpaparPenyakitSebelum;
  final int rataRataTerpaparPenyakitSesudah;
  final String awarenessMasyarakat;
  final String penilaianSaranaAirBersih;
  final String penilaianSanitasi;
  final String deskripsiAwareness;
  final bool? bisaDipakaiMCK;
  final bool? bisaDiminum;
  final bool? ecoKeberlanjutan;
  final int? levelSaranaAirBersih;
  final int? levelSanitasi;

  // Data tambahan untuk perhitungan levelSaranaAirBersih
  final bool? airHanyaUntukMCK;
  final bool? aksesTerbatas;
  final bool? butuhUsahaJarak;
  final bool? airTersediaSetiapSaat;
  final bool? pengelolaanProfesional;
  final bool? aksesMudah;
  final bool? efisiensiAir;
  final bool? ramahLingkungan;
  final bool? keadilanAkses;
  final bool? adaptabilitasSistem;

  // Data tambahan untuk perhitungan levelSanitasi
  final bool? toiletBerfungsi;
  final bool? aksesSanitasiMemadai;
  final bool? eksposurLimbah;
  final bool? limbahDikelolaAman;
  final bool? adaSeptictank;
  final bool? sanitasiBersih;
  final bool? aksesKelompokRentan;
  final bool? rasioMCKMemadai;
  final bool? keberlanjutanEkosistem;
  final bool? pemanfaatanAirEfisien;

  Outcome({
    required this.id,
    required this.formInputId,
    required this.konsumsiAirPerTahun,
    required this.kualitasAir,
    required this.rataRataTerpaparPenyakitSebelum,
    required this.rataRataTerpaparPenyakitSesudah,
    required this.awarenessMasyarakat,
    required this.penilaianSaranaAirBersih,
    required this.penilaianSanitasi,
    required this.deskripsiAwareness,
    this.bisaDipakaiMCK,
    this.bisaDiminum,
    this.ecoKeberlanjutan,
    this.levelSaranaAirBersih,
    this.levelSanitasi,
    this.airHanyaUntukMCK,
    this.aksesTerbatas,
    this.butuhUsahaJarak,
    this.airTersediaSetiapSaat,
    this.pengelolaanProfesional,
    this.aksesMudah,
    this.efisiensiAir,
    this.ramahLingkungan,
    this.keadilanAkses,
    this.adaptabilitasSistem,
    this.toiletBerfungsi,
    this.aksesSanitasiMemadai,
    this.eksposurLimbah,
    this.limbahDikelolaAman,
    this.adaSeptictank,
    this.sanitasiBersih,
    this.aksesKelompokRentan,
    this.rasioMCKMemadai,
    this.keberlanjutanEkosistem,
    this.pemanfaatanAirEfisien,
  });

  factory Outcome.fromJson(Map<String, dynamic> json) {
    return Outcome(
      id: json['id'],
      formInputId: json['formInputId'],
      konsumsiAirPerTahun: json['konsumsiAirPerTahun'].toDouble(),
      kualitasAir: json['kualitasAir'],
      rataRataTerpaparPenyakitSebelum: json['rataRataTerpaparPenyakitSebelum'],
      rataRataTerpaparPenyakitSesudah: json['rataRataTerpaparPenyakitSesudah'],
      awarenessMasyarakat: json['awarenessMasyarakat'],
      penilaianSaranaAirBersih: json['penilaianSaranaAirBersih'],
      penilaianSanitasi: json['penilaianSanitasi'],
      deskripsiAwareness: json['deskripsiAwareness'],
      bisaDipakaiMCK: json['bisaDipakaiMCK'],
      bisaDiminum: json['bisaDiminum'],
      ecoKeberlanjutan: json['ecoKeberlanjutan'],
      levelSaranaAirBersih: json['levelSaranaAirBersih'],
      levelSanitasi: json['levelSanitasi'],
      airHanyaUntukMCK: json['airHanyaUntukMCK'],
      aksesTerbatas: json['aksesTerbatas'],
      butuhUsahaJarak: json['butuhUsahaJarak'],
      airTersediaSetiapSaat: json['airTersediaSetiapSaat'],
      pengelolaanProfesional: json['pengelolaanProfesional'],
      aksesMudah: json['aksesMudah'],
      efisiensiAir: json['efisiensiAir'],
      ramahLingkungan: json['ramahLingkungan'],
      keadilanAkses: json['keadilanAkses'],
      adaptabilitasSistem: json['adaptabilitasSistem'],
      toiletBerfungsi: json['toiletBerfungsi'],
      aksesSanitasiMemadai: json['aksesSanitasiMemadai'],
      eksposurLimbah: json['eksposurLimbah'],
      limbahDikelolaAman: json['limbahDikelolaAman'],
      adaSeptictank: json['adaSeptictank'],
      sanitasiBersih: json['sanitasiBersih'],
      aksesKelompokRentan: json['aksesKelompokRentan'],
      rasioMCKMemadai: json['rasioMCKMemadai'],
      keberlanjutanEkosistem: json['keberlanjutanEkosistem'],
      pemanfaatanAirEfisien: json['pemanfaatanAirEfisien'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'formInputId': formInputId,
      'konsumsiAirPerTahun': konsumsiAirPerTahun,
      'kualitasAir': kualitasAir,
      'rataRataTerpaparPenyakitSebelum': rataRataTerpaparPenyakitSebelum,
      'rataRataTerpaparPenyakitSesudah': rataRataTerpaparPenyakitSesudah,
      'awarenessMasyarakat': awarenessMasyarakat,
      'penilaianSaranaAirBersih': penilaianSaranaAirBersih,
      'penilaianSanitasi': penilaianSanitasi,
      'deskripsiAwareness': deskripsiAwareness,
      'bisaDipakaiMCK': bisaDipakaiMCK,
      'bisaDiminum': bisaDiminum,
      'ecoKeberlanjutan': ecoKeberlanjutan,
      'levelSaranaAirBersih': levelSaranaAirBersih,
      'levelSanitasi': levelSanitasi,
      'airHanyaUntukMCK': airHanyaUntukMCK,
      'aksesTerbatas': aksesTerbatas,
      'butuhUsahaJarak': butuhUsahaJarak,
      'airTersediaSetiapSaat': airTersediaSetiapSaat,
      'pengelolaanProfesional': pengelolaanProfesional,
      'aksesMudah': aksesMudah,
      'efisiensiAir': efisiensiAir,
      'ramahLingkungan': ramahLingkungan,
      'keadilanAkses': keadilanAkses,
      'adaptabilitasSistem': adaptabilitasSistem,
      'toiletBerfungsi': toiletBerfungsi,
      'aksesSanitasiMemadai': aksesSanitasiMemadai,
      'eksposurLimbah': eksposurLimbah,
      'limbahDikelolaAman': limbahDikelolaAman,
      'adaSeptictank': adaSeptictank,
      'sanitasiBersih': sanitasiBersih,
      'aksesKelompokRentan': aksesKelompokRentan,
      'rasioMCKMemadai': rasioMCKMemadai,
      'keberlanjutanEkosistem': keberlanjutanEkosistem,
      'pemanfaatanAirEfisien': pemanfaatanAirEfisien,
    };
  }
}
