// editDampak_page.dart
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

  // Mulai dengan map kosong, jangan gunakan default data yang hardcoded
  Map<String, dynamic> dampakData = {};

  bool isLoading = false;

  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _loadDampakData();
  });
}


  Future<void> _loadDampakData() async {
    setState(() => isLoading = true);
    final dampakProvider = Provider.of<DampakProvider>(context, listen: false);
    await dampakProvider.fetchDampak(widget.formId);
    if (dampakProvider.dampak != null) {
      setState(() {
        dampakData = Map<String, dynamic>.from(dampakProvider.dampak!);
      });
    } else {
      // Jika data dampak belum ada, inisialisasi field-field dengan nilai kosong
      setState(() {
        dampakData = {
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
      });
    }
    setState(() => isLoading = false);
  }

  // Membuat text field untuk input data string/numerik
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
              // Jika field kosong, simpan sebagai string kosong; jika tidak, parsing angka
              dampakData[key] = value.isEmpty
                  ? ''
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

  // Membuat checkbox untuk field boolean
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

  // Helper untuk memformat label (misalnya: "biayaBerobatSebelum" menjadi "Biaya berobat sebelum")
  String _formatLabel(String key) {
    final formattedKey = key.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(0)!.toLowerCase()}',
    );
    return formattedKey.substring(0, 1).toUpperCase() + formattedKey.substring(1);
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
                            _buildTextField("sumberAirSebelum", "Sumber Air Sebelum"),
                            _buildTextField("sumberAirSesudah", "Sumber Air Sesudah"),

                            _buildTextField("biayaListrikSebelum", "Biaya Listrik Sebelum", isNumeric: true),
                            _buildTextField("biayaListrikSesudah", "Biaya Listrik Sesudah", isNumeric: true),


                            _buildTextField("biayaBerobatSebelum", "Biaya Berobat Sebelum", isNumeric: true),
                            _buildTextField("biayaBerobatSesudah", "Biaya Berobat Sesudah", isNumeric: true),

                            _buildTextField("biayaAirBersihSebelum", "Biaya Air Pemenuhan Bersih Sebelum", isNumeric: true),
                            _buildTextField("biayaAirBersihSesudah", "Biaya Air Pemenuhan Bersih Sesudah", isNumeric: true),

                            _buildTextField("peningkatanEkonomiSebelum", "Peningkatan Ekonomi Sebelum", isNumeric: true),
                            _buildTextField("peningkatanEkonomiSesudah", "Peningkatan Ekonomi Sesudah", isNumeric: true),

                            _buildTextField("penurunanOrangSakitSebelum", "Penurunan Orang Sakit Sebelum", isNumeric: true),
                            _buildTextField("penurunanOrangSakitSesudah", "Penurunan Orang Sakit Sesudah", isNumeric: true),

                            _buildTextField("penurunanStuntingSebelum", "Penurunan Stunting Sebelum", isNumeric: true),
                            _buildTextField("penurunanStuntingSesudah", "Penurunan Stunting Sesudah", isNumeric: true),

                            _buildTextField("peningkatanIndeksKesehatanSebelum", "Peningkatan Indeks Kesehatan Masyarakat Sebelum (terutama perempuan dan anak-anak) " , isNumeric: true),
                            _buildTextField("peningkatanIndeksKesehatanSesudah", "Peningkatan Indeks Kesehatan Masyarakat Sesudah (terutama perempuan dan anak-anak) ", isNumeric: true),

                            _buildTextField("volumeLimbahDikelola", "Volume Limbah Yang Berhasil Dikelola Masyarakat", isNumeric: true),

                            _buildCheckbox("prosesKonservasiAir", "Proses Konservasi Air"),

                            _buildTextField("penurunanIndexPencemaranSebelum", "Penurunan Index Pencemaran Lingkungan Sebelum", isNumeric: true),
                            _buildTextField("penurunanIndexPencemaranSesudah", "Penurunan Index Pencemaran Lingkungan Sesudah", isNumeric: true),
                            
                            
          
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
                              debugPrint("Data Dampak sebelum dikirim: $dampakData");
                              setState(() => isLoading = true);
                              // Jika data dampak sudah ada, update; jika belum, create.
                              if (dampakProvider.dampak != null) {
                                dampakProvider.updateDampak(widget.formId, dampakData).then((success) {
                                  setState(() => isLoading = false);
                                  if (success) {
                                    debugPrint("Dampak berhasil diperbarui.");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Dampak berhasil diperbarui")),
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    debugPrint("Dampak gagal diperbarui. Error: ${dampakProvider.errorMessage}");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Gagal memperbarui Dampak")),
                                    );
                                  }
                                });
                              } else {
                                dampakProvider.createDampak(widget.formId, dampakData).then((success) {
                                  setState(() => isLoading = false);
                                  if (success) {
                                    debugPrint("Dampak berhasil dibuat.");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Dampak berhasil dibuat")),
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    debugPrint("Dampak gagal dibuat. Error: ${dampakProvider.errorMessage}");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Gagal membuat Dampak")),
                                    );
                                  }
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            dampakProvider.dampak != null ? "Perbarui Dampak" : "Simpan Dampak Baru",
                          ),
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
