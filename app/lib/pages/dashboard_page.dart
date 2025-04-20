import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../widgets/app_header.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _temperature = "Loading...";
  String _humidity = "--";
  String _wind = "--";

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    final weatherService = WeatherService();
    try {
      final weather = await weatherService.getWeather("Izmir");
      setState(() {
        _temperature = "${weather['temp']}°C";
        _humidity = "${weather['humidity']}%";
        _wind = "${weather['wind']} km/h";
      });
    } catch (e) {
      print('Error in _fetchWeather: $e');
      setState(() {
        _temperature = "Error";
        _humidity = "--";
        _wind = "--";
      });
    }
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
                  _buildWeatherWidget(),
                  const SizedBox(height: 20),
                  _buildWeatherDetails(),
                  const SizedBox(height: 20),
                  _buildWeatherAlert(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherWidget() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
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

  Widget _buildWeatherDetails() {
    return Row(
      children: [
        Expanded(
          child: Container(
            // Remove fixed height to allow content to determine container size
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use minimum required space
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Humidity",
                  style: TextStyle(
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
                      _humidity,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.water_drop,
                      color: Colors.lightBlue,
                      size: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            // Remove fixed height to allow content to determine container size
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use minimum required space
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Wind",
                  style: TextStyle(
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
                      _wind,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.air,
                      color: Colors.white,
                      size: 60,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherAlert() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                "Severe Weather",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Text(
            "Conditions Expected",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Condition: Heavy rainfall and strong winds are expected in your area.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            "Cover or shield sensitive crops, especially those that are more vulnerable to heavy rain and strong winds.",
            style: TextStyle(
              fontSize: 16,
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
