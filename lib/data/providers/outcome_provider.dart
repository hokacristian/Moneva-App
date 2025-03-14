import 'package:flutter/material.dart';
import 'package:moneva/data/services/api_service.dart';

class OutcomeProvider extends ChangeNotifier {
  final ApiService apiService;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _outcome;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get outcome => _outcome;

  OutcomeProvider(this.apiService);

  // ✅ Ambil Outcome berdasarkan ID
  Future<void> fetchOutcome(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _outcome = await apiService.getOutcome(id);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // ✅ Buat Outcome baru
  Future<bool> createOutcome(int formInputId, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await apiService.postOutcome(formInputId, data);
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

  // ✅ Update Outcome
  Future<bool> updateOutcome(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await apiService.updateOutcome(id, data);
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
