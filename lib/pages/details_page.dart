import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../models/weather_model.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final weather = weatherProvider.currentWeather;
    final forecast = weatherProvider.forecast;

    if (weather == null) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: const Center(
            child: Text(
              'No weather data available',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    // Unit Conversion
    double temp = weather.temperature;
    double feelsLike = weather.feelsLike;
    String unit = '°C';
    double windSpeed = weather.windSpeed;
    String windUnit = 'm/s';

    if (!settingsProvider.isMetric) {
      temp = (temp * 9 / 5) + 32;
      feelsLike = (feelsLike * 9 / 5) + 32;
      unit = '°F';
      windSpeed = windSpeed * 2.237;
      windUnit = 'mph';
    }

    final localTime = DateTime.now().toUtc().add(
      Duration(seconds: weather.timezone),
    );
    final dateFormat = DateFormat('EEEE, d MMMM');

    final isFavorite = weatherProvider.isFavorite(weather.cityName);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(weather.cityName, style: AppTheme.titleMedium),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              if (isFavorite) {
                weatherProvider.removeFavorite(weather.cityName);
              } else {
                weatherProvider.addFavorite(weather.cityName);
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 20.0,
              bottom: 50.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(dateFormat.format(localTime), style: AppTheme.bodyMedium),
                const SizedBox(height: 10),
                Image.network(
                  '${Constants.iconUrl}${weather.icon}@4x.png',
                  scale: 0.8,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.cloud,
                      size: 100,
                      color: Colors.white54,
                    );
                  },
                ),
                Text(
                  '${temp.toStringAsFixed(0)}°',
                  style: AppTheme.displayLarge,
                ),
                Text(
                  weather.description.toUpperCase(),
                  style: AppTheme.titleMedium.copyWith(
                    color: AppTheme.accentColor,
                  ),
                ),
                const SizedBox(height: 30),
                GlassContainer(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWeatherInfo(
                        Icons.water_drop,
                        '${weather.humidity}%',
                        'Humidity',
                      ),
                      _buildWeatherInfo(
                        Icons.air,
                        '${windSpeed.toStringAsFixed(1)} $windUnit',
                        'Wind',
                      ),
                      _buildWeatherInfo(
                        Icons.thermostat,
                        '${feelsLike.toStringAsFixed(1)}°',
                        'Feels Like',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Forecast', style: AppTheme.titleMedium),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: forecast.length,
                    itemBuilder: (context, index) {
                      final item = forecast[index];
                      double itemTemp = item.temperature;
                      if (!settingsProvider.isMetric) {
                        itemTemp = (itemTemp * 9 / 5) + 32;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: GlassContainer(
                          width: 100,
                          padding: const EdgeInsets.all(10),
                          color: const Color(
                            0x33362A84,
                          ), // Slightly darker glass
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                DateFormat('E, ha').format(item.date),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              Image.network(
                                '${Constants.iconUrl}${item.icon}.png',
                                width: 40,
                              ),
                              Text(
                                '${itemTemp.toStringAsFixed(0)}°',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
