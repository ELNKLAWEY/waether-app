class Weather {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final double humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final int sunrise;
  final int sunset;
  final int timezone;
  final double lat;
  final double lon;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.sunrise,
    required this.sunset,
    required this.timezone,
    required this.lat,
    required this.lon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: (json['main']['humidity'] as num).toDouble(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      timezone: json['timezone'],
      lat: (json['coord']['lat'] as num).toDouble(),
      lon: (json['coord']['lon'] as num).toDouble(),
    );
  }
}

class Forecast {
  final DateTime date;
  final double temperature;
  final String description;
  final String icon;

  Forecast({
    required this.date,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: true),
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}
