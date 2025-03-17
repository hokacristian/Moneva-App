import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moneva/data/providers/dampak_provider.dart';
import 'package:intl/intl.dart';
import 'update_dampak_page.dart'; // ✅ Import file update dampak

class DetailDampakPage extends StatefulWidget {
  final int dampakId;
  const DetailDampakPage({Key? key, required this.dampakId}) : super(key: key);

  @override
  _DetailDampakPageState createState() => _DetailDampakPageState();
}

class _DetailDampakPageState extends State<DetailDampakPage> {
  final formatRupiah =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DampakProvider>(context, listen: false)
          .fetchDampak(widget.dampakId);
    });
  }

  // Helper: Format nilai numerik, jika null tampilkan "-"
  String formatValue(dynamic value) {
    if (value == null) return "-";
    try {
      return formatRupiah.format(value);
    } catch (e) {
      // Jika format gagal, kembalikan nilai string
      return value.toString();
    }
  }

  Widget buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value != null ? value.toString() : "-"),
          ),
        ],
      ),
    );
  }

  Widget buildDetailRowWithIcon(String label, bool? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Icon(
              value == true ? Icons.check_circle : Icons.cancel,
              color: value == true ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Dampak"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Arahkan ke halaman UpdateDampakPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateDampakPage(
                    dampakId: widget.dampakId,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Consumer<DampakProvider>(
        builder: (context, dampakProvider, child) {
          if (dampakProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (dampakProvider.errorMessage != null) {
            return Center(
              child: Text(
                dampakProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          final dampak = dampakProvider.dampak;
          if (dampak == null) {
            return const Center(child: Text("Dampak tidak ditemukan."));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Dampak",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Divider(),
                // 🔹 Sumber Air Sebelum & Sesudah
                buildDetailRow("Sumber Air Sebelum", dampak["sumberAirSebelum"]),
                buildDetailRow("Sumber Air Sesudah", dampak["sumberAirSesudah"]),
                // 🔹 Biaya Listrik Sebelum & Sesudah
                buildDetailRow("Biaya Listrik Sebelum",
                    formatValue(dampak["biayaListrikSebelum"])),
                buildDetailRow("Biaya Listrik Sesudah",
                    formatValue(dampak["biayaListrikSesudah"])),
                // 🔹 Biaya Berobat Sebelum & Sesudah
                buildDetailRow("Biaya Berobat Sebelum",
                    formatValue(dampak["biayaBerobatSebelum"])),
                buildDetailRow("Biaya Berobat Sesudah",
                    formatValue(dampak["biayaBerobatSesudah"])),
                // 🔹 Biaya Air Pemenuhan Bersih Sebelum & Sesudah
                buildDetailRow("Biaya Air Pemenuhan Bersih Sebelum",
                    formatValue(dampak["biayaAirBersihSebelum"])),
                buildDetailRow("Biaya Air Pemenuhan Bersih Sesudah",
                    formatValue(dampak["biayaAirBersihSesudah"])),
                // 🔹 Peningkatan Ekonomi Sebelum & Sesudah
                buildDetailRow("Peningkatan Ekonomi Sebelum",
                    dampak["peningkatanEkonomiSebelum"]),
                buildDetailRow("Peningkatan Ekonomi Sesudah",
                    dampak["peningkatanEkonomiSesudah"]),
                // 🔹 Penurunan Orang Sakit Sebelum & Sesudah
                buildDetailRow("Penurunan Orang Sakit Sebelum",
                    dampak["penurunanOrangSakitSebelum"]),
                buildDetailRow("Penurunan Orang Sakit Sesudah",
                    dampak["penurunanOrangSakitSesudah"]),
                // 🔹 Penurunan Stunting Sebelum & Sesudah
                buildDetailRow("Penurunan Stunting Sebelum",
                    dampak["penurunanStuntingSebelum"]),
                buildDetailRow("Penurunan Stunting Sesudah",
                    dampak["penurunanStuntingSesudah"]),
                // 🔹 Peningkatan Indeks Kesehatan (terutama perempuan & anak-anak)
                buildDetailRow(
                    "Peningkatan Indeks Kesehatan Masyarakat Sebelum (terutama perempuan dan anak-anak)",
                    dampak["peningkatanIndeksKesehatanSebelum"]),
                buildDetailRow(
                    "Peningkatan Indeks Kesehatan Masyarakat Sesudah (terutama perempuan dan anak-anak)",
                    dampak["peningkatanIndeksKesehatanSesudah"]),
                // 🔹 Volume Limbah yang Berhasil Dikelola Masyarakat
                buildDetailRow("Volume Limbah Yang Berhasil Dikelola Masyarakat",
                    dampak["volumeLimbahDikelola"]),
                // 🔹 Proses Konservasi Air (ditampilkan sebagai ✅ atau ❌)
                buildDetailRowWithIcon("Proses Konservasi Air",
                    dampak["prosesKonservasiAir"]),
                // 🔹 Penurunan Index Pencemaran Lingkungan Sebelum & Sesudah
                buildDetailRow("Penurunan Index Pencemaran Lingkungan Sebelum",
                    dampak["penurunanIndexPencemaranSebelum"]),
                buildDetailRow("Penurunan Index Pencemaran Lingkungan Sesudah",
                    dampak["penurunanIndexPencemaranSesudah"]),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Kembali"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
