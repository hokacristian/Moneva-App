import 'package:flutter/material.dart';
import 'package:moneva/data/services/api_service.dart';
import 'package:moneva/core/utils/sessionmanager.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService;
  final SessionManager sessionManager = SessionManager();

  String? _token;
  String? _errorMessage;
  bool _isLoading = false;

  AuthProvider(this.apiService) {
    initializeAuth(); // Inisialisasi saat aplikasi dibuka
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get token => _token;
  bool get isLoggedIn => _token != null; // Tambahkan pengecekan login

  Future<void> initializeAuth() async {
    _token = await sessionManager.getToken();
    notifyListeners();
  }

  Future<bool> register(String name, String email, String password, String role) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.register(name, email, password, role);
      _isLoading = false;
      notifyListeners();
      return response != null;
    } catch (error) {
      _errorMessage = error.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.login(email, password);
      _token = response['token'];

      await sessionManager.saveToken(_token!); // Simpan token
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _errorMessage = error.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await sessionManager.clearSession();
    _token = null;
    notifyListeners();
  }
}
