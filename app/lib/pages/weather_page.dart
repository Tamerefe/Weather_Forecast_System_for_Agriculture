import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/app_header.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with AutomaticKeepAliveClientMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  // Events map with automatic cleanup
  final Map<DateTime, List<Map<String, dynamic>>> _events = {};
  bool _isRefreshing = false;
  late Future<Map<String, dynamic>> _weatherFuture;
  final WeatherService _weatherService = WeatherService();

  @override
  bool get wantKeepAlive => true; // Keep state alive to prevent rebuilding

  @override
  void initState() {
    super.initState();
    _weatherFuture = _weatherService.getCachedWeather('Istanbul');
    // Schedule memory cleanup every 5 minutes
    _scheduleMemoryCleanup();
  }

  @override
  void dispose() {
    // Clean up resources
    _events.clear();
    super.dispose();
  }

  void _scheduleMemoryCleanup() {
    Future.delayed(const Duration(minutes: 5), () {
      if (mounted) {
        _cleanupOldEvents();
        _scheduleMemoryCleanup(); // Schedule next cleanup
      }
    });
  }

  void _cleanupOldEvents() {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
    _events.removeWhere((date, events) => date.isBefore(cutoffDate));
  }

  void _refreshWeather() async {
    if (!_isRefreshing && mounted) {
      setState(() {
        _isRefreshing = true;
      });

      // Refresh weather data
      _weatherFuture = _weatherService.getWeather('Istanbul');

      // Wait for completion
      await _weatherFuture;

      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  Future<void> _addEvent(BuildContext context) async {
    if (_selectedDay == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a day first")),
        );
      }
      return;
    }

    final result = await _showEventDialog(context);
    if (result != null && mounted) {
      setState(() {
        final normalizedDay = DateTime.utc(
          _selectedDay!.year,
          _selectedDay!.month,
          _selectedDay!.day,
        );

        if (_events.containsKey(normalizedDay)) {
          _events[normalizedDay]!.add(result);
        } else {
          _events[normalizedDay] = [result];
        }
      });
    }
  }

  Future<Map<String, dynamic>?> _showEventDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final notesController = TextEditingController();
    String selectedCategory = 'Harvest';
    TimeOfDay selectedTime = TimeOfDay.now();

    try {
      return await showDialog<Map<String, dynamic>>(
        context: context,
        barrierDismissible: true,
        builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text("Add Farm Event"),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Event Title",
                        hintText: "Enter event title",
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(labelText: "Category"),
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
                          setDialogState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      title: const Text("Time"),
                      subtitle: Text(selectedTime.format(context)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
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
                    Navigator.pop(context, {
                      'title': title,
                      'category': selectedCategory,
                      'time': selectedTime.format(context),
                      'notes': notesController.text.trim(),
                    });
                  } else {
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
    } finally {
      titleController.dispose();
      notesController.dispose();
    }
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

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

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return SafeArea(
      child: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _refreshWeather(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildCalendarSection(),
                    const SizedBox(height: 16),
                    _buildWeeklyWeatherForecast(context),
                    const SizedBox(height: 16),
                    _buildComparisonByDay(context),
                    const SizedBox(height: 16),
                    _buildCurrentWeatherWithFuture(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeatherWithFuture() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _weatherFuture,
      builder: (context, snapshot) {
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
                  if (_isRefreshing ||
                      snapshot.connectionState == ConnectionState.waiting)
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
              if (snapshot.hasData)
                _buildWeatherContent(snapshot.data!)
              else if (snapshot.hasError)
                _buildErrorContent()
              else
                _buildLoadingContent(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isRefreshing ? null : _refreshWeather,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade800,
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: _isRefreshing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Refresh Weather"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeatherContent(Map<String, dynamic> weatherData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            const Icon(Icons.wb_sunny, color: Colors.yellow, size: 50),
            const SizedBox(height: 8),
            Text(
              "${weatherData['temp']}°C",
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              "Current",
              style: TextStyle(fontSize: 16, color: Colors.blue.shade100),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeatherDetail(
                Icons.water_drop, "Humidity: ${weatherData['humidity']}%"),
            const SizedBox(height: 8),
            _buildWeatherDetail(Icons.air, "Wind: ${weatherData['wind']} km/h"),
            const SizedBox(height: 8),
            _buildWeatherDetail(Icons.thermostat, "Real-time data"),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorContent() {
    return const Center(
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.white, size: 50),
          SizedBox(height: 8),
          Text("Error loading weather data",
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    return const Center(
      child: Column(
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text("Loading weather data...",
              style: TextStyle(color: Colors.white, fontSize: 16)),
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
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

                return Padding(
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
        'icon': Icons.wb_sunny
      },
      {
        'day': 'Today',
        'temp': '16°C',
        'condition': 'Scattered Showers',
        'humidity': '85%',
        'precipitation': '12mm',
        'icon': Icons.grain
      },
      {
        'day': 'Tomorrow',
        'temp': '19°C',
        'condition': 'Partly Cloudy',
        'humidity': '72%',
        'precipitation': '2mm',
        'icon': Icons.cloud
      },
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
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
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: data['day'] == 'Today'
                        ? const Color.fromRGBO(76, 175, 80, 0.8)
                        : const Color.fromRGBO(255, 255, 255, 0.4),
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
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

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
