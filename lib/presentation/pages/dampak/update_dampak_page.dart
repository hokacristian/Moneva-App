import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moneva/data/providers/dampak_provider.dart';

class UpdateDampakPage extends StatefulWidget {
  final int dampakId;

  const UpdateDampakPage({
    Key? key,
    required this.dampakId,
  }) : super(key: key);

  @override
  _UpdateDampakPageState createState() => _UpdateDampakPageState();
}

class _UpdateDampakPageState extends State<UpdateDampakPage> {
  final _formKey = GlobalKey<FormState>();

  // Data yang akan di-edit (pre-populate dari server)
  Map<String, dynamic> dampakData = {
    "sumberAirSebelum": '',
    "sumberAirSesudah": '',
    "biayaListrikSebelum": '',
    "biayaListrikSesudah": '',
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
  };

  bool isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Ambil data Dampak yang sudah ada agar form terisi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingDampak();
    });
  }

  Future<void> _loadExistingDampak() async {
    final dampakProvider = Provider.of<DampakProvider>(context, listen: false);
    setState(() => isLoading = true);

    await dampakProvider.fetchDampak(widget.dampakId);
    final existingDampak = dampakProvider.dampak;

    if (existingDampak != null) {
      setState(() {
        // Isi semua field dari existingDampak
        dampakData["sumberAirSebelum"] =
            existingDampak["sumberAirSebelum"]?.toString() ?? '';
        dampakData["sumberAirSesudah"] =
            existingDampak["sumberAirSesudah"]?.toString() ?? '';
        dampakData["biayaListrikSebelum"] =
            existingDampak["biayaListrikSebelum"]?.toString() ?? '';
        dampakData["biayaListrikSesudah"] =
            existingDampak["biayaListrikSesudah"]?.toString() ?? '';
        dampakData["biayaBerobatSebelum"] =
            existingDampak["biayaBerobatSebelum"]?.toString() ?? '';
        dampakData["biayaBerobatSesudah"] =
            existingDampak["biayaBerobatSesudah"]?.toString() ?? '';
        dampakData["biayaAirBersihSebelum"] =
            existingDampak["biayaAirBersihSebelum"]?.toString() ?? '';
        dampakData["biayaAirBersihSesudah"] =
            existingDampak["biayaAirBersihSesudah"]?.toString() ?? '';
        dampakData["peningkatanEkonomiSebelum"] =
            existingDampak["peningkatanEkonomiSebelum"]?.toString() ?? '';
        dampakData["peningkatanEkonomiSesudah"] =
            existingDampak["peningkatanEkonomiSesudah"]?.toString() ?? '';
        dampakData["penurunanOrangSakitSebelum"] =
            existingDampak["penurunanOrangSakitSebelum"]?.toString() ?? '';
        dampakData["penurunanOrangSakitSesudah"] =
            existingDampak["penurunanOrangSakitSesudah"]?.toString() ?? '';
        dampakData["penurunanStuntingSebelum"] =
            existingDampak["penurunanStuntingSebelum"]?.toString() ?? '';
        dampakData["penurunanStuntingSesudah"] =
            existingDampak["penurunanStuntingSesudah"]?.toString() ?? '';
        dampakData["peningkatanIndeksKesehatanSebelum"] =
            existingDampak["peningkatanIndeksKesehatanSebelum"]?.toString() ??
                '';
        dampakData["peningkatanIndeksKesehatanSesudah"] =
            existingDampak["peningkatanIndeksKesehatanSesudah"]?.toString() ??
                '';
        dampakData["volumeLimbahDikelola"] =
            existingDampak["volumeLimbahDikelola"]?.toString() ?? '';
        dampakData["prosesKonservasiAir"] =
            existingDampak["prosesKonservasiAir"] ?? false;
        dampakData["penurunanIndexPencemaranSebelum"] =
            existingDampak["penurunanIndexPencemaranSebelum"]?.toString() ?? '';
        dampakData["penurunanIndexPencemaranSesudah"] =
            existingDampak["penurunanIndexPencemaranSesudah"]?.toString() ?? '';
      });
    }
    setState(() => isLoading = false);
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
        initialValue: dampakData[key]?.toString(),
        onChanged: (value) {
          setState(() {
            if (isNumeric) {
              // Jika field kosong, tetapkan 0 agar tidak error
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      _errorMessage = null;
    });

    // Data yang akan di-patch
    final patchData = {
      "sumberAirSebelum": dampakData["sumberAirSebelum"],
      "sumberAirSesudah": dampakData["sumberAirSesudah"],
      "biayaListrikSebelum": num.tryParse(dampakData["biayaListrikSebelum"].toString()) ?? 0,
      "biayaListrikSesudah": num.tryParse(dampakData["biayaListrikSesudah"].toString()) ?? 0,
      "biayaBerobatSebelum": num.tryParse(dampakData["biayaBerobatSebelum"].toString()) ?? 0,
      "biayaBerobatSesudah": num.tryParse(dampakData["biayaBerobatSesudah"].toString()) ?? 0,
      "biayaAirBersihSebelum": num.tryParse(dampakData["biayaAirBersihSebelum"].toString()) ?? 0,
      "biayaAirBersihSesudah": num.tryParse(dampakData["biayaAirBersihSesudah"].toString()) ?? 0,
      "peningkatanEkonomiSebelum": num.tryParse(dampakData["peningkatanEkonomiSebelum"].toString()) ?? 0,
      "peningkatanEkonomiSesudah": num.tryParse(dampakData["peningkatanEkonomiSesudah"].toString()) ?? 0,
      "penurunanOrangSakitSebelum": dampakData["penurunanOrangSakitSebelum"],
      "penurunanOrangSakitSesudah": dampakData["penurunanOrangSakitSesudah"],
      "penurunanStuntingSebelum": num.tryParse(dampakData["penurunanStuntingSebelum"].toString()) ?? 0,
      "penurunanStuntingSesudah": num.tryParse(dampakData["penurunanStuntingSesudah"].toString()) ?? 0,
      "peningkatanIndeksKesehatanSebelum": num.tryParse(dampakData["peningkatanIndeksKesehatanSebelum"].toString()) ?? 0,
      "peningkatanIndeksKesehatanSesudah": num.tryParse(dampakData["peningkatanIndeksKesehatanSesudah"].toString()) ?? 0,
      "volumeLimbahDikelola": num.tryParse(dampakData["volumeLimbahDikelola"].toString()) ?? 0,
      "prosesKonservasiAir": dampakData["prosesKonservasiAir"],
      "penurunanIndexPencemaranSebelum": num.tryParse(dampakData["penurunanIndexPencemaranSebelum"].toString()) ?? 0,
      "penurunanIndexPencemaranSesudah": num.tryParse(dampakData["penurunanIndexPencemaranSesudah"].toString()) ?? 0,
    };

    try {
      final dampakProvider = Provider.of<DampakProvider>(context, listen: false);
      final success = await dampakProvider.updateDampak(widget.dampakId, patchData);
      if (success) {
        // Berhasil update, kembali ke halaman sebelumnya
        Navigator.pop(context, true);
      } else {
        setState(() {
          _errorMessage = "Gagal mengupdate Dampak.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Terjadi kesalahan saat mengupdate Dampak.";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Dampak - ID: ${widget.dampakId}"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
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
                    _buildTextField("penurunanOrangSakitSebelum", "Penurunan Orang Sakit Sebelum"),
                    _buildTextField("penurunanOrangSakitSesudah", "Penurunan Orang Sakit Sesudah"),
                    _buildTextField("penurunanStuntingSebelum", "Penurunan Stunting Sebelum", isNumeric: true),
                    _buildTextField("penurunanStuntingSesudah", "Penurunan Stunting Sesudah", isNumeric: true),
                    _buildTextField("peningkatanIndeksKesehatanSebelum", "Peningkatan Indeks Kesehatan Masyarakat Sebelum", isNumeric: true),
                    _buildTextField("peningkatanIndeksKesehatanSesudah", "Peningkatan Indeks Kesehatan Masyarakat Sesudah", isNumeric: true),
                    _buildTextField("volumeLimbahDikelola", "Volume Limbah Yang Berhasil Dikelola Masyarakat", isNumeric: true),
                    _buildCheckbox("prosesKonservasiAir", "Proses Konservasi Air"),
                    _buildTextField("penurunanIndexPencemaranSebelum", "Penurunan Index Pencemaran Lingkungan Sebelum", isNumeric: true),
                    _buildTextField("penurunanIndexPencemaranSesudah", "Penurunan Index Pencemaran Lingkungan Sesudah", isNumeric: true),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text("Update Dampak"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
