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
    // Data umum
    "konsumsiAirPerTahun": 0.0,
    "kualitasAir": "",
    "rataRataTerpaparPenyakitSebelum": 0,
    "rataRataTerpaparPenyakitSesudah": 0,
    "awarenessMasyarakat": "",
    "deskripsiAwareness": "",
    "penilaianSaranaAirBersih": "",
    "penilaianSanitasi": "",
    
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
  // Hapus pemanggilan createOutcome dari sini
  // Future.microtask(() {
  //   setState(() => isLoading = true);
  //   Provider.of<OutcomeProvider>(context, listen: false)
  //       .createOutcome(widget.formId, outcomeData)
  //       .then((_) => setState(() => isLoading = false));
  // });
}

  // Fungsi untuk menampilkan form field tipe string/numerik
  Widget _buildTextField(String key, String label, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        initialValue: isNumeric ? 
          (outcomeData[key] != null ? outcomeData[key].toString() : '0') : 
          (outcomeData[key] ?? ''),
        onChanged: (value) {
          setState(() {
            if (isNumeric) {
              outcomeData[key] = key.contains('konsumsi') ? 
                double.tryParse(value) ?? 0.0 : 
                int.tryParse(value) ?? 0;
            } else {
              outcomeData[key] = value;
            }
          });
        },
      ),
    );
  }

  // Fungsi untuk menampilkan checkbox
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
  
  // Fungsi untuk memeriksa apakah field harus ditampilkan berdasarkan jenis bantuan
  bool _shouldShowField(String key) {
    final String jenisBantuan = widget.jenisBantuan;
    
    // Jika SAB & MCK, tampilkan semua field
    if (jenisBantuan.contains('SAB') && jenisBantuan.contains('MCK')) {
      return true;
    }
    
    // Field khusus MCK yang tidak ditampilkan jika jenis bantuan hanya SAB
    final mckOnlyFields = [
      'aksesKelompokRentan', 'rasioMCKMemadai', 'keberlanjutanEkosistem', 
      'pemanfaatanAirEfisien', 'limbahDikelolaAman', 'adaSeptictank', 
      'sanitasiBersih', 'toiletBerfungsi', 'aksesSanitasiMemadai', 'eksposurLimbah'
    ];
    
    // Field khusus SAB yang tidak ditampilkan jika jenis bantuan hanya MCK
    final sabOnlyFields = [
      'efisiensiAir', 'ramahLingkungan', 'keadilanAkses', 'adaptabilitasSistem',
      'airTersediaSetiapSaat', 'bisaDiminum', 'pengelolaanProfesional', 'aksesMudah',
      'airHanyaUntukMCK', 'aksesTerbatas', 'butuhUsahaJarak', 'bisaDiminum', 
      'bisaDipakaiMCK', 'ecoKeberlanjutan'
    ];
    
    if (jenisBantuan.contains('SAB') && !jenisBantuan.contains('MCK')) {
      return !mckOnlyFields.contains(key);
    }
    
    if (jenisBantuan.contains('MCK') && !jenisBantuan.contains('SAB')) {
      return !sabOnlyFields.contains(key);
    }
    
    // Default: tampilkan semua field
    return true;
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
                          
                          // Data umum - selalu ditampilkan
                          Text("Data Umum", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(height: 8),
                          
                          if (_shouldShowField('konsumsiAirPerTahun'))
                            _buildTextField('konsumsiAirPerTahun', 'Konsumsi Air per Tahun (liter)', isNumeric: true),
                            
                          if (_shouldShowField('kualitasAir'))
                            _buildTextField('kualitasAir', 'Kualitas Air'),
                            
                          if (_shouldShowField('rataRataTerpaparPenyakitSebelum'))
                            _buildTextField('rataRataTerpaparPenyakitSebelum', 'Rata-rata Terpapar Penyakit Sebelum', isNumeric: true),
                            
                          if (_shouldShowField('rataRataTerpaparPenyakitSesudah'))
                            _buildTextField('rataRataTerpaparPenyakitSesudah', 'Rata-rata Terpapar Penyakit Sesudah', isNumeric: true),
                            
                          if (_shouldShowField('awarenessMasyarakat'))
                            _buildTextField('awarenessMasyarakat', 'Awareness Masyarakat'),
                            
                          if (_shouldShowField('deskripsiAwareness'))
                            _buildTextField('deskripsiAwareness', 'Deskripsi Awareness'),
                            
                          if (_shouldShowField('penilaianSaranaAirBersih'))
                            _buildTextField('penilaianSaranaAirBersih', 'Penilaian Sarana Air Bersih'),
                            
                          if (_shouldShowField('penilaianSanitasi'))
                            _buildTextField('penilaianSanitasi', 'Penilaian Sanitasi'),
                            
                          SizedBox(height: 16),
                            
                          // Tampilkan checkbox untuk boolean fields
                          Text("Parameter Boolean", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(height: 8),
                          
                          // Filter fields sesuai jenis bantuan
                          ...outcomeData.keys
                            .where((key) => outcomeData[key] is bool && _shouldShowField(key))
                            .map((key) {
                              String label = _formatLabel(key);
                              return _buildCheckbox(key, label);
                            })
                            .toList(),
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
  
  // Helper function untuk memformat label dari key
  String _formatLabel(String key) {
    // Mengubah camelCase menjadi format lebih mudah dibaca
    final formattedKey = key.replaceAllMapped(
      RegExp(r'([A-Z])'), 
      (match) => ' ${match.group(0)!.toLowerCase()}'
    );
    
    return formattedKey.substring(0, 1).toUpperCase() + formattedKey.substring(1);
  }
}