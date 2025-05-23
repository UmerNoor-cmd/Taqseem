import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AlertPageNgo extends StatefulWidget {
  final int? initialTab; // 0 for Available, 1 for Required

  const AlertPageNgo({super.key, this.initialTab = 1});

  @override
  State<AlertPageNgo> createState() => _AlertPageNgoState();
}




class _AlertPageNgoState extends State<AlertPageNgo> {
  int _currentSection = 0; // 1 = Required (default), 0 = Available
  final ScrollController _availableController = ScrollController();
  final ScrollController _requiredController = ScrollController();

  // Add this method to build detail rows
  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void initState() {
    super.initState();
    // Use the initialTab parameter or default to 1 (Required)
    _currentSection = widget.initialTab ?? 1;
  }

  final List<Map<String, dynamic>> _availableFoods = [
    {
      'title': "Foodie's Paradise",
      'location': "Gulshan Block 5",
      'details': "80 packed meals",
      'time': "Pickup within 2 hours",
      'rating': 4.5,
    },
    {
      'title': "Tasty Bites",
      'location': "Saddar",
      'details': "50 pizza slices",
      'time': "Immediate Pickup",
      'rating': 4.2,
    },
    {
      'title': "The Spice House",
      'location': "Clifton",
      'details': "100 mixed meals",
      'time': "Pickup within 2 hours",
      'rating': 4.8,
    },
  ];

  final List<Map<String, dynamic>> _requiredFoods = [
    {
      'title': "Hope Foundation",
      'location': "Guliston Block 2",
      'details': "80 people",
      'time': "Immediate Pickup",
      'rating': 4.7,
      'accepted': false,
    },
    {
      'title': "Help Hand",
      'location': "PECHS",
      'details': "20 children",
      'time': "Immediate Pickup",
      'rating': 4.3,
      'accepted': false,
    },
    {
      'title': "Food Aid Society",
      'location': "Liaquatabad",
      'details': "100 people",
      'time': "Pickup within 2 hours",
      'rating': 4.9,
      'accepted': false,
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
          if (_currentSection == 1)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () => _showAddAlertDialog(context),
            ),
        ],
      ),
      body: Column(
        children: [
          // Section tabs
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                // Available Food Tab
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
                // Required Food Tab
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

          // Main Content Section - Using conditional rendering
          Expanded(
            child:
                _currentSection == 0
                    ? _buildAvailableSection()
                    : _buildRequiredSection(),
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
          buttonText: "Accept Pickup",
          isAvailableSection: true,
          context: context,
          onPressed: () {
            Navigator.pop(context); // Go back to GiveHelpScreen
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
        accepted: _requiredFoods[index]['accepted']!,
        buttonText: "Accept Request",
        isAvailableSection: false,
        context: context,
        onPressed: () {
          setState(() {
            _requiredFoods[index]['accepted'] = true;
          });
          
          // Return NGO location data when accepted
          Navigator.pop(context, {
            'location': LatLng(
              24.8607 + (index * 0.01), 
              67.0011 + (index * 0.01)
            ),
            'title': _requiredFoods[index]['title'],
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Accepted request from ${_requiredFoods[index]['title']}'),
              backgroundColor: const Color(0xFF40df46),
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
  bool accepted = false,
  required String buttonText,
  required bool isAvailableSection,
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
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
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
            isAvailableSection ? Icons.fastfood : Icons.people,
            details,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.access_time, time),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isAvailableSection
                  ? () {
                      Navigator.pop(context); // Go back to GiveHelpScreen
                    }
                  : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isAvailableSection
                    ? const Color(0xFF40df46)
                    : (accepted ? const Color(0xFF40df46) : const Color(0xFF40df46)),
                foregroundColor: isAvailableSection
                    ? Colors.white
                    : (accepted ? const Color(0xFF40df46) : Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                isAvailableSection ? "Accept Pickup" : 
                  (accepted ? "Accepted" : buttonText),
                style: TextStyle(
                  color: isAvailableSection
                      ? Colors.white
                      : (accepted ? const Color(0xFF40df46) : Colors.white),
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

  void _showAddAlertDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Add New Request',
              style: TextStyle(color: Colors.black),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Organization Name',
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
                    labelText: 'People to Feed',
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
                      _requiredFoods.insert(0, {
                        'title': titleController.text,
                        'location': locationController.text,
                        'details': '${quantityController.text} people',
                        'time': "Immediate Pickup",
                        'rating': 4.0,
                        'accepted': false,
                      });
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('New request added'),
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
