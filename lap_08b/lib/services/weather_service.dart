import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_models.dart';

class WeatherService {
  final http.Client client;

  WeatherService({http.Client? client}) : client = client ?? http.Client();

  /// Preset famous cities in Vietnam and worldwide
  static const List<City> presetCities = [
    City(name: 'Hanoi', country: 'Vietnam', latitude: 21.0285, longitude: 105.8542),
    City(name: 'Ho Chi Minh City', country: 'Vietnam', latitude: 10.8231, longitude: 106.6297),
    City(name: 'Da Nang', country: 'Vietnam', latitude: 16.0544, longitude: 108.2022),
    City(name: 'Tokyo', country: 'Japan', latitude: 35.6762, longitude: 139.6503),
    City(name: 'London', country: 'United Kingdom', latitude: 51.5074, longitude: -0.1278),
    City(name: 'New York', country: 'United States', latitude: 40.7128, longitude: -74.0060),
    City(name: 'Paris', country: 'France', latitude: 48.8566, longitude: 2.3522),
  ];

  /// Fetch real-time weather from Open-Meteo REST API
  Future<CurrentWeather> fetchWeather(double latitude, double longitude) async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?'
      'latitude=$latitude&longitude=$longitude'
      '&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,wind_speed_10m'
      '&timezone=auto',
    );

    try {
      final response = await client.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;
        final currentJson = data['current'] as Map<String, dynamic>;
        return CurrentWeather.fromJson(currentJson);
      } else {
        throw Exception('API returned status ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to connect to weather service: $e');
    }
  }

  /// Optional: Real-time city search via Open-Meteo Geocoding REST API
  Future<List<City>> searchCities(String query) async {
    if (query.trim().isEmpty) return presetCities;

    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(query)}&count=5&language=en&format=json',
    );

    try {
      final response = await client.get(url).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>?;
        if (results == null || results.isEmpty) {
          return [];
        }
        return results
            .map((item) => City.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Fallback to filtering preset cities locally
    }

    return presetCities
        .where((c) =>
            c.name.toLowerCase().contains(query.toLowerCase()) ||
            c.country.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
