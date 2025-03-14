import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moneva/data/services/api_service.dart';
import 'auth_provider.dart';

class InputProvider extends ChangeNotifier {
  final ApiService apiService;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _formInput;
  List<Map<String, dynamic>> _allFormInputs = [];
  List<Map<String, dynamic>> _places = [];


  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get formInput => _formInput;
  List<Map<String, dynamic>> get allFormInputs => _allFormInputs;
  List<Map<String, dynamic>> get places => _places;


  InputProvider(this.apiService);

  Future<void> fetchFormInput(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _formInput = await apiService.getFormInput(id);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // 🔥 FETCH ALL FORM INPUTS
  Future<void> fetchAllFormInputs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allFormInputs = await apiService.getAllFormInputs();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createFormInput(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
        await apiService.postFormInput(data); // ✅ Kirim tanpa userId
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


  Future<bool> updateFormInput(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await apiService.updateFormInput(id, data);
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

   // 🔥 Fetch Places
  Future<void> fetchPlaces() async {
    _isLoading = true;
    notifyListeners();

    try {
      _places = await apiService.fetchPlaces();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

}
