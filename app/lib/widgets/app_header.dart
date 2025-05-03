import 'package:flutter/material.dart';
import '../pages/profile_page.dart';
import '../services/notification_page.dart';
import '../pages/farmer_community_page.dart'; // Add this import for the community page

class AppHeader extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final String? title;

  const AppHeader({
    super.key,
    this.leading,
    this.trailing,
    this.title,
  });

  // Get greeting based on time of day
  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning!";
    } else if (hour >= 12 && hour < 18) {
      return "Good Afternoon!";
    } else if (hour >= 18 && hour < 22) {
      return "Good Evening!";
    } else {
      return "Good Night!";
    }
  }

  void _onProfileTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
  }

  void _onNotificationTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationPage()),
    );
  }

  // Add navigation to Farmer Community
  void _onCommunityTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FarmerCommunityPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          // Logo
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(255, 255, 255, 0.9),
            ),
            child: Center(
              child: Image.asset(
                'assets/logo.png',
                width: 32,
                height: 32,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: const TextStyle(
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
          // Community button
          GestureDetector(
            onTap: () => _onCommunityTap(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people, color: Colors.white, size: 18),
                  SizedBox(width: 4),
                  Text(
                    "Farmer community",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Notification icon
          GestureDetector(
            onTap: () => _onNotificationTap(context),
            child: Stack(
              children: [
                const Icon(Icons.notifications, color: Colors.green, size: 30),
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
          ),
        ],
      ),
    );
  }
}
