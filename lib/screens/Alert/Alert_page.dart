import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:math';



class AlertPage extends StatefulWidget {
  final int initialTab;
  final LatLng? userLocation;
  const AlertPage({super.key, this.initialTab = 1,this.userLocation,});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  int _currentSection = 1;
  final ScrollController _availableController = ScrollController();
  final ScrollController _requiredController = ScrollController();
  late final GenerativeModel _model;
  bool _isMatching = false;
  List<Map<String, dynamic>> _sortedNgos = [];
  String _sortingExplanation = ''; // Add this class variable

@override
void initState() {
  super.initState();
  _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: 'nope',
  );
  // Initialize with unsorted list
  _sortedNgos = List.from(_requiredFoods);
  
  // Automatically sort if we have a user location
  if (widget.userLocation != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sortNgos();
    });
  }
}

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
      'location': "Lahore",
      'coordinates': const LatLng(24.8707, 67.0111),
      'details': "80 people",
      'time': "Immediate Pickup",
      'rating': 2.2,
    },
    {
      'title': "Help Hand",
      'location': "PECHS",
      'coordinates': const LatLng(24.8807, 67.0211),
      'details': "20 children",
      'time': "Immediate Pickup",
      'rating': 4.3,
    },
    {
      'title': "Food Aid Society",
      'location': "Liaquatabad",
      'coordinates': const LatLng(24.8907, 67.0311),
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
Future<void> _sortNgos() async {
  setState(() {
    _sortedNgos = List.from(_requiredFoods);
    _isMatching = true;
    _sortingExplanation = '';
  });

  if (_availableFoods.isEmpty || widget.userLocation == null) {
    setState(() => _isMatching = false);
    return;
  }
  
  try {
    final donorLat = widget.userLocation!.latitude;
    final donorLng = widget.userLocation!.longitude;
    
    final ngosInfo = _requiredFoods.map((ngo) {
      // Calculate approximate distance (simplified for demo)
      final ngoLat = ngo['coordinates'].latitude;
      final ngoLng = ngo['coordinates'].longitude;
      final distance = sqrt(pow(ngoLat - donorLat, 2) + pow(ngoLng - donorLng, 2));
      
      return """
      NGO Name: ${ngo['title']}
      Location: ${ngo['location']}
      Distance from donor: ${distance.toStringAsFixed(2)} units
      Need: ${ngo['details']}
      Urgency: ${ngo['time']}
      Rating: ${ngo['rating']}
      ----------------------
      """;
    }).join('\n');

    final prompt = """
    Rank these NGOs from most to least suitable to receive a food donation from a donor located at (${donorLat.toStringAsFixed(4)}, ${donorLng.toStringAsFixed(4)}).
    Consider these factors in order of importance:
    1. Proximity to donor location
    2. Match between NGO's need and available food quantities
    3. Urgency (time sensitivity)
    4. NGO rating
    
    Provide your response in EXACTLY this format:
    
    [RANKINGS]
    1. First NGO Name
    2. Second NGO Name
    3. Third NGO Name
    
    [EXPLANATION]
    - First NGO Name: Explanation (consider distance: X units, need match, urgency, and rating)
    - Second NGO Name: Explanation
    - Third NGO Name: Explanation
    
    NGOs to evaluate:
    $ngosInfo
    """;

    final response = await _model.generateContent([Content.text(prompt)]);
    final responseText = response.text ?? '';
    
    if (responseText.isNotEmpty) {
      // Parse the response
      final rankingsMatch = RegExp(r'\[RANKINGS\](.*?)\[EXPLANATION\]', dotAll: true).firstMatch(responseText);
      final explanationMatch = RegExp(r'\[EXPLANATION\](.*)', dotAll: true).firstMatch(responseText);
      
      if (rankingsMatch != null) {
        final rankings = rankingsMatch.group(1)!.split('\n')
          .where((line) => line.trim().isNotEmpty && line.trim().contains('.'))
          .map((line) => line.replaceAll(RegExp(r'^\d+\.\s*'), '').trim())
          .toList();
        
        // Update sorted NGOs
        final newSortedNgos = <Map<String, dynamic>>[];
        for (final name in rankings) {
          final ngo = _requiredFoods.firstWhere(
            (n) => n['title'] == name,
            orElse: () => {},
          );
          if (ngo.isNotEmpty) newSortedNgos.add(ngo);
        }
        
        // Store explanation
        if (explanationMatch != null) {
          _sortingExplanation = explanationMatch.group(1)!.trim();
        }

        setState(() {
          _sortedNgos = newSortedNgos;
        });
      }
    }
  } catch (e) {
    debugPrint('Error sorting NGOs: $e');
    setState(() {
      _sortedNgos = List.from(_requiredFoods);
      _sortingExplanation = 'Error generating explanation: $e';
      _isMatching = false;
    });
  } finally {
    setState(() => _isMatching = false);
  }
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
        if (_currentSection == 1)
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _sortNgos,
          ),
      ],
    ),
    body: Stack(
      children: [
        Column(
          children: [
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: _currentSection == 0
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
                              color: _currentSection == 0
                                  ? const Color(0xFF40df46)
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_availableFoods.length} listings',
                            style: TextStyle(
                              fontSize: 12,
                              color: _currentSection == 0
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
                        backgroundColor: _currentSection == 1
                            ? Colors.grey[100]
                            : Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        setState(() => _currentSection = 1);
                        // Only sort if we have a location and not already matching
                        if (widget.userLocation != null && !_isMatching) {
                          _sortNgos();
                        }
                      },
                      child: Column(
                        children: [
                          Text(
                            'Urgent Food Required',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _currentSection == 1
                                  ? const Color(0xFF40df46)
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_requiredFoods.length} listings',
                            style: TextStyle(
                              fontSize: 12,
                              color: _currentSection == 1
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
            Expanded(
              child: IndexedStack(
                index: _currentSection,
                children: [
                  _buildAvailableSection(),
                  // Show loading indicator if matching, otherwise show sorted NGOs
                  _isMatching && _sortedNgos.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : _buildRequiredSection(),
                ],
              ),
            ),
          ],
        ),
        // Full-screen loading overlay when matching is in progress
        if (_isMatching && _sortedNgos.isNotEmpty)
          Container(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Color(0xFF40df46)),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Finding best NGO match...",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                  ),
                ]
                  ),
              ),
            ),
            ]
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
          index: index,
          onPressed: () {
            setState(() {
              _availableFoods[index]['accepted'] = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Accepted ${_availableFoods[index]['title']}'),
                backgroundColor: const Color(0xFF40df46),
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
      itemCount: _sortedNgos.length,
      itemBuilder: (context, index) {
        final ngo = _sortedNgos[index];
        return _buildFoodCard(
          title: ngo['title']!,
          location: ngo['location']!,
          details: ngo['details']!,
          time: ngo['time']!,
          rating: ngo['rating']!,
          accepted: false,
          buttonText: "Accept Request",
          isDonor: false,
          context: context,
          index: index,
          onPressed: () {
            Navigator.pop(context, {
              'location': ngo['coordinates'],
              'title': ngo['title'],
            });
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
  required int index,
  required VoidCallback onPressed,
}) {
  // Calculate distance if this is an NGO card and user location is available
  String distanceText = '';
  if (!isDonor && widget.userLocation != null) {
    final ngoLocation = _sortedNgos[index]['coordinates'] as LatLng;
    final distance = _calculateDistance(
      widget.userLocation!,
      ngoLocation,
    );
    distanceText = '${distance.toStringAsFixed(1)} km away';
  }

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
                  if (!isDonor) ...[
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.info, size: 18),
                      onPressed: _showSortingExplanation,
                      tooltip: 'Why this ranking?',
                    ),
                  ],
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
          
          // Show distance information if available
          if (distanceText.isNotEmpty)
            _buildDetailRow(Icons.directions, distanceText),
          
          _buildDetailRow(Icons.location_on, location),
          const SizedBox(height: 8),
          _buildDetailRow(
            isDonor ? Icons.fastfood : Icons.people,
            details,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.access_time, time),
          const SizedBox(height: 16),
          
          // Status button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDonor
                    ? (accepted 
                        ? Colors.green[100] 
                        : const Color(0xFF40df46))
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

// Helper function to calculate distance between two coordinates
double _calculateDistance(LatLng start, LatLng end) {
  const earthRadius = 6371.0; // km
  final lat1 = start.latitude * pi / 180;
  final lon1 = start.longitude * pi / 180;
  final lat2 = end.latitude * pi / 180;
  final lon2 = end.longitude * pi / 180;

  final dLat = lat2 - lat1;
  final dLon = lon2 - lon1;

  final a = sin(dLat / 2) * sin(dLat / 2) +
            cos(lat1) * cos(lat2) *
            sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c;
}

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
              style: TextStyle(color: Colors.grey[800], fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

void _showSortingExplanation() {
  if (_sortingExplanation.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please sort NGOs first to see the explanation')),
    );
    return;
  }

  String header = '';
  if (widget.userLocation != null) {
    header = 'Donor Location: (${widget.userLocation!.latitude.toStringAsFixed(4)}, '
             '${widget.userLocation!.longitude.toStringAsFixed(4)})\n\n';
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Ranking Explanation'),
      content: SingleChildScrollView(
        child: Text(
          header + _sortingExplanation,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}



  void _showAddAlertDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Listing'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF40df46),
            ),
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
                _sortNgos(); // Re-sort NGOs when new food is added
              }
            },
            child: const Text('Add Listing', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}