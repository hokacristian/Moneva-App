import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moneva/data/providers/input_provider.dart';
import 'package:moneva/presentation/pages/dampak/editDampak_page.dart';
import 'package:moneva/presentation/pages/dampak/detail_dampak_page.dart';

class DampakPage extends StatefulWidget {
  @override
  _DampakPageState createState() => _DampakPageState();
}

class _DampakPageState extends State<DampakPage> {
  @override
  void initState() {
    super.initState();
    // Memuat semua form input (history input) untuk ditampilkan.
    Future.microtask(() =>
        Provider.of<InputProvider>(context, listen: false).fetchAllFormInputs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dampak')),
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
            return const Center(child: Text("Tidak ada data Dampak."));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: forms.length,
            itemBuilder: (context, index) {
              final form = forms[index];
              final dampak = form['dampak']; // Ambil data dampak dari form

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
                  title: Text(
                    form['lokasi'] ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle:
                      Text("Jenis Bantuan: ${form['jenisBantuan'] ?? ''}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (dampak != null)
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailDampakPage(
                                  // Kirim dampakId dari data dampak
                                  dampakId: dampak['id'],
                                ),
                              ),
                            );
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditDampakPage(
                                formId: form['id'],
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
