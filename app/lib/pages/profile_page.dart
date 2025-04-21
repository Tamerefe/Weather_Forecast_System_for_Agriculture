import 'package:flutter/material.dart';
import '../widgets/app_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _isFarmInfoExpanded = false;
  bool _isRefreshing = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onSettingTap(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Tapped: $title")),
    );
  }

  void _onFarmDetailTap(BuildContext context) {
    setState(() {
      _isFarmInfoExpanded = !_isFarmInfoExpanded;
      if (_isFarmInfoExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _onEditProfileTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profile"),
        content: const Text("This feature will be available soon!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);
    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isRefreshing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated!")),
    );
  }

  void _showStatDetail(String stat, String value) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              stat,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Current value: $value"),
            const SizedBox(height: 20),
            Text("Historical Data for $stat",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const LinearProgressIndicator(value: 0.7),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(context),
                      const SizedBox(height: 20),
                      _buildFarmInfo(context),
                      const SizedBox(height: 20),
                      _buildSettings(context),
                      const SizedBox(height: 20),
                      _buildStatistics(),
                      const SizedBox(height: 20),
                      _buildWeatherWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
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
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text("Olive Farmer",
              style: TextStyle(fontSize: 18, color: Colors.green)),
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
            onPressed: () => _onEditProfileTap(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text("Edit Profile",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }

  Widget _buildFarmInfo(BuildContext context) {
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
          const Text("Farm Information",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 16),
          _buildFarmInfoItem("Farm Name", "Golden Olive Groves"),
          const SizedBox(height: 10),
          _buildFarmInfoItem("Farm Size", "12 hectares"),

          // Conditionally show more details when expanded
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: _isFarmInfoExpanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _buildFarmInfoItem(
                          "Primary Crops", "Olives, Mandarins, Lemons"),
                      const SizedBox(height: 10),
                      _buildFarmInfoItem("Last Harvest", "November 15, 2023"),
                      const SizedBox(height: 10),
                      _buildFarmInfoItem("Soil Type", "Clay Loam"),
                      const SizedBox(height: 10),
                      _buildFarmInfoItem(
                          "Irrigation System", "Drip Irrigation"),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _buildFarmInfoItem(
                          "Primary Crops", "Olives, Mandarins, Lemons"),
                      const SizedBox(height: 10),
                      _buildFarmInfoItem("Last Harvest", "November 15, 2023"),
                    ],
                  ),
          ),

          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _onFarmDetailTap(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(_isFarmInfoExpanded ? "Show Less" : "View Farm Details",
                    style: const TextStyle(fontSize: 16, color: Colors.green)),
                const SizedBox(width: 8),
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.5).animate(_animation),
                  child: const Icon(Icons.arrow_downward,
                      color: Colors.green, size: 18),
                ),
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
          child: Text(label,
              style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildSettings(BuildContext context) {
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
          const Text("Settings",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 16),
          _buildSettingItem(
              context, Icons.notifications, "Notifications", true),
          _buildSettingItem(context, Icons.language, "Language", false),
          _buildSettingItem(context, Icons.dark_mode, "Dark Mode", true),
          _buildSettingItem(context, Icons.sync, "Sync Data", false),
          _buildSettingItem(
              context, Icons.help_outline, "Help & Support", false),
          _buildSettingItem(context, Icons.logout, "Logout", false),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context, IconData icon, String text, bool hasSwitch) {
    return InkWell(
      onTap: () => _onSettingTap(context, text),
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.green.withOpacity(0.3),
      highlightColor: Colors.green.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
            ),
            if (hasSwitch)
              Switch(
                value: true,
                onChanged: (value) {
                  // Show feedback when switched
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("$text is now ${value ? 'on' : 'off'}")),
                  );
                },
                activeColor: Colors.green,
              )
            else
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 16),
          ],
        ),
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
          const Text("Your Statistics",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatItem("Crops", "4")),
              Expanded(child: _buildStatItem("Harvests", "12")),
              Expanded(child: _buildStatItem("Years", "3")),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Recent Activity",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 12),
          _buildActivityItem(
              "Updated irrigation schedule", "Yesterday", Icons.water_drop),
          _buildActivityItem(
              "Added new crop: Cabbage", "3 days ago", Icons.eco),
          _buildActivityItem(
              "Checked weather forecast", "1 week ago", Icons.wb_sunny),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return InkWell(
      onTap: () => _showStatDetail(label, value),
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.green.withOpacity(0.3),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String activity, String time,
      [IconData? customIcon]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(customIcon ?? Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 12),
          Expanded(
              child: Text(activity,
                  style: const TextStyle(fontSize: 14, color: Colors.white))),
          Text(time,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  Widget _buildWeatherWidget() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
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
