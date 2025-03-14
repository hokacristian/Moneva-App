import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:moneva/data/providers/input_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

class InputFormPage extends StatefulWidget {
  @override
  _InputFormPageState createState() => _InputFormPageState();
}

class _InputFormPageState extends State<InputFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedLocation;
  String? selectedBantuan;
  File? imageFile;
  double? latitude;
  double? longitude;
  final TextEditingController jmlhBantuanController = TextEditingController();
  final TextEditingController jmlhKKController = TextEditingController();
  final TextEditingController jmlhPerempuanController = TextEditingController();
  final TextEditingController jmlhLakiController = TextEditingController();
  final TextEditingController debitAirController = TextEditingController();
  final TextEditingController pemakaianAirController = TextEditingController();
  final TextEditingController sistemPengelolaanController = TextEditingController();
  final TextEditingController sumberAirController = TextEditingController();
  final TextEditingController hargaAirController = TextEditingController();
  final TextEditingController pHController = TextEditingController();
  final TextEditingController TDSController = TextEditingController();
  final TextEditingController ECController = TextEditingController();
  final TextEditingController ORPController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<InputProvider>(context, listen: false).fetchPlaces());
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (mounted) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
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
      Map<String, dynamic> formData = {
        'lokasi': selectedLocation,
        'jenisBantuan': selectedBantuan,
        'lat': latitude,
        'long': longitude,
        'img': imageFile?.path,
        'jmlhBantuan': int.tryParse(jmlhBantuanController.text) ?? 0,
        'jmlhKK': int.tryParse(jmlhKKController.text) ?? 0,
        'jmlhPerempuan': int.tryParse(jmlhPerempuanController.text) ?? 0,
        'jmlhLaki': int.tryParse(jmlhLakiController.text) ?? 0,
        'debitAir': debitAirController.text,
        'pemakaianAir': pemakaianAirController.text,
        'sistemPengelolaan': sistemPengelolaanController.text,
        'sumberAir': sumberAirController.text,
        'hargaAir': double.tryParse(hargaAirController.text) ?? 0.0,
        'pH': double.tryParse(pHController.text),
        'TDS': double.tryParse(TDSController.text),
        'EC': double.tryParse(ECController.text),
        'ORP': double.tryParse(ORPController.text),
      };

      Provider.of<InputProvider>(context, listen: false)
          .createFormInput(formData)
          .then((success) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data berhasil dikirim')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengirim data')),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final places = Provider.of<InputProvider>(context).places;
    return Scaffold(
      appBar: AppBar(title: Text('Input Data')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedLocation,
                  hint: Text('Pilih Lokasi'),
                  items: places.map((place) {
                    return DropdownMenuItem<String>(
                      value: place['name'].toString(),
                      child: Text(place['name'].toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLocation = value;
                    });
                  },
                  validator: (value) => value == null ? 'Pilih lokasi' : null,
                ),
                SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: selectedBantuan,
                  hint: Text('Pilih Jenis Bantuan'),
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
                  validator: (value) => value == null ? 'Pilih jenis bantuan' : null,
                ),
                SizedBox(height: 16),
                TextFormField(controller: jmlhBantuanController, decoration: InputDecoration(labelText: 'Jumlah Bantuan')),
                TextFormField(controller: jmlhKKController, decoration: InputDecoration(labelText: 'Jumlah KK')),
                TextFormField(controller: jmlhPerempuanController, decoration: InputDecoration(labelText: 'Jumlah Perempuan')),
                TextFormField(controller: jmlhLakiController, decoration: InputDecoration(labelText: 'Jumlah Laki')),
                TextFormField(controller: debitAirController, decoration: InputDecoration(labelText: 'Debit Air')),
                TextFormField(controller: pemakaianAirController, decoration: InputDecoration(labelText: 'Pemakaian Air')),
                TextFormField(controller: sistemPengelolaanController, decoration: InputDecoration(labelText: 'Sistem Pengelolaan')),
                TextFormField(controller: sumberAirController, decoration: InputDecoration(labelText: 'Sumber Air')),
                TextFormField(controller: hargaAirController, decoration: InputDecoration(labelText: 'Harga Air')),
                TextFormField(controller: pHController, decoration: InputDecoration(labelText: 'pH')),
                TextFormField(controller: TDSController, decoration: InputDecoration(labelText: 'TDS')),
                TextFormField(controller: ECController, decoration: InputDecoration(labelText: 'EC')),
                TextFormField(controller: ORPController, decoration: InputDecoration(labelText: 'ORP')),
                SizedBox(height: 16),

                Text('Latitude: ${latitude ?? "Mengambil..."}'),
                Text('Longitude: ${longitude ?? "Mengambil..."}'),
                SizedBox(height: 16),
                imageFile == null
                    ? Text('Belum ada gambar')
                    : Image.file(imageFile!, height: 100),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      child: Text('Kamera'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: Text('Galeri'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Kirim'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
