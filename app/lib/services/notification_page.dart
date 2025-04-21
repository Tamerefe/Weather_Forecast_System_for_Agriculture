import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.info, color: Colors.green),
            title: Text('Your irrigation schedule was updated.'),
            subtitle: Text('2 hours ago'),
          ),
          ListTile(
            leading: Icon(Icons.warning, color: Colors.orange),
            title: Text('Possible frost tomorrow night!'),
            subtitle: Text('1 day ago'),
          ),
          ListTile(
            leading: Icon(Icons.cloud, color: Colors.blue),
            title: Text('Rain forecasted for Thursday.'),
            subtitle: Text('3 days ago'),
          ),
        ],
      ),
    );
  }
}
