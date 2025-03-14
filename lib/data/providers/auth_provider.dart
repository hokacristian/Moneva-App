import 'package:flutter/material.dart';
import 'package:moneva/data/models/user_model.dart';
import 'package:moneva/data/services/api_service.dart';
import 'package:moneva/core/utils/sessionmanager.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService;
  final SessionManager sessionManager = SessionManager();

  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  User? _user;

  User? get user => _user;
  String? get userName => _user?.name;
  String? get userRole => _user?.role;

  AuthProvider(this.apiService) {
    initializeAuth();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _token != null;

  Future<void> initializeAuth() async {
  _token = await sessionManager.getToken();

  // 🔥 Debugging tambahan
  print("✅ Token saat initializeAuth(): $_token"); // Debugging

  if (_token != null) {
    await fetchUserData();
  }
  notifyListeners();
}


   Future<void> fetchUserData() async {
  try {
    final response = await apiService.whoAmI();
    print("User Data from API: $response"); // ✅ Debugging

    _user = User.fromJson(response);
    notifyListeners();
  } catch (e) {
    print("Error fetching user data: $e");
    await logout();
  }
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

    if (response.containsKey('token')) {
      _token = response['token'];
      await sessionManager.saveToken(_token!);

      // 🔥 Debugging tambahan
      final savedToken = await sessionManager.getToken();
      print("✅ Token setelah login dan disimpan: $savedToken"); // Debugging

      await fetchUserData();
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = "Login gagal, response tidak mengandung token";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  } catch (error) {
    _errorMessage = "Terjadi kesalahan: ${error.toString()}";
    print("🚨 Error saat login: $_errorMessage");
    _isLoading = false;
    notifyListeners();
    return false;
  }
}


  Future<void> logout() async {
    await sessionManager.clearSession();
    _token = null;
    _user = null;
    notifyListeners();
  }
}
