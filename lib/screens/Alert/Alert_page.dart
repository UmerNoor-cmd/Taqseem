import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AlertPage extends StatefulWidget {
  final int initialTab; // 0 = Available, 1 = Required
  
  const AlertPage({super.key, this.initialTab = 1});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  int _currentSection = 1; // 0 = Available, 1 = Required
  final ScrollController _availableController = ScrollController();
  final ScrollController _requiredController = ScrollController();

  final List<Map<String, dynamic>> _availableFoods = [
    {
      'title': "Foodie's Paradise",
      'location': "Gulshan Block 5",
      'details': "80 packed meals",
      'time': "Pickup within 2 hours",
      'rating': 4.5,
      'accepted': false,
    },
    {
      'title': "Tasty Bites",
      'location': "Saddar",
      'details': "50 pizza slices",
      'time': "Immediate Pickup",
      'rating': 4.2,
      'accepted': false,
    },
    {
      'title': "The Spice House",
      'location': "Clifton",
      'details': "100 mixed meals",
      'time': "Pickup within 2 hours",
      'rating': 4.8,
      'accepted': false,
    },
  ];

final List<Map<String, dynamic>> _requiredFoods = [
  {
    'title': "Hope Foundation",
    'location': "Guliston Block 2",
    'coordinates': const LatLng(24.8707, 67.0111), // Added coordinates
    'details': "80 people",
    'time': "Immediate Pickup",
    'rating': 4.7,
  },
  {
    'title': "Help Hand",
    'location': "PECHS",
    'coordinates': const LatLng(24.8807, 67.0211), // Added coordinates
    'details': "20 children",
    'time': "Immediate Pickup",
    'rating': 4.3,
  },
  {
    'title': "Food Aid Society",
    'location': "Liaquatabad",
    'coordinates': const LatLng(24.8907, 67.0311), // Added coordinates
    'details': "100 people",
    'time': "Pickup within 2 hours",
    'rating': 4.9,
  },
];


  @override
  void dispose() {
    _availableController.dispose();
    _requiredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ALERTS',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_currentSection == 0)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () => _showAddAlertDialog(context),
            ),
        ],
      ),
      body: Column(
        children: [
          // Section selector tabs with listing counts
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          _currentSection == 0
                              ? Colors.grey[100]
                              : Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => setState(() => _currentSection = 0),
                    child: Column(
                      children: [
                        Text(
                          'Urgent Food Available',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                _currentSection == 0
                                    ? const Color(0xFF40df46)
                                    : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_availableFoods.length} listings',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                _currentSection == 0
                                    ? Colors.black
                                    : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          _currentSection == 1
                              ? Colors.grey[100]
                              : Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => setState(() => _currentSection = 1),
                    child: Column(
                      children: [
                        Text(
                          'Urgent Food Required',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                _currentSection == 1
                                    ? const Color(0xFF40df46)
                                    : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_requiredFoods.length} listings',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                _currentSection == 1
                                    ? Colors.black
                                    : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content section - Fixed IndexedStack
          Expanded(
            child: IndexedStack(
              index: _currentSection,
              children: [_buildAvailableSection(), _buildRequiredSection()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableSection() {
    return ListView.builder(
      controller: _availableController,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: _availableFoods.length,
      itemBuilder: (context, index) {
        return _buildFoodCard(
          title: _availableFoods[index]['title']!,
          location: _availableFoods[index]['location']!,
          details: _availableFoods[index]['details']!,
          time: _availableFoods[index]['time']!,
          rating: _availableFoods[index]['rating']!,
          accepted: _availableFoods[index]['accepted']!,
          buttonText: "Accept Pickup",
          isDonor: true,
          context: context,
          onPressed: () {
            setState(() {
              _availableFoods[index]['accepted'] = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Accepted ${_availableFoods[index]['title']}'),
                backgroundColor: const Color(0xFF40df46),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRequiredSection() {
    return ListView.builder(
      controller: _requiredController,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: _requiredFoods.length,
      itemBuilder: (context, index) {
        return _buildFoodCard(
          title: _requiredFoods[index]['title']!,
          location: _requiredFoods[index]['location']!,
          details: _requiredFoods[index]['details']!,
          time: _requiredFoods[index]['time']!,
          rating: _requiredFoods[index]['rating']!,
          accepted: false,
          buttonText: "Accept Request",
          isDonor: false,
          context: context,
          onPressed: () {
            // Return NGO location data when accepted
            Navigator.pop(context, {
              'location': _requiredFoods[index]['coordinates'],
              'title': _requiredFoods[index]['title'],
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Accepted request from ${_requiredFoods[index]['title']}'),
                backgroundColor: const Color(0xFF40df46),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }
  Widget _buildFoodCard({
  required String title,
  required String location,
  required String details,
  required String time,
  required double rating,
  required bool accepted,
  required String buttonText,
  required bool isDonor,
  required BuildContext context,
  required VoidCallback onPressed,
}) {
  return Card(
    elevation: 1,
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.location_on, location),
          const SizedBox(height: 8),
          _buildDetailRow(
            isDonor ? Icons.fastfood : Icons.people,
            details,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.access_time, time),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDonor
                    ? (accepted ? Colors.green[100] : const Color(0xFF40df46))
                    : const Color(0xFF40df46),
                foregroundColor: isDonor && accepted 
                    ? const Color(0xFF40df46)
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                isDonor && accepted ? "Accepted" : buttonText,
                style: TextStyle(
                  color: isDonor && accepted 
                      ? const Color(0xFF40df46)
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: Colors.grey[800], fontSize: 15)),
      ],
    );
  }

  void _showAddAlertDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Add New Listing',
              style: TextStyle(color: Colors.black),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      locationController.text.isNotEmpty &&
                      quantityController.text.isNotEmpty) {
                    setState(() {
                      _availableFoods.insert(0, {
                        'title': titleController.text,
                        'location': locationController.text,
                        'details': quantityController.text,
                        'time': "Immediate Pickup",
                        'rating': 4.0,
                        'accepted': false,
                      });
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('New listing added'),
                        backgroundColor: const Color(0xFF40df46),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF40df46),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
    );
  }
}
