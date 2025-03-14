import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moneva/data/providers/outcome_provider.dart';

class EditOutcomePage extends StatefulWidget {
  final int formId;
  final String jenisBantuan;

  const EditOutcomePage({Key? key, required this.formId, required this.jenisBantuan}) : super(key: key);

  @override
  _EditOutcomePageState createState() => _EditOutcomePageState();
}

class _EditOutcomePageState extends State<EditOutcomePage> {
  final _formKey = GlobalKey<FormState>();
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

  @override
  void initState() {
    super.initState();
    // Tidak memanggil createOutcome di initState, akan dipanggil ketika tombol ditekan
  }

  // Fungsi untuk membuat text field (input angka/teks)
  Widget _buildTextField(String key, String label, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        initialValue: outcomeData[key]?.toString() ?? '',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buat Outcome Baru ID: ${widget.formId}")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
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
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 16),
                            
                            // Section: Pertanyaan Umum (selalu tampil)
                            Text("Pertanyaan Umum",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            SizedBox(height: 8),
                            _buildTextField('konsumsiAirPerTahun', 'Konsumsi Air per Tahun (liter)', isNumeric: true),
                            // Kualitas Air diubah menjadi checkbox
                            _buildCheckbox('kualitasAir', 'Kualitas air sudah sesuai kebutuhan?'),
                            _buildTextField('rataRataTerpaparPenyakitSebelum', 'Rata-rata Terpapar Penyakit Sebelum', isNumeric: true),
                            _buildTextField('rataRataTerpaparPenyakitSesudah', 'Rata-rata Terpapar Penyakit Sesudah', isNumeric: true),
                            SizedBox(height: 16),
                            
                            // Section: Data untuk SAB (hanya jika jenis bantuan mengandung "SAB")
                            if (widget.jenisBantuan.contains('SAB')) ...[
                              Text("Data untuk SAB",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              SizedBox(height: 8),
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
                              SizedBox(height: 16),
                            ],
                            
                            // Section: Data untuk MCK (hanya jika jenis bantuan mengandung "MCK")
                            if (widget.jenisBantuan.contains('MCK')) ...[
                              Text("Data untuk MCK",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              SizedBox(height: 8),
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
                              SizedBox(height: 16),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          debugPrint("Data outcome sebelum dikirim: $outcomeData");
                          setState(() => isLoading = true);
                          
                          Provider.of<OutcomeProvider>(context, listen: false)
                              .createOutcome(widget.formId, outcomeData)
                              .then((success) {
                            setState(() => isLoading = false);
                            if (success) {
                              debugPrint("Outcome berhasil dibuat.");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Outcome berhasil dibuat')),
                              );
                              Navigator.pop(context);
                            } else {
                              final error = Provider.of<OutcomeProvider>(context, listen: false).errorMessage;
                              debugPrint("Outcome gagal dibuat. Error: $error");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Gagal membuat Outcome')),
                              );
                            }
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Simpan Outcome Baru'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
