import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> getWeather(String city) async {
    if (apiKey.isEmpty) {
      print('⚠️ API anahtarı .env dosyasında bulunamadı');
      return {
        'temp': 'N/A',
        'humidity': 'N/A',
        'wind': 'N/A',
      };
    }

    final url = Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric');

    try {
      // İsteğin sonsuza kadar beklemesini önlemek için timeout eklendi
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('İstek zaman aşımına uğradı');
        },
      );

      print('🔵 Durum kodu: ${response.statusCode}');
      print(
          '📦 İçerik: ${response.body.substring(0, min(200, response.body.length))}...');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // API yanıtı doğrulama
        if (data == null) {
          print('⚠️ API boş yanıt döndürdü');
          return {
            'temp': 'N/A',
            'humidity': 'N/A',
            'wind': 'N/A',
          };
        }

        if (data['main'] == null) {
          print('⚠️ API yanıtında "main" verisi yok: ${response.body}');
          return {
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
          'temp': formattedTemp,
          'humidity': humidity?.toString() ?? 'N/A',
          'wind': wind?.toString() ?? 'N/A',
        };
      } else if (response.statusCode == 401) {
        print('⚠️ Geçersiz API anahtarı veya yetkilendirme hatası');
        throw Exception('Geçersiz API anahtarı veya yetkilendirme hatası');
      } else if (response.statusCode == 404) {
        print('⚠️ Şehir bulunamadı: $city');
        throw Exception('Şehir bulunamadı: $city');
      } else {
        print('⚠️ Hata: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Hava durumu verileri yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ getWeather\'da hata yakalandı: $e');
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
      print('❌ getTemperature Hatası: $e');
      return "$city: Hata";
    }
  }
}

// Dart min fonksiyonu
int min(int a, int b) {
  return a < b ? a : b;
}
