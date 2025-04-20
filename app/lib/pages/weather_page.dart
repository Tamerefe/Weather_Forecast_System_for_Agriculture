import 'package:flutter/material.dart';
import '../widgets/app_header.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildWeeklyWeatherForecast(),
                  const SizedBox(height: 16),
                  _buildComparisonByDay(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPrecipitationTotal(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTemperaturesToday(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyWeatherForecast() {
    final days = [
      {
        'day': 'Saturday',
        'high': '21°',
        'low': '11°',
        'condition': 'Increasing clouds'
      },
      {
        'day': 'Sunday',
        'high': '20°',
        'low': '9°',
        'condition': 'Mostly cloudy'
      },
      {
        'day': 'Monday',
        'high': '17°',
        'low': '8°',
        'condition': 'Scattered showers'
      },
      {
        'day': 'Tuesday',
        'high': '19°',
        'low': '10°',
        'condition': 'Hazy sunshine'
      },
      {'day': 'Wednesday', 'high': '19°', 'low': '9°', 'condition': 'Windy'},
      {
        'day': 'Thursday',
        'high': '14°',
        'low': '8°',
        'condition': 'Light Rain'
      },
      {'day': 'Friday', 'high': '15°', 'low': '9°', 'condition': 'Cloudy'},
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Weekly Weather Forecast for",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Text(
            "Agricultural Activities",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: days.map((day) {
                IconData weatherIcon;
                if (day['condition']!.contains('cloud')) {
                  weatherIcon = Icons.cloud;
                } else if (day['condition']!.contains('Rain') ||
                    day['condition']!.contains('shower')) {
                  weatherIcon = Icons.grain;
                } else if (day['condition']!.contains('Wind') ||
                    day['condition']!.contains('wind')) {
                  weatherIcon = Icons.air;
                } else if (day['condition']!.contains('sun') ||
                    day['condition']!.contains('Sun')) {
                  weatherIcon = Icons.wb_sunny;
                } else {
                  weatherIcon = Icons.cloud_queue;
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          day['day']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: Text(
                          "${day['high']} ${day['low']}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Icon(
                        weatherIcon,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          day['condition']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonByDay() {
    final weatherData = [
      {
        'day': 'Yesterday',
        'temp': '22°C',
        'condition': 'Mostly Sunny',
        'humidity': '68%',
        'precipitation': '0mm',
        'icon': Icons.wb_sunny,
      },
      {
        'day': 'Today',
        'temp': '16°C',
        'condition': 'Scattered Showers',
        'humidity': '85%',
        'precipitation': '12mm',
        'icon': Icons.grain,
      },
      {
        'day': 'Tomorrow',
        'temp': '19°C',
        'condition': 'Partly Cloudy',
        'humidity': '72%',
        'precipitation': '2mm',
        'icon': Icons.cloud,
      },
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weather Comparison',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: weatherData.map((data) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: data['day'] == 'Today'
                        ? Colors.green.withOpacity(0.2)
                        : Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: data['day'] == 'Today'
                        ? Border.all(color: Colors.green, width: 2)
                        : null,
                  ),
                  child: Column(
                    children: [
                      Text(
                        data['day']! as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: data['day'] == 'Today'
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Icon(
                        data['icon'] as IconData,
                        size: 36,
                        color: data['day'] == 'Today'
                            ? Colors.green
                            : Colors.black54,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['temp']! as String,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: data['day'] == 'Today'
                              ? Colors.green
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data['condition']! as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildWeatherDetailRow(
                          'Humidity', data['humidity']! as String),
                      const SizedBox(height: 6),
                      _buildWeatherDetailRow(
                          'Rain', data['precipitation']! as String),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPrecipitationTotal() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Precipitation Total',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  const Text('25mm',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('This Week'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperaturesToday() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Temperatures Today',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  const Text('High: 24°C', style: TextStyle(fontSize: 18)),
                  const Text('Low: 16°C', style: TextStyle(fontSize: 18)),
                  const Text('Avg: 20°C', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
