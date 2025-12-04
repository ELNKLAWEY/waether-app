import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  bool _isMetric = true;

  bool get isMetric => _isMetric;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _isMetric = await _storageService.isMetric();
    notifyListeners();
  }

  Future<void> toggleUnit() async {
    _isMetric = !_isMetric;
    await _storageService.setMetric(_isMetric);
    notifyListeners();
  }
}
