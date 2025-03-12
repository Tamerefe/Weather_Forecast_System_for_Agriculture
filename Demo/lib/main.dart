import 'package:flutter/material.dart';

void main() {
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
        unselectedItemColor: Colors.orange.withOpacity(0.6),
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

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.9),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 35,
                    height: 35,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search here ...",
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Icon(Icons.search, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/profile.png'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Good Morning!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    "Tamer Akipek",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Stack(
                children: [
                  const Icon(Icons.notifications,
                      color: Colors.green, size: 30),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: const Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
                  const Text(
                    "16°C",
                    style: TextStyle(
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
                children: [
                  const Text(
                    "Precipitation",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "%30-%50",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
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
              width: 60,
              height: 60,
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
            height: 150,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
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
                const Text(
                  "%85-90",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    'assets/humidity.png',
                    width: 50,
                    height: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
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
                const Text(
                  "40-60",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "km/h",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    'assets/wind.png',
                    width: 50,
                    height: 50,
                  ),
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
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 30,
              ),
              const SizedBox(width: 10),
              const Text(
                "Severe Weather",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Text(
            "Conditions Expected",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Condition: Heavy rainfall and strong winds are expected in your area.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
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

class CropPage extends StatelessWidget {
  const CropPage({super.key});

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildActiveCrop(),
                  const SizedBox(height: 20),
                  _buildTodayRecommendations(),
                  const SizedBox(height: 20),
                  _buildCropTools(),
                  const SizedBox(height: 20),
                  _buildAlternativeCrops(),
                  const SizedBox(height: 20),
                  _buildCropStatistics(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveCrop() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1F4037), Color(0xFF2E8B57)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.asset(
              'assets/olive_trees.png',
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Olive",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.wb_sunny, color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Text(
                            "Harvest in 42 days",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Mediterranean Olive • 12 hectares • Planted: June 2020",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CropStatItem(value: "16-21°C", label: "Ideal Temp"),
                    _CropStatItem(value: "60%", label: "Humidity"),
                    _CropStatItem(value: "7.5", label: "pH Level"),
                    _CropStatItem(value: "Moderate", label: "Water"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Text(
            "Today's Recommendations",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              _buildRecommendationItem(
                icon: Icons.warning_amber_rounded,
                title: "Frost Risk Alert",
                description: "Protect your olives from expected frost tonight",
                color: Colors.orange,
                actionText: "View Protection Tips",
              ),
              const Divider(height: 1, color: Colors.white10),
              _buildRecommendationItem(
                icon: Icons.water_drop,
                title: "Reduce Irrigation",
                description: "Heavy rain expected in the next 48 hours",
                color: Colors.blue,
                actionText: "Adjust Schedule",
              ),
              const Divider(height: 1, color: Colors.white10),
              _buildRecommendationItem(
                icon: Icons.grass,
                title: "Optimal Pruning Period",
                description: "Next 7 days are ideal for winter pruning",
                color: Colors.green,
                actionText: "Learn More",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required String actionText,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      actionText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward, color: color, size: 14),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropTools() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Text(
            "Crop Management Tools",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _buildToolItem(Icons.water, "Irrigation Calculator")),
            const SizedBox(width: 12),
            Expanded(child: _buildToolItem(Icons.science, "Soil Analysis")),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _buildToolItem(Icons.calendar_month, "Harvest Planner")),
            const SizedBox(width: 12),
            Expanded(child: _buildToolItem(Icons.history, "Crop History")),
          ],
        ),
      ],
    );
  }

  Widget _buildToolItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativeCrops() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Text(
            "Alternative Crops for Your Climate",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCropCard(
                  'Cabbage', 'assets/cabbage.png', 'High compatibility'),
              _buildCropCard(
                  'Mandarin', 'assets/mandarin.png', 'Excellent choice'),
              _buildCropCard('Lemon', 'assets/lemon.png', 'Good compatibility'),
              _buildCropCard('Tomato', 'assets/tomato.png', 'Seasonal'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCropCard(String name, String imagePath, String compatibility) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  compatibility,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade300,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios,
                        size: 10, color: Colors.white70),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropStatistics() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade800.withOpacity(0.6),
            Colors.grey.shade900.withOpacity(0.6)
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Olive Production Stats",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatColumn("Last Harvest", "3.8 tons", "+12% from prev"),
              Container(height: 50, width: 1, color: Colors.white12),
              _buildStatColumn("Average Oil Content", "22%", "Good quality"),
              Container(height: 50, width: 1, color: Colors.white12),
              _buildStatColumn("Expected Yield", "4.2 tons", "+10% forecast"),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.65,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Growing Progress: 65%",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String title, String value, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.green.shade300,
          ),
        ),
      ],
    );
  }
}

class _CropStatItem extends StatelessWidget {
  final String value;
  final String label;

  const _CropStatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Data
    final data = [
      {'label': 'Olive', 'value': 0.25, 'color': Colors.blue.shade800},
      {'label': 'Mandarins', 'value': 0.40, 'color': Colors.blue.shade300},
      {'label': 'Lemon', 'value': 0.15, 'color': Colors.blue.shade400},
      {'label': 'Tomatoes', 'value': 0.20, 'color': Colors.blue.shade600},
    ];

    var startAngle = 0.0;

    for (var item in data) {
      final sweepAngle = (item['value'] as double) * 360 * (3.14159 / 180);
      final paint = Paint()
        ..color = item['color'] as Color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Add center circle to make it a donut chart
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.5, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 20),
                  _buildFarmInfo(),
                  const SizedBox(height: 20),
                  _buildSettings(),
                  const SizedBox(height: 20),
                  _buildStatistics(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/profile.png'),
          ),
          const SizedBox(height: 16),
          const Text(
            "Tamer Akipek",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Olive Farmer",
            style: TextStyle(
              fontSize: 18,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoItem(Icons.location_on, "İzmir, Turkey"),
              const SizedBox(width: 20),
              _buildInfoItem(Icons.calendar_today, "Member since 2020"),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Edit Profile",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFarmInfo() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Farm Information",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildFarmInfoItem("Farm Name", "Golden Olive Groves"),
          const SizedBox(height: 10),
          _buildFarmInfoItem("Farm Size", "12 hectares"),
          const SizedBox(height: 10),
          _buildFarmInfoItem("Primary Crops", "Olives, Mandarins, Lemons"),
          const SizedBox(height: 10),
          _buildFarmInfoItem("Last Harvest", "November 15, 2023"),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "View Farm Details",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.green, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmInfoItem(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettings() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Settings",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(Icons.notifications, "Notifications", true),
          _buildSettingItem(Icons.language, "Language", false),
          _buildSettingItem(Icons.dark_mode, "Dark Mode", true),
          _buildSettingItem(Icons.sync, "Sync Data", false),
          _buildSettingItem(Icons.help_outline, "Help & Support", false),
          _buildSettingItem(Icons.logout, "Logout", false),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String text, bool hasSwitch) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          if (hasSwitch)
            Switch(
              value: true,
              onChanged: (value) {},
              activeColor: Colors.green,
            )
          else
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Statistics",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatItem("Crops", "4")),
              Expanded(child: _buildStatItem("Harvests", "12")),
              Expanded(child: _buildStatItem("Years", "3")),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Recent Activity",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          _buildActivityItem(
            "Updated irrigation schedule",
            "Yesterday",
          ),
          _buildActivityItem(
            "Added new crop: Cabbage",
            "3 days ago",
          ),
          _buildActivityItem(
            "Checked weather forecast",
            "1 week ago",
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String activity, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              activity,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
