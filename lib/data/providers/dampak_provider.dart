import 'package:flutter/material.dart';
import 'package:moneva/data/services/api_service.dart';

class DampakProvider extends ChangeNotifier {
  final ApiService apiService;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _dampak;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get dampak => _dampak;

  DampakProvider(this.apiService);

  // ✅ Ambil Dampak berdasarkan ID
  Future<void> fetchDampak(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _dampak = await apiService.getDampak(id);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // ✅ Buat Dampak baru
  Future<bool> createDampak(int formInputId, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await apiService.postDampak(formInputId, data);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ✅ Update Dampak
  Future<bool> updateDampak(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await apiService.updateDampak(id, data);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
