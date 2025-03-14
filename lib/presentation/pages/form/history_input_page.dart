import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moneva/data/providers/input_provider.dart';

class HistoryInputPage extends StatefulWidget {
  @override
  _HistoryInputPageState createState() => _HistoryInputPageState();
}

class _HistoryInputPageState extends State<HistoryInputPage> {
  @override
  void initState() {
    super.initState();
    // 🔥 Fetch data saat halaman pertama kali dibuka
    Future.microtask(() =>
        Provider.of<InputProvider>(context, listen: false).fetchAllFormInputs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History Form')),
      body: Consumer<InputProvider>(
        builder: (context, inputProvider, child) {
          if (inputProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (inputProvider.errorMessage != null) {
            return Center(
              child: Text(
                inputProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final forms = inputProvider.allFormInputs;
          if (forms.isEmpty) {
            return const Center(child: Text("Tidak ada data Form Input."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: forms.length,
            itemBuilder: (context, index) {
              final form = forms[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: form['img'] != null
                      ? Image.network(
                          form['img'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported),
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(form['lokasi'],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  subtitle: Text("Jenis Bantuan: ${form['jenisBantuan']}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // 🔥 Arahkan ke detail halaman form input
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailFormPage(formId: form['id'])),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// 🔥 Halaman Detail Form (Sementara Kosong)
class DetailFormPage extends StatelessWidget {
  final int formId;

  const DetailFormPage({Key? key, required this.formId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Form ID: $formId")),
      body: const Center(child: Text("Detail dari Form Input")),
    );
  }
}
