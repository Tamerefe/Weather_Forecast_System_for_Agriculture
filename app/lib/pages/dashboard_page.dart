import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../widgets/app_header.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _temperature = "Loading...";
  String _humidity = "--";
  String _wind = "--";
  String _selectedLocation = "Izmir";
  final List<String> _locations = [
    "Izmir",
    "Istanbul",
    "Ankara",
    "Antalya",
    "Adana",
    "Bursa",
    "Konya",
    "Gaziantep",
    "Kayseri",
    "Mersin",
    "Samsun",
    "Trabzon",
    "Hatay"
  ];

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    final weatherService = WeatherService();
    try {
      final weather = await weatherService.getWeather(_selectedLocation);
      setState(() {
        _temperature = "${weather['temp']}°C";
        _humidity = "${weather['humidity']}%";
        _wind = "${weather['wind']} km/h";
      });
    } catch (e) {
      logger.i('Error in _fetchWeather: $e');
      setState(() {
        _temperature = "Error";
        _humidity = "--";
        _wind = "--";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsiveness
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return SafeArea(
      child: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
              child: Column(
                children: [
                  _buildLocationSelector(isSmallScreen),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  _buildWeatherWidget(isSmallScreen),
                  SizedBox(height: isSmallScreen ? 16 : 20),
                  _buildWeatherDetails(isSmallScreen),
                  SizedBox(height: isSmallScreen ? 16 : 20),
                  _buildWeatherAlert(isSmallScreen),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSelector(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedLocation,
                  dropdownColor: Colors.black54,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 16 : 18,
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  items: _locations.map((String location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedLocation = newValue;
                        _temperature = "Loading...";
                        _humidity = "--";
                        _wind = "--";
                      });
                      _fetchWeather();
                    }
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          IconButton(
            onPressed: () {
              setState(() {
                _temperature = "Loading...";
                _humidity = "--";
                _wind = "--";
              });
              _fetchWeather();
            },
            icon: Icon(Icons.refresh,
                color: Colors.white, size: isSmallScreen ? 24 : 28),
            tooltip: "Refresh weather data",
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherWidget(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        child: isSmallScreen
            ? Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _temperature,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 32 : 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Today",
                              style: TextStyle(
                                fontSize: isSmallScreen ? 20 : 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/weather_storm.png',
                        width: isSmallScreen ? 80 : 100,
                        height: isSmallScreen ? 80 : 100,
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white30, height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Precipitation",
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "%30-%50",
                              style: TextStyle(
                                fontSize: isSmallScreen ? 20 : 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "(heavy)",
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/rain_cloud.png',
                        width: isSmallScreen ? 80 : 100,
                        height: isSmallScreen ? 80 : 100,
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _temperature,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "Today",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/weather_storm.png',
                    width: 100,
                    height: 100,
                  ),
                  Container(
                    height: 100,
                    width: 1,
                    color: Colors.white30,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Precipitation",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "%30-%50",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "(heavy)",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/rain_cloud.png',
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildWeatherDetails(bool isSmallScreen) {
    return isSmallScreen
        ? Column(
            children: [
              _buildDetailsCard(
                  "Humidity", _humidity, Icons.water_drop, Colors.lightBlue),
              const SizedBox(height: 16),
              _buildDetailsCard("Wind", _wind, Icons.air, Colors.white),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: _buildDetailsCard(
                    "Humidity", _humidity, Icons.water_drop, Colors.lightBlue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child:
                    _buildDetailsCard("Wind", _wind, Icons.air, Colors.white),
              ),
            ],
          );
  }

  Widget _buildDetailsCard(
      String title, String value, IconData icon, Color iconColor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Icon(
                icon,
                color: iconColor,
                size: title == "Wind" ? 60 : 50,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherAlert(bool isSmallScreen) {
    final textSize = isSmallScreen ? 14.0 : 16.0;
    final headerSize = isSmallScreen ? 20.0 : 24.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: isSmallScreen ? 24 : 30,
              ),
              SizedBox(width: isSmallScreen ? 8 : 10),
              Flexible(
                child: Text(
                  "Severe Weather",
                  style: TextStyle(
                    fontSize: headerSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Text(
            "Conditions Expected",
            style: TextStyle(
              fontSize: headerSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            "Condition: Heavy rainfall and strong winds are expected in your area.",
            style: TextStyle(
              fontSize: textSize,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            "Cover or shield sensitive crops, especially those that are more vulnerable to heavy rain and strong winds.",
            style: TextStyle(
              fontSize: textSize,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
