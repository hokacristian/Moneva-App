// detail_form_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moneva/data/providers/input_provider.dart';

class DetailFormPage extends StatefulWidget {
  final int formId;

  const DetailFormPage({Key? key, required this.formId}) : super(key: key);

  @override
  _DetailFormPageState createState() => _DetailFormPageState();
}

class _DetailFormPageState extends State<DetailFormPage> {
  bool isLoading = false;
  Map<String, dynamic>? formInput;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchFormDetail();
    });
  }

  Future<void> _fetchFormDetail() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Panggil fetchFormInput pada InputProvider untuk mendapatkan detail Form Input
      await Provider.of<InputProvider>(context, listen: false)
          .fetchFormInput(widget.formId);
      setState(() {
        formInput =
            Provider.of<InputProvider>(context, listen: false).formInput;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
    setState(() {
      isLoading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Form ID: ${widget.formId}")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : formInput == null
                  ? const Center(child: Text("Tidak ada data."))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ Bagian Paling Atas: User & Gambar & Level Air Bersih & Level Sanitasi
                          if (formInput!["user"] != null) ...[
                            const Text("Detail Laporan",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.person, color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(
                                  "Pembuat Laporan: ",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  formInput!["user"]["name"],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],

                          // ✅ Gambar (jika tersedia)
                          if (formInput!["img"] != null)
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    formInput!["img"],
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error,
                                            stackTrace) =>
                                        const Icon(Icons.image_not_supported,
                                            size: 100, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),

                          // ✅ Level Sarana Air Bersih & Level Sanitasi
                          if (formInput!["outcome"] != null) ...[
                            const SizedBox(height: 16),
                            Center(
                              child: Column(
                                children: [
                                  const Text(
                                    "Level Sarana Air Bersih",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      3,
                                      (index) => Icon(
                                        index <
                                                formInput!["outcome"]
                                                    ["levelSaranaAirBersih"]
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Level Sanitasi",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      3,
                                      (index) => Icon(
                                        index <
                                                formInput!["outcome"]
                                                    ["levelSanitasi"]
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // ✅ Data Form Input Setelahnya
                          const Text("Data Form Input",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const Divider(),
                          buildDetailRow("Lokasi", formInput!["lokasi"]),
                          buildDetailRow("Latitude", formInput!["lat"]),
                          buildDetailRow("Longitude", formInput!["long"]),
                          buildDetailRow(
                              "Jumlah Bantuan", formInput!["jmlhBantuan"]),
                          buildDetailRow(
                              "Jenis Bantuan", formInput!["jenisBantuan"]),
                          buildDetailRow("Jumlah KK", formInput!["jmlhKK"]),
                          buildDetailRow(
                              "Jumlah Perempuan", formInput!["jmlhPerempuan"]),
                          buildDetailRow("Jumlah Laki", formInput!["jmlhLaki"]),
                          buildDetailRow("Debit Air", formInput!["debitAir"]),
                          buildDetailRow(
                              "Pemakaian Air", formInput!["pemakaianAir"]),
                          buildDetailRow("Sistem Pengelolaan",
                              formInput!["sistemPengelolaan"]),
                          buildDetailRow("Sumber Air", formInput!["sumberAir"]),
                          buildDetailRow("Harga Air", formInput!["hargaAir"]),
                          buildDetailRow("pH", formInput!["pH"]),
                          buildDetailRow("TDS (ppm)", formInput!["TDS"]),
                          buildDetailRow("EC (µS/cm)", formInput!["EC"]),
                          buildDetailRow("ORP (mV)", formInput!["ORP"]),
                          const SizedBox(height: 16),
                          if (formInput!["outcome"] != null) ...[
                            const Text("Outcome",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const Divider(),
                            buildDetailRow("Konsumsi Air per Tahun",
                                formInput!["outcome"]["konsumsiAirPerTahun"]),
                            buildDetailRowWithIcon("Kualitas Air",
                                formInput!["outcome"]["kualitasAir"]),
                            buildDetailRow(
                                "Penyakit Sebelum",
                                formInput!["outcome"]
                                    ["rataRataTerpaparPenyakitSebelum"]),
                            buildDetailRow(
                                "Penyakit Sesudah",
                                formInput!["outcome"]
                                    ["rataRataTerpaparPenyakitSesudah"]),
                            buildDetailRowWithIcon("Bisa Dipakai MCK",
                                formInput!["outcome"]["bisaDipakaiMCK"]),
                            buildDetailRowWithIcon("Bisa Diminum",
                                formInput!["outcome"]["bisaDiminum"]),
                            buildDetailRowWithIcon("Eco Keberlanjutan",
                                formInput!["outcome"]["ecoKeberlanjutan"]),
                            buildDetailRow("Level Sarana Air Bersih",
                                formInput!["outcome"]["levelSaranaAirBersih"]),
                            buildDetailRow("Level Sanitasi",
                                formInput!["outcome"]["levelSanitasi"]),
                            buildDetailRowWithIcon("Air Hanya Untuk MCK",
                                formInput!["outcome"]["airHanyaUntukMCK"]),
                            buildDetailRowWithIcon("Akses Terbatas",
                                formInput!["outcome"]["aksesTerbatas"]),
                            buildDetailRowWithIcon("Butuh Usaha Jarak",
                                formInput!["outcome"]["butuhUsahaJarak"]),
                            buildDetailRowWithIcon("Air Tersedia Setiap Saat",
                                formInput!["outcome"]["airTersediaSetiapSaat"]),
                            buildDetailRowWithIcon(
                                "Pengelolaan Profesional",
                                formInput!["outcome"]
                                    ["pengelolaanProfesional"]),
                            buildDetailRowWithIcon("Akses Mudah",
                                formInput!["outcome"]["aksesMudah"]),
                            buildDetailRowWithIcon("Efisiensi Air",
                                formInput!["outcome"]["efisiensiAir"]),
                            buildDetailRowWithIcon("Ramah Lingkungan",
                                formInput!["outcome"]["ramahLingkungan"]),
                            buildDetailRowWithIcon("Keadilan Akses",
                                formInput!["outcome"]["keadilanAkses"]),
                            buildDetailRowWithIcon("Adaptabilitas Sistem",
                                formInput!["outcome"]["adaptabilitasSistem"]),
                            buildDetailRowWithIcon("Toilet Berfungsi",
                                formInput!["outcome"]["toiletBerfungsi"]),
                            buildDetailRowWithIcon("Akses Sanitasi Memadai",
                                formInput!["outcome"]["aksesSanitasiMemadai"]),
                            buildDetailRowWithIcon("Eksposur Limbah",
                                formInput!["outcome"]["eksposurLimbah"]),
                            buildDetailRowWithIcon("Limbah Dikelola Aman",
                                formInput!["outcome"]["limbahDikelolaAman"]),
                            buildDetailRowWithIcon("Ada Septictank",
                                formInput!["outcome"]["adaSeptictank"]),
                            buildDetailRowWithIcon("Sanitasi Bersih",
                                formInput!["outcome"]["sanitasiBersih"]),
                            buildDetailRowWithIcon("Akses Kelompok Rentan",
                                formInput!["outcome"]["aksesKelompokRentan"]),
                            buildDetailRowWithIcon("Rasio MCK Memadai",
                                formInput!["outcome"]["rasioMCKMemadai"]),
                            buildDetailRowWithIcon(
                                "Keberlanjutan Ekosistem",
                                formInput!["outcome"]
                                    ["keberlanjutanEkosistem"]),
                            buildDetailRowWithIcon("Pemanfaatan Air Efisien",
                                formInput!["outcome"]["pemanfaatanAirEfisien"]),
                            const SizedBox(height: 16),
                          ],
  
                          if (formInput!["dampak"] != null) ...[
                            const Text("Dampak",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const Divider(),

                            // 🔹 Sumber Air Sebelum & Sesudah
                            buildDetailRow("Sumber Air Sebelum",
                                formInput!["dampak"]["sumberAirSebelum"]),
                            buildDetailRow("Sumber Air Sesudah",
                                formInput!["dampak"]["sumberAirSesudah"]),

                            // 🔹 Biaya Listrik Sebelum & Sesudah
                            buildDetailRow("Biaya Listrik Sebelum",
                                formInput!["dampak"]["biayaListrikSebelum"]),
                            buildDetailRow("Biaya Listrik Sesudah",
                                formInput!["dampak"]["biayaListrikSesudah"]),

                            // 🔹 Biaya Berobat Sebelum & Sesudah
                            buildDetailRow("Biaya Berobat Sebelum",
                                formInput!["dampak"]["biayaBerobatSebelum"]),
                            buildDetailRow("Biaya Berobat Sesudah",
                                formInput!["dampak"]["biayaBerobatSesudah"]),

                            // 🔹 Biaya Air Bersih Sebelum & Sesudah
                            buildDetailRow("Biaya Air Pemenuhan Bersih Sebelum",
                                formInput!["dampak"]["biayaAirBersihSebelum"]),
                            buildDetailRow("Biaya Air Pemenuhan Bersih Sesudah",
                                formInput!["dampak"]["biayaAirBersihSesudah"]),

                            // 🔹 Peningkatan Ekonomi Sebelum & Sesudah
                            buildDetailRow(
                                "Peningkatan Ekonomi Sebelum",
                                formInput!["dampak"]
                                    ["peningkatanEkonomiSebelum"]),
                            buildDetailRow(
                                "Peningkatan Ekonomi Sesudah",
                                formInput!["dampak"]
                                    ["peningkatanEkonomiSesudah"]),

                            // 🔹 Penurunan Orang Sakit Sebelum & Sesudah
                            buildDetailRow(
                                "Penurunan Orang Sakit Sebelum",
                                formInput!["dampak"]
                                    ["penurunanOrangSakitSebelum"]),
                            buildDetailRow(
                                "Penurunan Orang Sakit Sesudah",
                                formInput!["dampak"]
                                    ["penurunanOrangSakitSesudah"]),

                            // 🔹 Penurunan Stunting Sebelum & Sesudah
                            buildDetailRow(
                                "Penurunan Stunting Sebelum",
                                formInput!["dampak"]
                                    ["penurunanStuntingSebelum"]),
                            buildDetailRow(
                                "Penurunan Stunting Sesudah",
                                formInput!["dampak"]
                                    ["penurunanStuntingSesudah"]),

                            // 🔹 Peningkatan Indeks Kesehatan Sebelum & Sesudah
                            buildDetailRow(
                                "Peningkatan Indeks Kesehatan Masyarakat Sebelum (terutama perempuan dan anak-anak)",
                                formInput!["dampak"]
                                    ["peningkatanIndeksKesehatanSebelum"]),
                            buildDetailRow(
                                "Peningkatan Indeks Kesehatan Masyarakat Sesudah (terutama perempuan dan anak-anak)",
                                formInput!["dampak"]
                                    ["peningkatanIndeksKesehatanSesudah"]),

                            // 🔹 Volume Limbah yang Berhasil Dikelola Masyarakat
                            buildDetailRow(
                                "Volume Limbah Yang Berhasil Dikelola Masyarakat",
                                formInput!["dampak"]["volumeLimbahDikelola"]),

                            // 🔹 Proses Konservasi Air (Tampilkan sebagai ✅ atau ❌)
                            buildDetailRowWithIcon("Proses Konservasi Air",
                                formInput!["dampak"]["prosesKonservasiAir"]),

                            // 🔹 Penurunan Index Pencemaran Sebelum & Sesudah
                            buildDetailRow(
                                "Penurunan Index Pencemaran Lingkungan Sebelum",
                                formInput!["dampak"]
                                    ["penurunanIndexPencemaranSebelum"]),
                            buildDetailRow(
                                "Penurunan Index Pencemaran Lingkungan Sesudah",
                                formInput!["dampak"]
                                    ["penurunanIndexPencemaranSesudah"]),
                          ],
                        ],
                      ),
                    ),
    );
  }
}

Widget buildDetailRowWithIcon(String label, bool value) {
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
            value ? Icons.check_circle : Icons.cancel,
            color: value ? Colors.green : Colors.red,
          ),
        ),
      ],
    ),
  );
}
