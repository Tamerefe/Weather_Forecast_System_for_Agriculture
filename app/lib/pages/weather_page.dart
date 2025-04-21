import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/app_header.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<String>> _events = {};

  void _addEvent(BuildContext context) async {
    final TextEditingController _controller = TextEditingController();
    if (_selectedDay == null) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Event"),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(
              hintText: "Enter event (e.g., Harvest, Prune)"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final text = _controller.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  _events[_selectedDay!] = [...?_events[_selectedDay!], text];
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  void _onForecastTap(BuildContext context, String day) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Tapped forecast for $day")),
    );
  }

  void _onCompareTap(BuildContext context, String day) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Compare: $day")),
    );
  }

  void _onDetailTap(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Detail: $label")),
    );
  }

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
                  _buildCalendarSection(),
                  const SizedBox(height: 16),
                  _buildWeeklyWeatherForecast(context),
                  const SizedBox(height: 16),
                  _buildComparisonByDay(context),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              _onDetailTap(context, 'Precipitation Total'),
                          child: _buildPrecipitationTotal(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              _onDetailTap(context, 'Temperatures Today'),
                          child: _buildTemperaturesToday(),
                        ),
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

  Widget _buildCalendarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Harvest & Farm Calendar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () => _addEvent(context),
              child: const Text("Add Event"),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          eventLoader: _getEventsForDay,
        ),
        const SizedBox(height: 10),
        ..._getEventsForDay(_selectedDay ?? _focusedDay).map(
          (event) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const Icon(Icons.agriculture, size: 18, color: Colors.green),
                const SizedBox(width: 8),
                Text(event, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyWeatherForecast(BuildContext context) {
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
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Weekly Weather Forecast for",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const Text("Agricultural Activities",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: days.map((day) {
                IconData weatherIcon;
                final condition = day['condition']!.toLowerCase();
                if (condition.contains('cloud')) {
                  weatherIcon = Icons.cloud;
                } else if (condition.contains('rain') ||
                    condition.contains('shower')) {
                  weatherIcon = Icons.grain;
                } else if (condition.contains('wind')) {
                  weatherIcon = Icons.air;
                } else if (condition.contains('sun')) {
                  weatherIcon = Icons.wb_sunny;
                } else {
                  weatherIcon = Icons.cloud_queue;
                }

                return GestureDetector(
                  onTap: () => _onForecastTap(context, day['day']!),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(day['day']!,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white)),
                        ),
                        SizedBox(
                          width: 70,
                          child: Text("${day['high']} ${day['low']}",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white)),
                        ),
                        Icon(weatherIcon, color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(day['condition']!,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonByDay(BuildContext context) {
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
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weather Comparison',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 16),
          Row(
            children: weatherData.map((data) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onCompareTap(context, data['day']!.toString()),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: data['day'] == 'Today'
                          ? Colors.green.withOpacity(0.8)
                          : Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: data['day'] == 'Today'
                          ? Border.all(color: Colors.lightGreenAccent, width: 2)
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(data['day']!.toString(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: data['day'] == 'Today'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: Colors.black)),
                        const SizedBox(height: 8),
                        _buildWeatherDisplay(data),
                        const SizedBox(height: 12),
                        _buildWeatherDetailRow(
                            'Humidity', data['humidity']!.toString()),
                        const SizedBox(height: 6),
                        _buildWeatherDetailRow(
                            'Rain', data['precipitation']!.toString()),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // New helper method to display weather information
  Widget _buildWeatherDisplay(Map<String, Object> data) {
    final isToday = data['day'] == 'Today';
    return Column(
      children: [
        Icon(
          data['icon'] as IconData,
          size: 36,
          color: isToday ? Colors.lightGreenAccent : Colors.black54,
        ),
        const SizedBox(height: 8),
        Text(
          data['temp']!.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isToday ? Colors.lightGreenAccent : Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          data['condition']!.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildWeatherDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        Text(value,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
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
          children: const [
            Text('Precipitation Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text('25mm',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('This Week'),
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
          children: const [
            Text('Temperatures Today',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text('High: 24°C', style: TextStyle(fontSize: 18)),
                  Text('Low: 16°C', style: TextStyle(fontSize: 18)),
                  Text('Avg: 20°C', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
