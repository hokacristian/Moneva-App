import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moneva/data/providers/outcome_provider.dart';
import 'package:moneva/presentation/pages/outcome/update_outcome_page.dart'; // ✅ Import halaman UpdateOutcomePage

class ViewOutcomePage extends StatefulWidget {
  final int outcomeId;

  const ViewOutcomePage({Key? key, required this.outcomeId}) : super(key: key);

  @override
  _ViewOutcomePageState createState() => _ViewOutcomePageState();
}

class _ViewOutcomePageState extends State<ViewOutcomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<OutcomeProvider>(context, listen: false).fetchOutcome(widget.outcomeId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Outcome'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit), // ✏️ Ikon Edit
            onPressed: () {
  final outcome = Provider.of<OutcomeProvider>(context, listen: false).outcome;
  if (outcome != null) {
    final jenisBantuan = outcome["formInput"]?["jenisBantuan"] ?? "Tidak Diketahui"; // ✅ Ambil `jenisBantuan`
    final outcomeId = outcome["id"]; // ✅ Ambil ID Outcome

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateOutcomePage(
          outcomeId: outcomeId, // ✅ Kirim outcomeId yang benar
          jenisBantuan: jenisBantuan, // ✅ Kirim jenisBantuan yang benar
        ),
      ),
    );
  }
}

          ),
        ],
      ),
      body: Consumer<OutcomeProvider>(
        builder: (context, outcomeProvider, child) {
          if (outcomeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (outcomeProvider.errorMessage != null) {
            return Center(
              child: Text(
                outcomeProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final outcome = outcomeProvider.outcome;
          if (outcome == null) {
            return const Center(child: Text("Outcome tidak ditemukan."));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Outcome",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                buildDetailRow("Konsumsi Air per Tahun", outcome["konsumsiAirPerTahun"]),
                buildDetailRowWithIcon("Kualitas Air", outcome["kualitasAir"]),
                buildDetailRow("Penyakit Sebelum", outcome["rataRataTerpaparPenyakitSebelum"]),
                buildDetailRow("Penyakit Sesudah", outcome["rataRataTerpaparPenyakitSesudah"]),
                buildDetailRowWithIcon("Bisa Dipakai MCK", outcome["bisaDipakaiMCK"]),
                buildDetailRowWithIcon("Bisa Diminum", outcome["bisaDiminum"]),
                buildDetailRowWithIcon("Eco Keberlanjutan", outcome["ecoKeberlanjutan"]),
                buildDetailRow("Level Sarana Air Bersih", outcome["levelSaranaAirBersih"]),
                buildDetailRow("Level Sanitasi", outcome["levelSanitasi"]),
                buildDetailRowWithIcon("Air Hanya Untuk MCK", outcome["airHanyaUntukMCK"]),
                buildDetailRowWithIcon("Akses Terbatas", outcome["aksesTerbatas"]),
                buildDetailRowWithIcon("Butuh Usaha Jarak", outcome["butuhUsahaJarak"]),
                buildDetailRowWithIcon("Air Tersedia Setiap Saat", outcome["airTersediaSetiapSaat"]),
                buildDetailRowWithIcon("Pengelolaan Profesional", outcome["pengelolaanProfesional"]),
                buildDetailRowWithIcon("Akses Mudah", outcome["aksesMudah"]),
                buildDetailRowWithIcon("Efisiensi Air", outcome["efisiensiAir"]),
                buildDetailRowWithIcon("Ramah Lingkungan", outcome["ramahLingkungan"]),
                buildDetailRowWithIcon("Keadilan Akses", outcome["keadilanAkses"]),
                buildDetailRowWithIcon("Adaptabilitas Sistem", outcome["adaptabilitasSistem"]),
                buildDetailRowWithIcon("Toilet Berfungsi", outcome["toiletBerfungsi"]),
                buildDetailRowWithIcon("Akses Sanitasi Memadai", outcome["aksesSanitasiMemadai"]),
                buildDetailRowWithIcon("Eksposur Limbah", outcome["eksposurLimbah"]),
                buildDetailRowWithIcon("Limbah Dikelola Aman", outcome["limbahDikelolaAman"]),
                buildDetailRowWithIcon("Ada Septictank", outcome["adaSeptictank"]),
                buildDetailRowWithIcon("Sanitasi Bersih", outcome["sanitasiBersih"]),
                buildDetailRowWithIcon("Akses Kelompok Rentan", outcome["aksesKelompokRentan"]),
                buildDetailRowWithIcon("Rasio MCK Memadai", outcome["rasioMCKMemadai"]),
                buildDetailRowWithIcon("Keberlanjutan Ekosistem", outcome["keberlanjutanEkosistem"]),
                buildDetailRowWithIcon("Pemanfaatan Air Efisien", outcome["pemanfaatanAirEfisien"]),
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

/// **Fungsi untuk menampilkan data biasa (tanpa ikon)**
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

/// **Fungsi untuk menampilkan data dengan ikon (✅ atau ❌)**
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
