import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moneva/data/providers/dampak_provider.dart';

class EditDampakPage extends StatefulWidget {
  final int formId; // ID form input yang terkait dengan dampak

  const EditDampakPage({Key? key, required this.formId}) : super(key: key);

  @override
  _EditDampakPageState createState() => _EditDampakPageState();
}

class _EditDampakPageState extends State<EditDampakPage> {
  final _formKey = GlobalKey<FormState>();

  // Karena logika yang diinginkan adalah untuk create (input data baru),
  // kita mulai dengan data kosong.
  Map<String, dynamic> dampakData = {
    "biayaBerobatSebelum": '',
    "biayaBerobatSesudah": '',
    "biayaAirBersihSebelum": '',
    "biayaAirBersihSesudah": '',
    "peningkatanEkonomiSebelum": '',
    "peningkatanEkonomiSesudah": '',
    "penurunanOrangSakitSebelum": '',
    "penurunanOrangSakitSesudah": '',
    "penurunanStuntingSebelum": '',
    "penurunanStuntingSesudah": '',
    "peningkatanIndeksKesehatanSebelum": '',
    "peningkatanIndeksKesehatanSesudah": '',
    "volumeLimbahDikelola": '',
    "prosesKonservasiAir": false,
    "penurunanIndexPencemaranSebelum": '',
    "penurunanIndexPencemaranSesudah": '',
    "sumberAirSebelum": '',
    "sumberAirSesudah": '',
    "biayaListrikSebelum": '',
    "biayaListrikSesudah": '',
  };

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Karena logikanya create saja, kita tidak memanggil _loadDampakData().
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
        initialValue: dampakData[key]?.toString() ?? '',
        onChanged: (value) {
          setState(() {
            if (isNumeric) {
              // Jika field kosong, tetapkan 0 (agar tidak menghasilkan NaN)
              dampakData[key] = value.isEmpty
                  ? 0
                  : (value.contains('.')
                      ? double.tryParse(value) ?? 0.0
                      : int.tryParse(value) ?? 0);
            } else {
              dampakData[key] = value;
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
      value: dampakData[key] ?? false,
      onChanged: (bool? value) {
        setState(() {
          dampakData[key] = value ?? false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Dampak - ID: ${widget.formId}")),
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
                          children: [
                            _buildTextField(
                                "sumberAirSebelum", "Sumber Air Sebelum"),
                            _buildTextField(
                                "sumberAirSesudah", "Sumber Air Sesudah"),
                            _buildTextField(
                                "biayaListrikSebelum", "Biaya Listrik Sebelum",
                                isNumeric: true),
                            _buildTextField(
                                "biayaListrikSesudah", "Biaya Listrik Sesudah",
                                isNumeric: true),
                            _buildTextField(
                                "biayaBerobatSebelum", "Biaya Berobat Sebelum",
                                isNumeric: true),
                            _buildTextField(
                                "biayaBerobatSesudah", "Biaya Berobat Sesudah",
                                isNumeric: true),
                            _buildTextField("biayaAirBersihSebelum",
                                "Biaya Air Pemenuhan Bersih Sebelum",
                                isNumeric: true),
                            _buildTextField("biayaAirBersihSesudah",
                                "Biaya Air Pemenuhan Bersih Sesudah",
                                isNumeric: true),
                            _buildTextField("peningkatanEkonomiSebelum",
                                "Peningkatan Ekonomi Sebelum",
                                isNumeric: true),
                            _buildTextField("peningkatanEkonomiSesudah",
                                "Peningkatan Ekonomi Sesudah",
                                isNumeric: true),
                    _buildTextField("penurunanOrangSakitSebelum", "Penurunan Orang Sakit Sebelum"),
                    _buildTextField("penurunanOrangSakitSesudah", "Penurunan Orang Sakit Sesudah"),
                            _buildTextField("penurunanStuntingSebelum",
                                "Penurunan Stunting Sebelum",
                                isNumeric: true),
                            _buildTextField("penurunanStuntingSesudah",
                                "Penurunan Stunting Sesudah",
                                isNumeric: true),
                            _buildTextField("peningkatanIndeksKesehatanSebelum",
                                "Peningkatan Indeks Kesehatan Masyarakat Sebelum (terutama perempuan dan anak-anak)",
                                isNumeric: true),
                            _buildTextField("peningkatanIndeksKesehatanSesudah",
                                "Peningkatan Indeks Kesehatan Masyarakat Sesudah (terutama perempuan dan anak-anak)",
                                isNumeric: true),
                            _buildTextField("volumeLimbahDikelola",
                                "Volume Limbah Yang Berhasil Dikelola Masyarakat",
                                isNumeric: true),
                            _buildCheckbox(
                                "prosesKonservasiAir", "Proses Konservasi Air"),
                            _buildTextField("penurunanIndexPencemaranSebelum",
                                "Penurunan Index Pencemaran Lingkungan Sebelum",
                                isNumeric: true),
                            _buildTextField("penurunanIndexPencemaranSesudah",
                                "Penurunan Index Pencemaran Lingkungan Sesudah",
                                isNumeric: true),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Consumer<DampakProvider>(
                      builder: (context, dampakProvider, child) {
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              debugPrint(
                                  "Data Dampak sebelum dikirim: $dampakData");

                              // Simpan reference ke ScaffoldMessenger dan Navigator sebelum async operation
                              final messenger = ScaffoldMessenger.of(context);
                              final navigator = Navigator.of(context);
                              final provider = Provider.of<DampakProvider>(
                                  context,
                                  listen: false);

                              setState(() => isLoading = true);

                              provider
                                  .createDampak(widget.formId, dampakData)
                                  .then((success) {
                                // Hindari menggunakan setState langsung, gunakan conditional update
                                if (_formKey.currentState != null) {
                                  setState(() => isLoading = false);
                                }

                                if (success) {
                                  debugPrint("Dampak berhasil dibuat.");
                                  messenger.showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Dampak berhasil dibuat")),
                                  );
                                  navigator.pop();
                                } else {
                                  debugPrint(
                                      "Dampak gagal dibuat. Error: ${provider.errorMessage}");
                                  messenger.showSnackBar(
                                    const SnackBar(
                                        content: Text("Gagal membuat Dampak")),
                                  );
                                }
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Simpan Dampak Baru'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
