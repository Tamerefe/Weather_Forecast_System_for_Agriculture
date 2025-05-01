import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Import the page files
import 'pages/dashboard_page.dart';
import 'pages/crop_page.dart';
import 'pages/weather_page.dart';
import 'pages/profile_page.dart';
import 'package:logger/logger.dart';

// Create a logger instance
final logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    logger.i("Çevre değişkenleri başarıyla yüklendi");
  } catch (e) {
    logger.e("Çevre değişkenleri yüklenemedi: $e");
    // API anahtarı olmadan devam et, weather service eksik anahtarı ele alacak
  }

  runApp(const FarmWeatherApp());
}

class FarmWeatherApp extends StatelessWidget {
  const FarmWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF3C2A21),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3C2A21),
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const CropPage(),
    const WeatherPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF3C2A21),
        selectedItemColor: Colors.green,
        unselectedItemColor:
            Color.fromRGBO(255, 149, 0, 0.6), // Updated from withOpacity
        elevation: 0,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        iconSize: 24,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grass),
            label: 'Crop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
