import 'package:flutter/material.dart';
import '../widgets/app_header.dart';

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
