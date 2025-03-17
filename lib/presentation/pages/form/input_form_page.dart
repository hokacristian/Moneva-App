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
    Future.microtask(
        () => Provider.of<InputProvider>(context, listen: false).fetchPlaces());
    _requestLocationPermission();
  }

  // Fungsi untuk meminta izin lokasi
  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Izin lokasi ditolak secara permanen.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _getCurrentLocation();
    }
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
        'debitAir':
            debitAirController.text.isNotEmpty ? debitAirController.text : "0",
        'pemakaianAir': pemakaianAirController.text,
        'sistemPengelolaan': sistemPengelolaanController.text,
        'sumberAir': sumberAirController.text,
        'hargaAir': double.tryParse(hargaAirController.text) ?? 0.0,
        'pH': double.tryParse(pHController.text) ?? 0.0,
        'TDS': double.tryParse(TDSController.text) ?? 0.0,
        'EC': double.tryParse(ECController.text) ?? 0.0,
        'ORP': double.tryParse(ORPController.text) ?? 0.0,
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

  // Tampilkan dialog untuk menambah lokasi
  void _showAddLocationDialog() {
    final TextEditingController locationController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Tambah Lokasi"),
          content: TextField(
            controller: locationController,
            decoration: InputDecoration(hintText: "Masukkan nama lokasi"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Batal
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                final newLocation = locationController.text.trim();
                if (newLocation.isNotEmpty) {
                  Provider.of<InputProvider>(context, listen: false)
                      .createPlace({"name": newLocation}).then((success) {
                    if (success) {
                      // Jangan update selectedLocation secara otomatis
                      // Jangan panggil fetchPlaces di sini
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Lokasi berhasil ditambahkan")),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Gagal menambahkan lokasi")),
                      );
                    }
                  });
                }
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final places = Provider.of<InputProvider>(context).places;

    // Filter daftar lokasi agar hanya muncul lokasi dengan nama unik
    final uniquePlaces =
        places.fold<List<Map<String, dynamic>>>([], (acc, element) {
      if (!acc.any((item) => item['name'] == element['name'])) {
        acc.add(element);
      }
      return acc;
    });

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
                  onTap: () {
                    Provider.of<InputProvider>(context, listen: false)
                        .fetchPlaces();
                  },
                  items: uniquePlaces.map((place) {
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
                ),

                // Tombol Tambah Lokasi
                TextButton.icon(
                  onPressed: _showAddLocationDialog,
                  icon: Icon(Icons.add),
                  label: Text("Tambah Lokasi"),
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
                  validator: (value) =>
                      value == null ? 'Pilih jenis bantuan' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: jmlhBantuanController,
                  decoration: InputDecoration(labelText: 'Jumlah Bantuan'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: jmlhKKController,
                  decoration: InputDecoration(labelText: 'Jumlah KK'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: jmlhPerempuanController,
                  decoration: InputDecoration(labelText: 'Jumlah Perempuan'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: jmlhLakiController,
                  decoration: InputDecoration(labelText: 'Jumlah Laki'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: debitAirController,
                  decoration: InputDecoration(
                      labelText: 'Jumlah debit air yang dihasilkan (l)'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: pemakaianAirController,
                  decoration: InputDecoration(
                      labelText: 'Pemakaian Air(Untuk keperluan apa saja)'),
                ),
                TextFormField(
                  controller: sistemPengelolaanController,
                  decoration: InputDecoration(
                      labelText:
                          'Sistem pengelolaan sanitasi dan sarana air bersih'),
                ),
                TextFormField(
                  controller: sumberAirController,
                  decoration: InputDecoration(labelText: 'Sumber Air'),
                ),
                TextFormField(
                  controller: hargaAirController,
                  decoration:
                      InputDecoration(labelText: 'Harga Air yang dibayar'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                TextFormField(
                  controller: pHController,
                  decoration: InputDecoration(labelText: 'pH'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: TDSController,
                  decoration: InputDecoration(labelText: 'TDS(ppm)'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: ECController,
                  decoration: InputDecoration(labelText: 'EC(µS/cm)'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: ORPController,
                  decoration: InputDecoration(labelText: 'ORP(mV)'),
                  keyboardType: TextInputType.number,
                ),
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
