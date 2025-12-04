import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class WeatherProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  Weather? _currentWeather;
  List<Forecast> _forecast = [];
  bool _isLoading = false;
  String? _error;
  List<String> _favorites = [];

  Weather? get currentWeather => _currentWeather;
  List<Forecast> get forecast => _forecast;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get favorites => _favorites;

  WeatherProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _favorites = await _storageService.getFavorites();
    notifyListeners();
  }

  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentWeather = await _apiService.fetchWeather(city);
      if (_currentWeather != null) {
        _forecast = await _apiService.fetchForecast(
          _currentWeather!.lat,
          _currentWeather!.lon,
        );
      }
    } catch (e) {
      _error = e.toString();
      _currentWeather = null;
      _forecast = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavorite(String city) async {
    await _storageService.addFavorite(city);
    await _loadFavorites();
  }

  Future<void> removeFavorite(String city) async {
    await _storageService.removeFavorite(city);
    await _loadFavorites();
  }

  bool isFavorite(String city) {
    return _favorites.contains(city);
  }
}
