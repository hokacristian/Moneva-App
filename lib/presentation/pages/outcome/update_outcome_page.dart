import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moneva/data/providers/outcome_provider.dart';

class UpdateOutcomePage extends StatefulWidget {
  final int outcomeId;
  final String jenisBantuan;

  const UpdateOutcomePage({
    Key? key,
    required this.outcomeId,
    required this.jenisBantuan,
  }) : super(key: key);

  @override
  _UpdateOutcomePageState createState() => _UpdateOutcomePageState();
}

class _UpdateOutcomePageState extends State<UpdateOutcomePage> {
  final _formKey = GlobalKey<FormState>();

  // Data outcome yang akan di-edit
  Map<String, dynamic> outcomeData = {
    // Pertanyaan Umum (selalu tampil)
    "konsumsiAirPerTahun": "",
    "kualitasAir": false, // ditampilkan sebagai checkbox
    "rataRataTerpaparPenyakitSebelum": "",
    "rataRataTerpaparPenyakitSesudah": "",
    
    // Data boolean umum
    "bisaDipakaiMCK": false,
    "bisaDiminum": false,
    "ecoKeberlanjutan": false,
    
    // Data untuk SAB
    "airHanyaUntukMCK": false,
    "aksesTerbatas": false,
    "butuhUsahaJarak": false,
    "airTersediaSetiapSaat": false,
    "pengelolaanProfesional": false,
    "aksesMudah": false,
    "efisiensiAir": false,
    "ramahLingkungan": false,
    "keadilanAkses": false,
    "adaptabilitasSistem": false,
    
    // Data untuk MCK
    "toiletBerfungsi": false,
    "aksesSanitasiMemadai": false,
    "eksposurLimbah": false,
    "limbahDikelolaAman": false,
    "adaSeptictank": false,
    "sanitasiBersih": false,
    "aksesKelompokRentan": false,
    "rasioMCKMemadai": false,
    "keberlanjutanEkosistem": false,
    "pemanfaatanAirEfisien": false,
  };

  bool isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Panggil _fetchOutcomeData setelah build widget selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOutcomeData();
    });
  }

  Future<void> _fetchOutcomeData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final outcomeProvider =
          Provider.of<OutcomeProvider>(context, listen: false);
      await outcomeProvider.fetchOutcome(widget.outcomeId);
      final outcome = outcomeProvider.outcome;
      if (outcome != null) {
        setState(() {
          outcomeData["konsumsiAirPerTahun"] =
              outcome["konsumsiAirPerTahun"]?.toString() ?? "";
          outcomeData["kualitasAir"] = outcome["kualitasAir"] as bool? ?? false;
          outcomeData["rataRataTerpaparPenyakitSebelum"] =
              outcome["rataRataTerpaparPenyakitSebelum"]?.toString() ?? "";
          outcomeData["rataRataTerpaparPenyakitSesudah"] =
              outcome["rataRataTerpaparPenyakitSesudah"]?.toString() ?? "";
          outcomeData["bisaDipakaiMCK"] =
              outcome["bisaDipakaiMCK"] as bool? ?? false;
          outcomeData["bisaDiminum"] =
              outcome["bisaDiminum"] as bool? ?? false;
          outcomeData["ecoKeberlanjutan"] =
              outcome["ecoKeberlanjutan"] as bool? ?? false;
          // Untuk SAB
          outcomeData["airHanyaUntukMCK"] =
              outcome["airHanyaUntukMCK"] as bool? ?? false;
          outcomeData["aksesTerbatas"] =
              outcome["aksesTerbatas"] as bool? ?? false;
          outcomeData["butuhUsahaJarak"] =
              outcome["butuhUsahaJarak"] as bool? ?? false;
          outcomeData["airTersediaSetiapSaat"] =
              outcome["airTersediaSetiapSaat"] as bool? ?? false;
          outcomeData["pengelolaanProfesional"] =
              outcome["pengelolaanProfesional"] as bool? ?? false;
          outcomeData["aksesMudah"] =
              outcome["aksesMudah"] as bool? ?? false;
          outcomeData["efisiensiAir"] =
              outcome["efisiensiAir"] as bool? ?? false;
          outcomeData["ramahLingkungan"] =
              outcome["ramahLingkungan"] as bool? ?? false;
          outcomeData["keadilanAkses"] =
              outcome["keadilanAkses"] as bool? ?? false;
          outcomeData["adaptabilitasSistem"] =
              outcome["adaptabilitasSistem"] as bool? ?? false;
          // Untuk MCK
          outcomeData["toiletBerfungsi"] =
              outcome["toiletBerfungsi"] as bool? ?? false;
          outcomeData["aksesSanitasiMemadai"] =
              outcome["aksesSanitasiMemadai"] as bool? ?? false;
          outcomeData["eksposurLimbah"] =
              outcome["eksposurLimbah"] as bool? ?? false;
          outcomeData["limbahDikelolaAman"] =
              outcome["limbahDikelolaAman"] as bool? ?? false;
          outcomeData["adaSeptictank"] =
              outcome["adaSeptictank"] as bool? ?? false;
          outcomeData["sanitasiBersih"] =
              outcome["sanitasiBersih"] as bool? ?? false;
          outcomeData["aksesKelompokRentan"] =
              outcome["aksesKelompokRentan"] as bool? ?? false;
          outcomeData["rasioMCKMemadai"] =
              outcome["rasioMCKMemadai"] as bool? ?? false;
          outcomeData["keberlanjutanEkosistem"] =
              outcome["keberlanjutanEkosistem"] as bool? ?? false;
          outcomeData["pemanfaatanAirEfisien"] =
              outcome["pemanfaatanAirEfisien"] as bool? ?? false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Gagal mengambil data outcome.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk membuat text field (input angka/teks)
  Widget _buildTextField(String key, String label, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: outcomeData[key]?.toString() ?? '',
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType:
            isNumeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        onChanged: (value) {
          setState(() {
            if (isNumeric) {
              outcomeData[key] = key.contains('konsumsi')
                  ? double.tryParse(value) ?? 0.0
                  : int.tryParse(value) ?? 0;
            } else {
              outcomeData[key] = value;
            }
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Harap isi $label";
          }
          if (isNumeric && double.tryParse(value) == null) {
            return "Harap masukkan angka yang valid";
          }
          return null;
        },
      ),
    );
  }

  // Fungsi untuk membuat checkbox
  Widget _buildCheckbox(String key, String label) {
    return CheckboxListTile(
      title: Text(label),
      value: outcomeData[key] ?? false,
      onChanged: (bool? value) {
        setState(() {
          outcomeData[key] = value ?? false;
        });
      },
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      _errorMessage = null;
    });

    // Siapkan data yang akan dipatch
    final patchData = {
      "konsumsiAirPerTahun": double.tryParse(outcomeData["konsumsiAirPerTahun"].toString()) ?? 0.0,
      "kualitasAir": outcomeData["kualitasAir"],
      "rataRataTerpaparPenyakitSebelum": int.tryParse(outcomeData["rataRataTerpaparPenyakitSebelum"].toString()) ?? 0,
      "rataRataTerpaparPenyakitSesudah": int.tryParse(outcomeData["rataRataTerpaparPenyakitSesudah"].toString()) ?? 0,
      "bisaDipakaiMCK": outcomeData["bisaDipakaiMCK"],
      "bisaDiminum": outcomeData["bisaDiminum"],
      "ecoKeberlanjutan": outcomeData["ecoKeberlanjutan"],
    };

    // Jika jenis bantuan mengandung 'SAB', tambahkan data SAB
    if (widget.jenisBantuan.contains('SAB')) {
      patchData.addAll({
        "airHanyaUntukMCK": outcomeData["airHanyaUntukMCK"],
        "aksesTerbatas": outcomeData["aksesTerbatas"],
        "butuhUsahaJarak": outcomeData["butuhUsahaJarak"],
        "airTersediaSetiapSaat": outcomeData["airTersediaSetiapSaat"],
        "pengelolaanProfesional": outcomeData["pengelolaanProfesional"],
        "aksesMudah": outcomeData["aksesMudah"],
        "efisiensiAir": outcomeData["efisiensiAir"],
        "ramahLingkungan": outcomeData["ramahLingkungan"],
        "keadilanAkses": outcomeData["keadilanAkses"],
        "adaptabilitasSistem": outcomeData["adaptabilitasSistem"],
      });
    }

    // Jika jenis bantuan mengandung 'MCK', tambahkan data MCK
    if (widget.jenisBantuan.contains('MCK')) {
      patchData.addAll({
        "toiletBerfungsi": outcomeData["toiletBerfungsi"],
        "aksesSanitasiMemadai": outcomeData["aksesSanitasiMemadai"],
        "eksposurLimbah": outcomeData["eksposurLimbah"],
        "limbahDikelolaAman": outcomeData["limbahDikelolaAman"],
        "adaSeptictank": outcomeData["adaSeptictank"],
        "sanitasiBersih": outcomeData["sanitasiBersih"],
        "aksesKelompokRentan": outcomeData["aksesKelompokRentan"],
        "rasioMCKMemadai": outcomeData["rasioMCKMemadai"],
        "keberlanjutanEkosistem": outcomeData["keberlanjutanEkosistem"],
        "pemanfaatanAirEfisien": outcomeData["pemanfaatanAirEfisien"],
      });
    }

    try {
      final outcomeProvider =
          Provider.of<OutcomeProvider>(context, listen: false);
      await outcomeProvider.updateOutcome(widget.outcomeId, patchData);
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = "Terjadi kesalahan saat mengupdate outcome.";
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Outcome ID: ${widget.outcomeId}"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Jenis Bantuan: ${widget.jenisBantuan}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 16),
                            // Section: Pertanyaan Umum (selalu tampil)
                            const Text("Pertanyaan Umum",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 8),
                            _buildTextField('konsumsiAirPerTahun',
                                'Konsumsi Air per Tahun (liter)',
                                isNumeric: true),
                            _buildCheckbox('kualitasAir',
                                'Kualitas air sudah sesuai kebutuhan?'),
                            _buildTextField('rataRataTerpaparPenyakitSebelum',
                                'Rata-rata Terpapar Penyakit Sebelum',
                                isNumeric: true),
                            _buildTextField('rataRataTerpaparPenyakitSesudah',
                                'Rata-rata Terpapar Penyakit Sesudah',
                                isNumeric: true),
                            const SizedBox(height: 16),
                            // Section: Data untuk SAB (hanya tampil jika jenis bantuan mengandung "SAB")
                            if (widget.jenisBantuan.contains('SAB')) ...[
                              const Text("Data untuk SAB",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 8),
                              _buildCheckbox('airHanyaUntukMCK', 'Air hanya untuk MCK'),
                              _buildCheckbox('aksesTerbatas', 'Akses terbatas'),
                              _buildCheckbox('butuhUsahaJarak', 'Butuh usaha jarak'),
                              _buildCheckbox('airTersediaSetiapSaat', 'Air tersedia setiap saat'),
                              _buildCheckbox('pengelolaanProfesional', 'Pengelolaan profesional'),
                              _buildCheckbox('aksesMudah', 'Akses mudah'),
                              _buildCheckbox('efisiensiAir', 'Efisiensi air'),
                              _buildCheckbox('ramahLingkungan', 'Ramah lingkungan'),
                              _buildCheckbox('keadilanAkses', 'Keadilan akses'),
                              _buildCheckbox('adaptabilitasSistem', 'Adaptabilitas sistem'),
                              const SizedBox(height: 16),
                            ],
                            // Section: Data untuk MCK (hanya tampil jika jenis bantuan mengandung "MCK")
                            if (widget.jenisBantuan.contains('MCK')) ...[
                              const Text("Data untuk MCK",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 8),
                              _buildCheckbox('toiletBerfungsi', 'Toilet berfungsi'),
                              _buildCheckbox('aksesSanitasiMemadai', 'Akses sanitasi memadai'),
                              _buildCheckbox('eksposurLimbah', 'Eksposur limbah'),
                              _buildCheckbox('limbahDikelolaAman', 'Limbah dikelola aman'),
                              _buildCheckbox('adaSeptictank', 'Ada septictank'),
                              _buildCheckbox('sanitasiBersih', 'Sanitasi bersih'),
                              _buildCheckbox('aksesKelompokRentan', 'Akses kelompok rentan'),
                              _buildCheckbox('rasioMCKMemadai', 'Rasio MCK memadai'),
                              _buildCheckbox('keberlanjutanEkosistem', 'Keberlanjutan ekosistem'),
                              _buildCheckbox('pemanfaatanAirEfisien', 'Pemanfaatan air efisien'),
                              const SizedBox(height: 16),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                    ],
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text("Update Outcome"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
