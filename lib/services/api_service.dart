import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../utils/constants.dart';

class ApiService {
  Future<Weather> fetchWeather(String city) async {
    final url = Uri.parse(
      '${Constants.baseUrl}?q=$city&appid=${Constants.apiKey}&units=metric',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('City not found');
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<Forecast>> fetchForecast(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=${Constants.apiKey}&units=metric',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> list = data['list'];
      return list.map((e) => Forecast.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  Future<List<String>> fetchCountries() async {
    try {
      final url = Uri.parse('https://restcountries.com/v3.1/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final countries =
            data.map((country) => country['name']['common'] as String).toList()
              ..sort();
        return countries;
      } else {
        return _getFallbackCountries();
      }
    } catch (e) {
      return _getFallbackCountries();
    }
  }

  List<String> _getFallbackCountries() {
    return [
      'Afghanistan',
      'Albania',
      'Algeria',
      'Argentina',
      'Australia',
      'Austria',
      'Bahrain',
      'Bangladesh',
      'Belgium',
      'Brazil',
      'Canada',
      'Chile',
      'China',
      'Colombia',
      'Croatia',
      'Czech Republic',
      'Denmark',
      'Egypt',
      'Finland',
      'France',
      'Germany',
      'Greece',
      'Hungary',
      'Iceland',
      'India',
      'Indonesia',
      'Iran',
      'Iraq',
      'Ireland',
      'Israel',
      'Italy',
      'Japan',
      'Jordan',
      'Kenya',
      'Kuwait',
      'Lebanon',
      'Libya',
      'Malaysia',
      'Mexico',
      'Morocco',
      'Netherlands',
      'New Zealand',
      'Nigeria',
      'Norway',
      'Oman',
      'Pakistan',
      'Palestine',
      'Peru',
      'Philippines',
      'Poland',
      'Portugal',
      'Qatar',
      'Romania',
      'Russia',
      'Saudi Arabia',
      'Serbia',
      'Singapore',
      'South Africa',
      'South Korea',
      'Spain',
      'Sudan',
      'Sweden',
      'Switzerland',
      'Syria',
      'Taiwan',
      'Thailand',
      'Tunisia',
      'Turkey',
      'Ukraine',
      'United Arab Emirates',
      'United Kingdom',
      'United States',
      'Venezuela',
      'Vietnam',
      'Yemen',
    ];
  }

  Future<List<String>> fetchCitiesForCountry(String country) async {
    final Map<String, List<String>> majorCities = {
      'Egypt': [
        'Cairo',
        'Alexandria',
        'Giza',
        'Luxor',
        'Aswan',
        'Port Said',
        'Suez',
        'Mansoura',
        'Tanta',
        'Asyut',
      ],
      'United States': [
        'New York',
        'Los Angeles',
        'Chicago',
        'Houston',
        'Miami',
        'San Francisco',
        'Boston',
        'Seattle',
      ],
      'United Kingdom': [
        'London',
        'Manchester',
        'Birmingham',
        'Liverpool',
        'Edinburgh',
        'Glasgow',
        'Bristol',
      ],
      'France': [
        'Paris',
        'Marseille',
        'Lyon',
        'Toulouse',
        'Nice',
        'Nantes',
        'Strasbourg',
      ],
      'Germany': [
        'Berlin',
        'Munich',
        'Hamburg',
        'Frankfurt',
        'Cologne',
        'Stuttgart',
        'Dusseldorf',
      ],
      'Italy': [
        'Rome',
        'Milan',
        'Naples',
        'Turin',
        'Florence',
        'Venice',
        'Bologna',
      ],
      'Spain': [
        'Madrid',
        'Barcelona',
        'Valencia',
        'Seville',
        'Bilbao',
        'Malaga',
        'Zaragoza',
      ],
      'Japan': [
        'Tokyo',
        'Osaka',
        'Kyoto',
        'Yokohama',
        'Nagoya',
        'Sapporo',
        'Fukuoka',
      ],
      'China': [
        'Beijing',
        'Shanghai',
        'Guangzhou',
        'Shenzhen',
        'Chengdu',
        'Hangzhou',
        'Wuhan',
      ],
      'India': [
        'Mumbai',
        'Delhi',
        'Bangalore',
        'Hyderabad',
        'Chennai',
        'Kolkata',
        'Pune',
      ],
      'Canada': [
        'Toronto',
        'Montreal',
        'Vancouver',
        'Calgary',
        'Ottawa',
        'Edmonton',
        'Winnipeg',
      ],
      'Australia': [
        'Sydney',
        'Melbourne',
        'Brisbane',
        'Perth',
        'Adelaide',
        'Gold Coast',
        'Canberra',
      ],
      'Saudi Arabia': [
        'Riyadh',
        'Jeddah',
        'Mecca',
        'Medina',
        'Dammam',
        'Khobar',
        'Tabuk',
      ],
      'United Arab Emirates': [
        'Dubai',
        'Abu Dhabi',
        'Sharjah',
        'Ajman',
        'Ras Al Khaimah',
        'Fujairah',
      ],
      'Qatar': ['Doha', 'Al Wakrah', 'Al Rayyan', 'Umm Salal'],
      'Kuwait': ['Kuwait City', 'Hawalli', 'Salmiya', 'Farwaniya'],
      'Bahrain': ['Manama', 'Riffa', 'Muharraq', 'Hamad Town'],
      'Oman': ['Muscat', 'Salalah', 'Sohar', 'Nizwa'],
      'Lebanon': ['Beirut', 'Tripoli', 'Sidon', 'Tyre'],
      'Jordan': ['Amman', 'Zarqa', 'Irbid', 'Aqaba'],
      'Palestine': ['Gaza', 'Ramallah', 'Hebron', 'Nablus'],
      'Syria': ['Damascus', 'Aleppo', 'Homs', 'Latakia'],
      'Iraq': ['Baghdad', 'Basra', 'Mosul', 'Erbil'],
      'Turkey': ['Istanbul', 'Ankara', 'Izmir', 'Bursa', 'Antalya'],
      'Morocco': ['Casablanca', 'Rabat', 'Marrakech', 'Fez', 'Tangier'],
      'Tunisia': ['Tunis', 'Sfax', 'Sousse', 'Kairouan'],
      'Algeria': ['Algiers', 'Oran', 'Constantine', 'Annaba'],
      'Libya': ['Tripoli', 'Benghazi', 'Misrata', 'Bayda'],
      'Sudan': ['Khartoum', 'Omdurman', 'Port Sudan', 'Kassala'],
      'Yemen': ['Sanaa', 'Aden', 'Taiz', 'Hodeidah'],
    };

    return majorCities[country] ?? [country];
  }
}
