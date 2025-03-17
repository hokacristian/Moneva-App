import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moneva/data/providers/input_provider.dart';
import 'package:moneva/presentation/pages/outcome/editOutcome_page.dart';
import 'package:moneva/presentation/pages/outcome/view_outcome_page.dart'; // ✅ Import halaman ViewOutcomePage

class OutcomePage extends StatefulWidget {
  @override
  _OutcomePageState createState() => _OutcomePageState();
}

class _OutcomePageState extends State<OutcomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<InputProvider>(context, listen: false).fetchAllFormInputs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Outcome')),
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
            return const Center(child: Text("Tidak ada data Outcome."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: forms.length,
            itemBuilder: (context, index) {
              final form = forms[index];
              final outcome = form['outcome']; // ✅ Ambil outcome dari form

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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (outcome != null) // ✅ Tombol Lihat hanya muncul jika ada outcome
                        IconButton(
                          icon: const Icon(Icons.visibility), // Tombol "Lihat"
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewOutcomePage(outcomeId: outcome['id']), // ✅ Pakai ID dari outcome
                              ),
                            );
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit), // Tombol "Edit"
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditOutcomePage(
                                formId: form['id'],
                                jenisBantuan: form['jenisBantuan'],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
