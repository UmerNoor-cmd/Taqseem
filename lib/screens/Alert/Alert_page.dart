import 'package:flutter/material.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
        backgroundColor: Colors.yellow[700],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildAlertCard(
            icon: Icons.warning_amber,
            title: 'Urgent Food Donation Needed',
            message: '50kg of food will go to waste in 2 hours at Al Safa Market',
            time: '10 min ago',
            color: Colors.red[100]!,
          ),
          const SizedBox(height: 12),
          _buildAlertCard(
            icon: Icons.info,
            title: 'New Donation Center',
            message: 'A new donation center has opened in Jumeirah area',
            time: '2 hours ago',
            color: Colors.blue[100]!,
          ),
          const SizedBox(height: 12),
          _buildAlertCard(
            icon: Icons.celebration,
            title: 'Milestone Reached!',
            message: 'We\'ve rescued over 10,000kg of food this month',
            time: '1 day ago',
            color: Colors.green[100]!,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard({
    required IconData icon,
    required String title,
    required String message,
    required String time,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: color.withOpacity(0.8),
              width: 8,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: color.withOpacity(0.8)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(message),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}