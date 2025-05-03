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
  // Updated events structure to store more information
  final Map<DateTime, List<Map<String, dynamic>>> _events = {};
  bool _isRefreshing = false;

  void _addEvent(BuildContext context) async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController notesController = TextEditingController();

    if (_selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a day first")),
      );
      return;
    }

    // Default values
    String selectedCategory = 'Harvest';
    TimeOfDay selectedTime = TimeOfDay.now();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Add Farm Event"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event title
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Event Title",
                    hintText: "Enter event title",
                  ),
                ),
                const SizedBox(height: 12),

                // Category dropdown
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: "Category",
                  ),
                  items: [
                    'Harvest',
                    'Planting',
                    'Pruning',
                    'Fertilizing',
                    'Irrigation',
                    'Pest Control',
                    'Other'
                  ]
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCategory = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),

                // Time picker
                ListTile(
                  title: const Text("Time"),
                  subtitle: Text(selectedTime.format(context)),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),

                // Notes field
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: "Notes",
                    hintText: "Add additional details",
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                if (title.isNotEmpty) {
                  setState(() {
                    // Create normalized day without time component
                    final normalizedDay = DateTime.utc(_selectedDay!.year,
                        _selectedDay!.month, _selectedDay!.day);

                    // Create event data
                    final eventData = {
                      'title': title,
                      'category': selectedCategory,
                      'time': selectedTime.format(context),
                      'notes': notesController.text.trim(),
                    };

                    // Add to events map
                    if (_events.containsKey(normalizedDay)) {
                      _events[normalizedDay]!.add(eventData);
                    } else {
                      _events[normalizedDay] = [eventData];
                    }
                  });
                  Navigator.pop(context);
                } else {
                  // Show error if title is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please enter an event title")),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  // Updated to handle new event data structure
  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
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
                  _buildCurrentWeather(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F2027), Color(0xFF203A43)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
            eventLoader: (day) => _getEventsForDay(day),
          ),
          const SizedBox(height: 10),

          // Display events with more details
          ..._getEventsForDay(_selectedDay ?? _focusedDay).map(
            (event) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Card(
                elevation: 2,
                child: ListTile(
                  leading: _getCategoryIcon(event['category']),
                  title: Text(event['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${event['category']} at ${event['time']}"),
                      if (event['notes'].isNotEmpty)
                        Text(event['notes'],
                            style:
                                const TextStyle(fontStyle: FontStyle.italic)),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        _deleteEvent(_selectedDay ?? _focusedDay, event),
                  ),
                  isThreeLine: event['notes'].isNotEmpty,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get appropriate icon for event category
  Widget _getCategoryIcon(String category) {
    IconData iconData;
    Color iconColor;

    switch (category) {
      case 'Harvest':
        iconData = Icons.agriculture;
        iconColor = Colors.orange;
        break;
      case 'Planting':
        iconData = Icons.grass;
        iconColor = Colors.green;
        break;
      case 'Pruning':
        iconData = Icons.content_cut;
        iconColor = Colors.blueGrey;
        break;
      case 'Fertilizing':
        iconData = Icons.spa;
        iconColor = Colors.brown;
        break;
      case 'Irrigation':
        iconData = Icons.water_drop;
        iconColor = Colors.blue;
        break;
      case 'Pest Control':
        iconData = Icons.bug_report;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.event;
        iconColor = Colors.purple;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.2),
      child: Icon(iconData, color: iconColor),
    );
  }

  // Method to delete an event
  void _deleteEvent(DateTime day, Map<String, dynamic> eventToDelete) {
    setState(() {
      final normalizedDay = DateTime.utc(day.year, day.month, day.day);
      if (_events.containsKey(normalizedDay)) {
        _events[normalizedDay]!.removeWhere((event) =>
            event['title'] == eventToDelete['title'] &&
            event['time'] == eventToDelete['time']);

        if (_events[normalizedDay]!.isEmpty) {
          _events.remove(normalizedDay);
        }
      }
    });
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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF8008), Color(0xFFFFC837)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Removed decoration from Column
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
                          ? const Color.fromRGBO(76, 175, 80, 0.8)
                          : Color.fromRGBO(255, 255, 255, 0.4),
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

  // Add the current weather widget method
  Widget _buildCurrentWeather() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Current Weather at Your Farm",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              if (_isRefreshing)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Icon(Icons.wb_sunny, color: Colors.yellow, size: 50),
                  const SizedBox(height: 8),
                  const Text(
                    "24°C",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    "Sunny",
                    style: TextStyle(fontSize: 16, color: Colors.blue.shade100),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWeatherDetail(Icons.water_drop, "Humidity: 65%"),
                  const SizedBox(height: 8),
                  _buildWeatherDetail(Icons.air, "Wind: 12 km/h"),
                  const SizedBox(height: 8),
                  _buildWeatherDetail(Icons.thermostat, "Feels like: 26°C"),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Opening detailed weather forecast...")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade800,
              minimumSize: const Size(double.infinity, 45),
            ),
            child: const Text("View Forecast"),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }
}
