import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../services/api_service.dart';
import 'details_page.dart';
import 'favorites_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  String? _selectedCountry;
  String? _selectedCity;
  List<String> _countries = [];
  List<String> _cities = [];
  bool _isLoadingCountries = true;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      final countries = await _apiService.fetchCountries();
      setState(() {
        _countries = countries;
        _isLoadingCountries = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCountries = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load countries: $e')));
      }
    }
  }

  Future<void> _loadCities(String country) async {
    try {
      final cities = await _apiService.fetchCitiesForCountry(country);
      setState(() {
        _cities = cities;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load cities: $e')));
      }
    }
  }

  void _searchWeather() async {
    if (_selectedCity != null) {
      final weatherProvider = Provider.of<WeatherProvider>(
        context,
        listen: false,
      );
      await weatherProvider.fetchWeather(_selectedCity!);
      if (mounted) {
        if (weatherProvider.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(weatherProvider.error!)));
        } else if (weatherProvider.currentWeather != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailsPage()),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a country and city')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Weather App', style: AppTheme.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Pick Location', style: AppTheme.titleLarge),
                      const SizedBox(height: 10),
                      Text(
                        'Find the area or the city that you want to know the detailed weather info at this time',
                        textAlign: TextAlign.center,
                        style: AppTheme.bodyMedium,
                      ),
                      const SizedBox(height: 40),
                      GlassContainer(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Country',
                              style: AppTheme.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _isLoadingCountries
                                ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                                : DropdownButtonFormField<String>(
                                  value: _selectedCountry,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.public,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hint: const Text('Choose a country'),
                                  items:
                                      _countries.map((country) {
                                        return DropdownMenuItem(
                                          value: country,
                                          child: Text(country),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCountry = value;
                                      _selectedCity = null;
                                      _cities =
                                          []; // Clear cities when country changes
                                    });
                                    if (value != null) {
                                      _loadCities(value);
                                    }
                                  },
                                ),
                            const SizedBox(height: 20),
                            Text(
                              'Select City',
                              style: AppTheme.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              value: _selectedCity,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: const Icon(
                                  Icons.location_city,
                                  color: Colors.grey,
                                ),
                              ),
                              hint: const Text('Choose a city'),
                              items:
                                  _cities.map((city) {
                                    return DropdownMenuItem(
                                      value: city,
                                      child: Text(city),
                                    );
                                  }).toList(),
                              onChanged:
                                  _selectedCountry == null
                                      ? null
                                      : (value) {
                                        setState(() {
                                          _selectedCity = value;
                                        });
                                      },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _searchWeather,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Search',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      Consumer<WeatherProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoading) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Developer Info Footer
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  const Divider(color: Colors.white24, thickness: 1),
                  const SizedBox(height: 5),
                  Text(
                    'Development by Mohamed Osama',
                    style: AppTheme.bodyMedium.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'ID: 2305180',
                    style: AppTheme.bodyMedium.copyWith(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
