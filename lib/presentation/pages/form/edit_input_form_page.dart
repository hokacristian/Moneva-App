import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:moneva/data/providers/input_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

class EditInputFormPage extends StatefulWidget {
  final int formId;

  const EditInputFormPage({Key? key, required this.formId}) : super(key: key);

  @override
  _EditInputFormPageState createState() => _EditInputFormPageState();
}

class _EditInputFormPageState extends State<EditInputFormPage> {
  final _formKey = GlobalKey<FormState>();
  File? imageFile;
  Map<String, dynamic>? formInput;

  String? selectedLocation;
  String? selectedBantuan;
  double? latitude;
  double? longitude;

  final TextEditingController jmlhBantuanController = TextEditingController();
  final TextEditingController jmlhKKController = TextEditingController();
  final TextEditingController jmlhPerempuanController = TextEditingController();
  final TextEditingController jmlhLakiController = TextEditingController();
  final TextEditingController debitAirController = TextEditingController();
  final TextEditingController pemakaianAirController = TextEditingController();
  final TextEditingController sistemPengelolaanController =
      TextEditingController();
  final TextEditingController sumberAirController = TextEditingController();
  final TextEditingController hargaAirController = TextEditingController();
  final TextEditingController pHController = TextEditingController();
  final TextEditingController TDSController = TextEditingController();
  final TextEditingController ECController = TextEditingController();
  final TextEditingController ORPController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await Provider.of<InputProvider>(context, listen: false).fetchPlaces();
      await _fetchFormDetail();
    });
  }

  Future<void> _fetchFormDetail() async {
    await Provider.of<InputProvider>(context, listen: false)
        .fetchFormInput(widget.formId);
    final fetchedForm =
        Provider.of<InputProvider>(context, listen: false).formInput;

    if (mounted) {
      setState(() {
        formInput = fetchedForm;
        if (formInput != null) {
          selectedLocation = formInput!["lokasi"];
          selectedBantuan = formInput!["jenisBantuan"];
          latitude = formInput!["lat"];
          longitude = formInput!["long"];

          jmlhBantuanController.text = formInput!["jmlhBantuan"].toString();
          jmlhKKController.text = formInput!["jmlhKK"].toString();
          jmlhPerempuanController.text = formInput!["jmlhPerempuan"].toString();
          jmlhLakiController.text = formInput!["jmlhLaki"].toString();
          debitAirController.text = formInput!["debitAir"].toString();
          pemakaianAirController.text = formInput!["pemakaianAir"].toString();
          sistemPengelolaanController.text =
              formInput!["sistemPengelolaan"].toString();
          sumberAirController.text = formInput!["sumberAir"].toString();
          hargaAirController.text = formInput!["hargaAir"].toString();
          pHController.text = formInput!["pH"].toString();
          TDSController.text = formInput!["TDS"].toString();
          ECController.text = formInput!["EC"].toString();
          ORPController.text = formInput!["ORP"].toString();
        }
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
  if (_formKey.currentState!.validate()) {
    Map<String, dynamic> updatedData = {
      'lokasi': selectedLocation,
      'jenisBantuan': selectedBantuan,
      'lat': latitude,
      'long': longitude,
      'jmlhBantuan': int.tryParse(jmlhBantuanController.text) ?? 0,
      'jmlhKK': int.tryParse(jmlhKKController.text) ?? 0,
      'jmlhPerempuan': int.tryParse(jmlhPerempuanController.text) ?? 0,
      'jmlhLaki': int.tryParse(jmlhLakiController.text) ?? 0,
      'debitAir': int.tryParse(debitAirController.text) ?? 0,
      'pemakaianAir': pemakaianAirController.text,
      'sistemPengelolaan': sistemPengelolaanController.text,
      'sumberAir': sumberAirController.text,
      'hargaAir': double.tryParse(hargaAirController.text) ?? 0.0,
      'pH': double.tryParse(pHController.text),
      'TDS': double.tryParse(TDSController.text),
      'EC': double.tryParse(ECController.text),
      'ORP': double.tryParse(ORPController.text),
    };

    if (imageFile == null) {
      // ⚠️ KIRIM URL LAMA jika user tidak pilih gambar baru
      updatedData['img'] = formInput!["img"];
    } else {
      // Jika user pilih gambar baru
      updatedData['img'] = imageFile!.path;
    }

    Provider.of<InputProvider>(context, listen: false)
        .updateFormInput(widget.formId, updatedData, imageFile)
        .then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diperbarui')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui data')),
        );
      }
    });
  }
}




  @override
  Widget build(BuildContext context) {
    final places = Provider.of<InputProvider>(context).places;

    return Scaffold(
  appBar: AppBar(title: const Text("Edit Data Form")),
  body: formInput == null
      ? const Center(child: CircularProgressIndicator())
      : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Dropdown Pilih Lokasi
                  DropdownButtonFormField<String>(
                    value: selectedLocation,
                    hint: const Text('Pilih Lokasi'),
                    items: places.map((place) {
                      return DropdownMenuItem(
                        value: place['name'].toString(),
                        child: Text(place['name'].toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedLocation = value;
                      });
                    },
                  ),

                  // 🔹 Dropdown Pilih Jenis Bantuan
                  DropdownButtonFormField<String>(
                    value: selectedBantuan,
                    hint: const Text('Pilih Jenis Bantuan'),
                    items: ['SAB & MCK', 'SAB', 'MCK'].map((bantuan) {
                      return DropdownMenuItem(
                        value: bantuan,
                        child: Text(bantuan),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBantuan = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Gambar yang sudah ada / Upload Gambar Baru
                  imageFile == null
                      ? Image.network(formInput!["img"], height: 100)
                      : Image.file(imageFile!, height: 100),

                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _pickImage(ImageSource.camera),
                        child: const Text('Kamera'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        child: const Text('Galeri'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Form Input Data Lengkap
                  TextFormField(
                    controller: jmlhBantuanController,
                    decoration: const InputDecoration(labelText: 'Jumlah Bantuan'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: jmlhKKController,
                    decoration: const InputDecoration(labelText: 'Jumlah KK'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: jmlhPerempuanController,
                    decoration: const InputDecoration(labelText: 'Jumlah Perempuan'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: jmlhLakiController,
                    decoration: const InputDecoration(labelText: 'Jumlah Laki'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: debitAirController,
                    decoration: const InputDecoration(labelText: 'Debit Air'),
                  ),
                  TextFormField(
                    controller: pemakaianAirController,
                    decoration: const InputDecoration(labelText: 'Pemakaian Air'),
                  ),
                  TextFormField(
                    controller: sistemPengelolaanController,
                    decoration: const InputDecoration(labelText: 'Sistem Pengelolaan'),
                  ),
                  TextFormField(
                    controller: sumberAirController,
                    decoration: const InputDecoration(labelText: 'Sumber Air'),
                  ),
                  TextFormField(
                    controller: hargaAirController,
                    decoration: const InputDecoration(labelText: 'Harga Air'),
                    keyboardType: TextInputType.number,
                  ),

                  // 🔹 Input Data Air Tambahan (pH, TDS, EC, ORP)
                  TextFormField(
                    controller: pHController,
                    decoration: const InputDecoration(labelText: 'pH'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: TDSController,
                    decoration: const InputDecoration(labelText: 'TDS (ppm)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: ECController,
                    decoration: const InputDecoration(labelText: 'EC (µS/cm)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: ORPController,
                    decoration: const InputDecoration(labelText: 'ORP (mV)'),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Tombol Simpan
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Simpan Perubahan'),
                  ),
                ],
              ),
            ),
          ),
        ),
);

  }
}
