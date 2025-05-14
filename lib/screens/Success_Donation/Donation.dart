import 'package:flutter/material.dart';



// Update your TrackAlertScreen to accept parameters:
class TrackAlertScreen extends StatelessWidget {
  final String? foodType;
  final double? quantity;

  const TrackAlertScreen({
    super.key,
    required this.foodType,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Alert'),
        backgroundColor: const Color(0xFF40df46),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: const Color(0xFF40df46),
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Thank you for your kindness!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Thank you for donating ${quantity?.toStringAsFixed(1)} kg of $foodType! '
                'An alert has been generated and an NGO will connect with you shortly.',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Show alert tracking details
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Alert Tracking'),
                        content: const Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('🚚 Alert Status: In Progress'),
                            SizedBox(height: 10),
                            Text('📍 Current Location: On route to collection point'),
                            SizedBox(height: 10),
                            Text('⏱️ Estimated Arrival: 30-45 minutes'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40df46),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Track Your Alert'),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  // Navigate back to home
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF40df46),
                ),
                child: const Text('Back to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}