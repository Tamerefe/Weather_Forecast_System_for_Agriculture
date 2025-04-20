import 'package:flutter/material.dart';
import '../widgets/app_header.dart';

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
              _buildCropCard('Cabbage', Icons.eco, 'High compatibility'),
              _buildCropCard('Mandarin', Icons.circle, 'Excellent choice'),
              _buildCropCard('Lemon', Icons.eco, 'Good compatibility'),
              _buildCropCard('Tomato', Icons.brightness_1, 'Seasonal'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCropCard(String name, IconData icon, String compatibility) {
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
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Icon(
              icon,
              size: 50,
              color: Colors.green.shade300,
            ),
            alignment: Alignment.center,
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
