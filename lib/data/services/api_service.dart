import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:moneva/core/utils/sessionmanager.dart';

class ApiService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final SessionManager sessionManager = SessionManager();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"email": email, "password": password}),
    );

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

     Future<Map<String, dynamic>> whoAmI() async {
    final token = await sessionManager.getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/auth/whoami'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    print("Response dari /whoami: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error whoAmI: ${response.body}"); // ✅ Debug error
      throw Exception('Failed to fetch user data');
    }
  }

  Future<Map<String, dynamic>?> register(
      String name, String email, String password, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "role": role,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Register failed: ${response.body}');
    }
  }

  // 🔥 GET ALL FORM INPUTS
  Future<List<Map<String, dynamic>>> getAllFormInputs() async {
    final response = await http.get(
      Uri.parse('$baseUrl/form/input'),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('Gagal mengambil semua FormInput');
    }
  }

   Future<Map<String, dynamic>> postFormInput(Map<String, dynamic> data) async {
  final token = await sessionManager.getToken();

  if (token == null) {
    print("🚨 Token tidak ditemukan di SessionManager!"); // Debugging
    throw Exception("Token tidak ditemukan. Silakan login ulang.");
  }

  print("✅ Token yang dikirim ke API: $token"); // Debugging

  var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/form/input'));
  request.headers['Authorization'] = 'Bearer $token';
  request.headers['Content-Type'] = 'application/json';

  data.forEach((key, value) {
    if (key != 'img') {
      request.fields[key] = value.toString();
    }
  });

  if (data['img'] != null) {
    request.files.add(await http.MultipartFile.fromPath('img', data['img']));
  }

  final response = await request.send();
  final responseBody = await response.stream.bytesToString();

  if (response.statusCode == 201) {
    return jsonDecode(responseBody);
  } else {
    print("🚨 Error Response dari API: $responseBody"); // Debugging
    throw Exception('Gagal menambahkan FormInput: $responseBody');
  }
}




  Future<Map<String, dynamic>> getFormInput(int id) async {
  final response = await http.get(
    Uri.parse('$baseUrl/form/input/$id'),
    headers: {"Content-Type": "application/json"},
  );

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    // Ambil objek di dalam "data" agar langsung sesuai dengan struktur yang diinginkan UI
    return decoded["data"]; 
  } else {
    throw Exception('Gagal mendapatkan FormInput');
  }
}


  // Future<http.Response> updateFormInput(int id, Map<String, dynamic> data) async {
  //   final url = Uri.parse('$baseUrl/form/input/$id'); // Sesuaikan endpoint API
  //   final response = await http.patch(
  //     url,
  //     headers: {
  //       "Content-Type": "application/json",
  //     },
  //     body: jsonEncode(data),
  //   );

  //   return response;
  // }

  Future<http.Response> updateFormInput(int id, Map<String, dynamic> data, File? image) async {
  final token = await sessionManager.getToken();
  if (token == null) throw Exception("Token tidak ditemukan. Silakan login ulang.");

  var request = http.MultipartRequest('PATCH', Uri.parse('$baseUrl/form/input/$id'));
  request.headers['Authorization'] = 'Bearer $token';
  // Jangan set Content-Type secara manual untuk MultipartRequest

  // Tambahkan semua field kecuali "img"
  data.forEach((key, value) {
    if (key != 'img' && value != null) {
      request.fields[key] = value.toString();
    }
  });

  // Jika ada gambar baru, tambahkan sebagai file multipart
  if (image != null) {
    request.files.add(await http.MultipartFile.fromPath('img', image.path));
  } else if (data['img'] != null) {
    // Jika tidak ada gambar baru, tambahkan field 'img' dengan URL lama
    request.fields['img'] = data['img'].toString();
  }

  final streamedResponse = await request.send();
  return await http.Response.fromStream(streamedResponse);
}



   // ✅ POST Dampak
  Future<Map<String, dynamic>> postDampak(int formInputId, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/form/dampak/$formInputId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal menambahkan Dampak: ${response.body}');
    }
  }

  // ✅ PATCH Dampak
  Future<Map<String, dynamic>> updateDampak(int id, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/form/dampak/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memperbarui Dampak: ${response.body}');
    }
  }

  // ✅ GET Dampak
  Future<Map<String, dynamic>> getDampak(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/form/dampak/$id'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mendapatkan Dampak');
    }
  }

  // ✅ POST Outcome
  Future<Map<String, dynamic>> postOutcome(int formInputId, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/form/outcome/$formInputId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal menambahkan Outcome: ${response.body}');
    }
  }

  // ✅ PATCH Outcome
  Future<Map<String, dynamic>> updateOutcome(int id, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/form/outcome/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memperbarui Outcome: ${response.body}');
    }
  }

  // ✅ GET Outcome
  Future<Map<String, dynamic>> getOutcome(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/form/outcome/$id'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mendapatkan Outcome');
    }
  }

  // 🔥 GET Places (Daftar Lokasi)
  Future<List<Map<String, dynamic>>> fetchPlaces() async {
    final response = await http.get(Uri.parse('$baseUrl/places'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((place) => {
            'id': place['id'],
            'name': place['name'],
          }).toList();
    } else {
      throw Exception('Gagal mendapatkan daftar tempat');
    }
  }

  Future<Map<String, dynamic>> postPlace(Map<String, dynamic> data) async {
  final url = Uri.parse('$baseUrl/places');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );
  if (response.statusCode == 201) {
    final decoded = jsonDecode(response.body);
    return decoded['data']; // Hanya kembalikan data
  } else {
    throw Exception("Gagal menambah lokasi: ${response.body}");
  }
}


}
