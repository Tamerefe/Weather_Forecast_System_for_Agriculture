import 'dart:convert';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class WeatherService {
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // Background isolate function
  static Future<Map<String, dynamic>> _fetchWeatherInBackground(
      Map<String, String> params) async {
    final url = Uri.parse(
        '${params['baseUrl']}?q=${params['city']}&appid=${params['apiKey']}&units=metric');

    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 5), // Reduced timeout
        onTimeout: () {
          throw Exception('İstek zaman aşımına uğradı');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data == null || data['main'] == null) {
          return {
            'success': false,
            'temp': 'N/A',
            'humidity': 'N/A',
            'wind': 'N/A',
          };
        }

        final temp = data['main']?['temp'];
        final humidity = data['main']?['humidity'];
        final wind = data['wind']?['speed'];

        String formattedTemp =
            temp != null ? (temp as num).toStringAsFixed(1) : 'N/A';

        return {
          'success': true,
          'temp': formattedTemp,
          'humidity': humidity?.toString() ?? 'N/A',
          'wind': wind?.toString() ?? 'N/A',
        };
      } else {
        return {
          'success': false,
          'error': response.statusCode.toString(),
          'temp': 'Hata',
          'humidity': 'N/A',
          'wind': 'N/A',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'temp': 'Hata',
        'humidity': 'N/A',
        'wind': 'N/A',
      };
    }
  }

  Future<Map<String, dynamic>> getWeather(String city) async {
    if (apiKey.isEmpty) {
      logger.i('⚠️ API anahtarı .env dosyasında bulunamadı');
      return {
        'temp': 'N/A',
        'humidity': 'N/A',
        'wind': 'N/A',
      };
    }

    try {
      // Use isolate for background processing to avoid blocking UI
      final params = {
        'baseUrl': baseUrl,
        'city': city,
        'apiKey': apiKey,
      };

      final result = await Isolate.run(() => _fetchWeatherInBackground(params));

      logger.i('🔵 Weather data fetched: ${result['temp']}');
      return result;
    } catch (e) {
      logger.i('⚠️ getWeather\'da hata yakalandı: $e');
      return {
        'temp': 'Hata',
        'humidity': 'N/A',
        'wind': 'N/A',
      };
    }
  }

  Future<String> getTemperature(String city) async {
    try {
      final weather = await getWeather(city);
      return "$city: ${weather['temp']}°C";
    } catch (e) {
      logger.i('❌ getTemperature Hatası: $e');
      return "$city: Hata";
    }
  }

  // Cache for better performance
  static final Map<String, dynamic> _weatherCache = {};
  static DateTime? _lastCacheTime;

  Future<Map<String, dynamic>> getCachedWeather(String city) async {
    final now = DateTime.now();
    const cacheTimeout = Duration(minutes: 10);

    // Check if cache is still valid
    if (_lastCacheTime != null &&
        now.difference(_lastCacheTime!) < cacheTimeout &&
        _weatherCache.containsKey(city)) {
      return _weatherCache[city];
    }

    // Fetch new data
    final weather = await getWeather(city);
    _weatherCache[city] = weather;
    _lastCacheTime = now;

    return weather;
  }
}

// Dart min fonksiyonu
int min(int a, int b) {
  return a < b ? a : b;
}
