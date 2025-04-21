import 'package:flutter/material.dart';
import '../widgets/app_header.dart';

class CropPage extends StatefulWidget {
  const CropPage({super.key});

  @override
  State<CropPage> createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  // Aktif seçilen mahsul
  String _selectedCrop = 'Olive';

  // Tema değişkeni (aydınlık/karanlık mod)
  bool _isDarkMode = true;

  // Demo alternatif mahsuller listesi
  final List<Map<String, dynamic>> _alternativeCrops = [
    {
      'name': 'Cabbage',
      'icon': Icons.eco,
      'compatibility': 'High compatibility'
    },
    {
      'name': 'Mandarin',
      'icon': Icons.circle,
      'compatibility': 'Excellent choice'
    },
    {'name': 'Lemon', 'icon': Icons.eco, 'compatibility': 'Good compatibility'},
    {'name': 'Tomato', 'icon': Icons.brightness_1, 'compatibility': 'Seasonal'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          AppHeader(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // Show notifications or alerts related to crops
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Notifications coming soon!')),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
                  onPressed: () {
                    setState(() {
                      _isDarkMode = !_isDarkMode;
                    });
                  },
                ),
              ],
            ),
          ),
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
          // Ekstra hızlı eylem butonu
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () => _showAddCropDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add New Crop'),
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
                    Text(
                      _selectedCrop, // Use the selected crop name
                      style: const TextStyle(
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
                onTap: () => _showFrostProtectionTips(),
              ),
              const Divider(height: 1, color: Colors.white10),
              _buildRecommendationItem(
                icon: Icons.water_drop,
                title: "Reduce Irrigation",
                description: "Heavy rain expected in the next 48 hours",
                color: Colors.blue,
                actionText: "Adjust Schedule",
                onTap: () => _showIrrigationAdjustment(),
              ),
              const Divider(height: 1, color: Colors.white10),
              _buildRecommendationItem(
                icon: Icons.grass,
                title: "Optimal Pruning Period",
                description: "Next 7 days are ideal for winter pruning",
                color: Colors.green,
                actionText: "Learn More",
                onTap: () => _showPruningInfo(),
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
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      splashColor: color.withOpacity(0.1),
      highlightColor: color.withOpacity(0.05),
      child: Padding(
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
      ),
    );
  }

  // Frost protection tips dialog
  void _showFrostProtectionTips() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Row(
          children: [
            Icon(Icons.ac_unit, color: Colors.orange),
            SizedBox(width: 10),
            Text('Frost Protection Tips',
                style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTipItem('Cover your olive trees with frost cloths'),
            _buildTipItem('Use wind machines to circulate warmer air'),
            _buildTipItem('Water the soil before the frost to release heat'),
            _buildTipItem('Use heaters in critical areas of your orchard'),
            _buildTipItem('Apply anti-frost spray to vulnerable young trees'),
            SizedBox(height: 10),
            Text(
              'Temperatures may drop to -2°C tonight around 3-5 AM',
              style: TextStyle(color: Colors.orange.shade300, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('Set Frost Alert'),
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Frost alert set for tonight')),
              );
            },
          ),
        ],
      ),
    );
  }

  // Irrigation adjustment dialog
  void _showIrrigationAdjustment() {
    double irrigationReduction = 50.0;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: Row(
            children: [
              Icon(Icons.water_drop, color: Colors.blue),
              SizedBox(width: 10),
              Text('Adjust Irrigation', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recommended: Reduce irrigation by 50% for the next 48 hours due to expected rainfall.',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 20),
              Text(
                'Irrigation reduction: ${irrigationReduction.toInt()}%',
                style: TextStyle(color: Colors.white),
              ),
              Slider(
                value: irrigationReduction,
                min: 0,
                max: 100,
                divisions: 10,
                activeColor: Colors.blue,
                inactiveColor: Colors.blue.withOpacity(0.2),
                label: '${irrigationReduction.toInt()}%',
                onChanged: (value) {
                  setState(() {
                    irrigationReduction = value;
                  });
                },
              ),
              SizedBox(height: 10),
              Text(
                'System will resume normal irrigation on Friday',
                style: TextStyle(color: Colors.blue.shade300, fontSize: 13),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text('Apply Changes'),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Irrigation reduced by ${irrigationReduction.toInt()}% for 48 hours'),
                    backgroundColor: Colors.blue.shade700,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Pruning information dialog
  void _showPruningInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Row(
          children: [
            Icon(Icons.grass, color: Colors.green),
            SizedBox(width: 10),
            Text('Pruning Information', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/olive_pruning.png',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                color: Colors.green.withOpacity(0.2),
                child: Center(
                    child:
                        Icon(Icons.image_not_supported, color: Colors.green)),
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Why prune now?',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Winter pruning benefits olive trees by improving sunlight exposure and air circulation, enhancing fruit production for the next season.',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 10),
            _buildPruningTip('Remove dead or diseased branches first'),
            _buildPruningTip('Maintain the traditional vase shape'),
            _buildPruningTip('Don\'t remove more than 25% of foliage'),
            SizedBox(height: 10),
            Text(
              'Optimal pruning period: January 10-17',
              style: TextStyle(color: Colors.green.shade300, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Schedule Pruning'),
            onPressed: () {
              Navigator.of(context).pop();
              _schedulePruning();
            },
          ),
        ],
      ),
    );
  }

  // Schedule pruning dialog
  void _schedulePruning() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text('Schedule Pruning', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select a date for pruning:',
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white10),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  _buildDateOption('Tuesday, Jan 10', '☀️ 12°C, Sunny'),
                  Divider(height: 1, color: Colors.white10),
                  _buildDateOption('Wednesday, Jan 11', '☁️ 10°C, Cloudy'),
                  Divider(height: 1, color: Colors.white10),
                  _buildDateOption('Thursday, Jan 12', '☀️ 11°C, Sunny'),
                  Divider(height: 1, color: Colors.white10),
                  _buildDateOption(
                      'Friday, Jan 13', '🌧️ 9°C, Rainy (Not Recommended)'),
                ],
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Helper widget for tips in the frost protection dialog
  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.orange.shade300),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for pruning tips
  Widget _buildPruningTip(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green.shade300),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for date options in pruning schedule
  Widget _buildDateOption(String date, String weather) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pruning scheduled for $date'),
            backgroundColor: Colors.green.shade700,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(weather,
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
            Icon(Icons.calendar_today, color: Colors.white54, size: 20)
          ],
        ),
      ),
    );
  }

  Widget _buildCropTools() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            "Crop Management Tools",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
          children: [
            _buildToolItem(
              icon: Icons.water_drop,
              label: "Irrigation Calculator",
              description: "Plan your water usage efficiently",
              color: Colors.blue,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening Irrigation Calculator...'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            _buildToolItem(
              icon: Icons.science,
              label: "Soil Analysis",
              description: "Check soil health and nutrients",
              color: Colors.amber,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening Soil Analysis...'),
                    backgroundColor: Colors.amber,
                  ),
                );
              },
            ),
            _buildToolItem(
              icon: Icons.calendar_month,
              label: "Harvest Planner",
              description: "Schedule your harvest timeline",
              color: Colors.green,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening Harvest Planner...'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            _buildToolItem(
              icon: Icons.history,
              label: "Crop History",
              description: "View past seasons data",
              color: Colors.purple,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening Crop History...'),
                    backgroundColor: Colors.purple,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToolItem({
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () => _showCropToolDetails(icon, label, description, color),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.2),
              color.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Crop tool details dialog
  void _showCropToolDetails(
      IconData icon, String label, String description, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 10),
            Text(label, style: TextStyle(color: Colors.white)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 20),
              if (label == "Irrigation Calculator")
                _buildIrrigationToolContent()
              else if (label == "Soil Analysis")
                _buildSoilAnalysisToolContent()
              else if (label == "Harvest Planner")
                _buildHarvestPlannerToolContent()
              else if (label == "Crop History")
                _buildCropHistoryToolContent()
              else
                Text('Tool details coming soon!',
                    style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: color),
            child: Text('Use Tool'),
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Using $label...'),
                  backgroundColor: color,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Tool-specific content widgets
  Widget _buildIrrigationToolContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Current Irrigation Status:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Water usage this week:',
                style: TextStyle(color: Colors.white70)),
            Text('3,540 liters', style: TextStyle(color: Colors.white)),
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Moisture level:', style: TextStyle(color: Colors.white70)),
            Text('68%', style: TextStyle(color: Colors.white)),
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Next scheduled:', style: TextStyle(color: Colors.white70)),
            Text('Tomorrow, 06:00', style: TextStyle(color: Colors.white)),
          ],
        ),
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: Colors.blue),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Rain predicted in 3 days. Consider adjusting your irrigation schedule.',
                  style: TextStyle(color: Colors.blue.shade300, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSoilAnalysisToolContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Last Soil Test Results:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          // Removed fixed height to allow dynamic content sizing
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Added to adapt to content
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nitrogen (N):',
                      style: TextStyle(color: Colors.white70)),
                  Row(
                    children: [
                      Text('45 mg/kg ', style: TextStyle(color: Colors.white)),
                      Icon(Icons.warning, size: 16, color: Colors.amber)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Phosphorus (P):',
                      style: TextStyle(color: Colors.white70)),
                  Text('65 mg/kg', style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Potassium (K):',
                      style: TextStyle(color: Colors.white70)),
                  Text('120 mg/kg', style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('pH Level:', style: TextStyle(color: Colors.white70)),
                  Text('7.3', style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Organic Matter:',
                      style: TextStyle(color: Colors.white70)),
                  Text('3.8%', style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(height: 15),
              Text('Recommendation: Consider nitrogen fertilization',
                  style: TextStyle(color: Colors.amber.shade300, fontSize: 13)),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text('Last tested: 2 months ago',
            style: TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildHarvestPlannerToolContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Harvest Timeline:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 15),
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              _buildTimelineStage('Planting', 'Mar 15', true),
              _buildTimelineConnector(true),
              _buildTimelineStage('Growth', 'Current', true),
              _buildTimelineConnector(false),
              _buildTimelineStage('Harvest', 'Nov 10', false),
            ],
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Days until harvest:',
                style: TextStyle(color: Colors.white70)),
            Text('42 days',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Expected yield:', style: TextStyle(color: Colors.white70)),
            Text('4.2 tons', style: TextStyle(color: Colors.white)),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Labor required:', style: TextStyle(color: Colors.white70)),
            Text('8-10 workers', style: TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineStage(String name, String date, bool completed) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: completed ? Colors.green : Colors.grey.shade700,
            ),
            child: Icon(
              completed ? Icons.check : Icons.hourglass_empty,
              color: Colors.white,
              size: 16,
            ),
          ),
          SizedBox(height: 5),
          Text(name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
          Text(date, style: TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildTimelineConnector(bool completed) {
    return Container(
      width: 20,
      height: 2,
      color: completed ? Colors.green : Colors.grey.shade600,
    );
  }

  Widget _buildCropHistoryToolContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Historical Performance:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 15),
        Container(
          height: 150,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.purple.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Year',
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold)),
                  Text('Yield',
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold)),
                  Text('Quality',
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold)),
                ],
              ),
              Divider(color: Colors.white24, height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('2022', style: TextStyle(color: Colors.white70)),
                  Text('3.8 tons', style: TextStyle(color: Colors.white)),
                  Row(children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Icon(Icons.star_outline, size: 14, color: Colors.amber),
                  ]),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('2021', style: TextStyle(color: Colors.white70)),
                  Text('3.4 tons', style: TextStyle(color: Colors.white)),
                  Row(children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Icon(Icons.star_outline, size: 14, color: Colors.amber),
                    Icon(Icons.star_outline, size: 14, color: Colors.amber),
                  ]),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('2020', style: TextStyle(color: Colors.white70)),
                  Text('2.9 tons', style: TextStyle(color: Colors.white)),
                  Row(children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Icon(Icons.star_outline, size: 14, color: Colors.amber),
                    Icon(Icons.star_outline, size: 14, color: Colors.amber),
                  ]),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text('Year-over-year growth: +15%',
            style: TextStyle(color: Colors.green.shade300, fontSize: 13)),
      ],
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
            children: _alternativeCrops
                .map((crop) => GestureDetector(
                      onTap: () => _showCropDetails(crop['name']),
                      child: _buildCropCard(
                          crop['name'], crop['icon'], crop['compatibility']),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  // Mahsül detaylarını gösteren dialog
  void _showCropDetails(String cropName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(cropName, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ideal growing conditions for $cropName',
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            _buildCropDetailItem('Temperature', '18-24°C'),
            _buildCropDetailItem('Water Needs', 'Moderate'),
            _buildCropDetailItem('Soil Type', 'Loamy'),
            _buildCropDetailItem('Growing Season', '3-4 months'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Switch to this crop'),
            onPressed: () {
              setState(() {
                _selectedCrop = cropName;
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // Detay öğesi
  Widget _buildCropDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // add new crop chat
  void _showAddCropDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title:
            const Text('Add New Crop', style: TextStyle(color: Colors.white)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Crop Name',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Hectares',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Add'),
            onPressed: () {
              // Burada add new crop ekleme mantığı eklenecek
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
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
        ), // Add missing closing parenthesis for Text widget
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
