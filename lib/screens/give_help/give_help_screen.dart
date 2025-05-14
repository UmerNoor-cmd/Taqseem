import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_application_1/screens.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'dart:math';

class GiveHelpScreen extends StatefulWidget {
  const GiveHelpScreen({super.key});

  @override
  State<GiveHelpScreen> createState() => _GiveHelpScreenState();
}

class _GiveHelpScreenState extends State<GiveHelpScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _currentLocation = "Current Location: Not specified";
  String? _foodType;
  double? _quantity;
  final List<String> _selectedPhotos = [];
  bool _hygieneChecked = false;
  bool _safetyChecked = false;
  String _deliveryStatus = 'Not Started';
  final Set<Polyline> _polylines = {};
  List<LatLng> _routeCoordinates = [];
  bool _ngoSelected = false;
  bool _showLocationField = false;
  bool _isPickupSelected = false;
  bool _isDeliverSelected = false;
  String? _selectedNgoName; 
  
  // Animation controllers
  late AnimationController _pickupController;
  late AnimationController _deliverController;
  late Animation<double> _pickupAnimation;
  late Animation<double> _deliverAnimation;
  
  // Map-related variables
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;
  final Set<Marker> _markers = {};
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize animation controllers with proper vsync
    _pickupController = AnimationController(
      vsync: this,  // 'this' now works because we added TickerProviderStateMixin
      duration: const Duration(milliseconds: 200),
    );
    _deliverController = AnimationController(
      vsync: this,  // 'this' now works because we added TickerProviderStateMixin
      duration: const Duration(milliseconds: 200),
    );
    
    _pickupAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pickupController, curve: Curves.easeInOut),
    );
    _deliverAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _deliverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _deliverController.dispose();
    _locationController.dispose();
    super.dispose();
  }
  
  // Check if all donation requirements are met
  bool get _isDonationReady {
    return (_isPickupSelected || _isDeliverSelected) &&
           _selectedLocation != null &&
           (_formKey.currentState?.validate() ?? false) &&
           _hygieneChecked &&
           _safetyChecked;
  }

  // Show requirements message when donation isn't ready
  void _showRequirementsMessage() {
    String message = '';
    if (!_isPickupSelected && !_isDeliverSelected) {
      message = 'Please select either Pickup or Delivery method';
    } else if (_selectedLocation == null) {
      message = 'Please select a location first';
    } else if (!(_formKey.currentState?.validate() ?? false)) {
      message = 'Please fill all required fields';
    } else if (!_hygieneChecked || !_safetyChecked) {
      message = 'Please confirm hygiene and safety checks';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }




Future<void> _handleSearch() async {
  try {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Initialize with your API key
    const apiKey = "LOLNOPE";
    
    // Show search dialog
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: apiKey,
      mode: Mode.overlay,
      language: 'en',
      components: [Component(Component.country, 'pk')],
      strictbounds: false,
      types: [], // Optional: restrict to certain types
      decoration: InputDecoration(
        hintText: 'Search location',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: const Color(0xFF40df46)),
        ),
      ),
    );

    if (p != null && mounted) {
      final places = GoogleMapsPlaces(apiKey: apiKey);
      final detail = await places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        
        setState(() {
          _selectedNgoName = null; // Add this line
          _ngoSelected = false;
          _selectedLocation = LatLng(lat, lng);
          _markers.clear();
          _markers.add(
            Marker(
              markerId: const MarkerId('selected_location'),
              position: _selectedLocation!,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              infoWindow: InfoWindow(title: p.description),
            ),
          );
          _currentLocation = "Selected Location: ${p.description}";
          _locationController.text = p.description ?? '';
          _ngoSelected = false; // Reset NGO selection when location changes
        });

        _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(_selectedLocation!, 15),
        );
      }
    } else {
      if (mounted) Navigator.of(context).pop();
    }
  } catch (e) {
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}

  void _updateWithNGOLocation(LatLng location, String title) async {
    if (!mounted || _selectedLocation == null) return;
    
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Get directions (using mock data for example)
      // In a real app, you'd use Google Directions API
      _routeCoordinates = [
        _selectedLocation!,
        location,
      ];
      
      setState(() {
        _markers.clear();
        _polylines.clear();
         _selectedNgoName = title; 

        // Add origin marker
        _markers.add(
          Marker(
            markerId: const MarkerId('origin'),
            position: _selectedLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        );
        
        // Add NGO marker
        _markers.add(
          Marker(
            markerId: MarkerId(title),
            position: location,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(title: title),
          ),
        );
        
        // Add route polyline
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: _routeCoordinates,
            color: Colors.blue,
            width: 5,
          ),
        );
        
        _currentLocation = "NGO Location: $title";
        _locationController.text = title;
        _ngoSelected = true; // Set flag to true when NGO is selected
      });
      
      // Zoom to fit both markers
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          min(_selectedLocation!.latitude, location.latitude),
          min(_selectedLocation!.longitude, location.longitude),
        ),
        northeast: LatLng(
          max(_selectedLocation!.latitude, location.latitude),
          max(_selectedLocation!.longitude, location.longitude),
        ),
      );
      
      _mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting directions: ${e.toString()}')),
      );
    } finally {
      if (mounted) Navigator.of(context).pop();
    }
  }

  void _showHygieneStandardsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hygiene Standards Requirements'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'By checking this box, you confirm compliance with:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                '1. Food Freshness & Expiry',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                '• Only donate food that is not expired, spoiled, or visibly decomposed.\n'
                '• Hot food should be donated within 2 hours of preparation.\n'
                '• Cold/perishable food should be stored and transported below 5°C.',
              ),
              const SizedBox(height: 16),
              const Text(
                '2. Food Packaging',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                '• Food should be properly packaged in clean, food-grade containers.\n'
                '• No food should be in contact with newspapers or reused containers.\n'
                '• Label the food with preparation date and time, and expiry time.',
              ),
              const SizedBox(height: 16),
              const Text(
                '3. Food Types Allowed',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                '• No donation of:\n'
                '  - Leftovers from customer plates\n'
                '  - Expired, spoiled, or reheated food\n'
                '  - Food exposed for long periods at ambient temperatures',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _hygieneChecked = false;
                      });
                    },
                    child: const Text('Decline'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _hygieneChecked = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF40df46), // Changed here
                    ),
                    child: const Text('Accept'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _handlePickupTap() {
    setState(() {
      _isPickupSelected = true;
      _isDeliverSelected = false;
      _showLocationField = true;
    });
    _pickupController.forward().then((_) {
      _pickupController.reverse();
    });
  }

void _handleDeliverTap() async {
  setState(() {
    _isDeliverSelected = true;
    _isPickupSelected = false;
    _showLocationField = true;
  });
  _deliverController.forward().then((_) {
    _deliverController.reverse();
  });

  // If location is not selected, show a message and return
  if (_selectedLocation == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a location first by tapping the search icon'),
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

  // If location is selected, proceed to NGO selection
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AlertPage(initialTab: 1),
    ),
  );
  
  if (result != null && result is Map<String, dynamic> && mounted) {
    final location = result['location'] as LatLng;
    final title = result['title'] as String;
    _updateWithNGOLocation(location, title);
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donate Food'),
        backgroundColor: const Color(0xFF40df46),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Section - Only show if _showLocationField is true
            if (_showLocationField) ...[
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Enter Location',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_on),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _handleSearch,
                  ),
                ),
                readOnly: true,
                onTap: _handleSearch,
              ),
              const SizedBox(height: 20),
              
              // Map Section
              SizedBox(
                height: 200,
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(24.8607, 67.0011),
                        zoom: 12,
                      ),
                      markers: _markers,
                      polylines: _polylines,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Location Status
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _currentLocation ?? "Current Location: Not specified",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Action Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Request For Pickup Button
                AnimatedBuilder(
                  animation: _pickupAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pickupAnimation.value,
                      child: child,
                    );
                  },
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.local_shipping),
                    label: Text(_isPickupSelected ? 'Pickup Selected' : 'Request For Pickup'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isPickupSelected ? const Color(0xFF40df46).withOpacity(0.8) : const Color(0xFF40df46),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onPressed: _handlePickupTap,
                  ),
                ),
                
                // Deliver to NGO Button
                AnimatedBuilder(
                  animation: _deliverAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _deliverAnimation.value,
                    child: child,
                  ),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.notification_important),
                    label: Text(
                      _selectedNgoName != null 
                          ? _selectedNgoName! 
                          : (_isDeliverSelected ? 'Pick an NGO' : 'Deliver to NGO'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isDeliverSelected ? Colors.orange[700] : Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: _handleDeliverTap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Donation Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Food Donation Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Food Type',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.fastfood),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter food type';
                      }
                      return null;
                    },
                    onSaved: (value) => _foodType = value,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Quantity (kg)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.scale),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter quantity';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter valid number';
                      }
                      return null;
                    },
                    onSaved: (value) => _quantity = double.parse(value!),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Add Photos (Optional)',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._selectedPhotos.map(
                        (photo) => Chip(
                          label: Text(photo),
                          onDeleted: () {
                            setState(() {
                              _selectedPhotos.remove(photo);
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_a_photo),
                        onPressed: () {
                          setState(() {
                            _selectedPhotos.add(
                              'Photo ${_selectedPhotos.length + 1}',
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Hygiene & Safety Checklist',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    activeColor: const Color(0xFF40df46),
                    title: const Text(
                      'Food prepared following hygiene standards'),
                    value: _hygieneChecked,
                    onChanged: (value) {
                      if (value == true) {
                        _showHygieneStandardsDialog();
                      } else {
                        setState(() {
                          _hygieneChecked = value!;
                        });
                      }
                    },
                  ),
                  CheckboxListTile(
                    activeColor: const Color(0xFF40df46),
                    title: const Text('Proper food storage maintained'),
                    value: _safetyChecked,
                    onChanged: (value) {
                      setState(() {
                        _safetyChecked = value!;
                      });
                    },
                  ),
                  
                  // Only show delivery status if NGO is selected
                  if (_ngoSelected) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Delivery Status',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _deliveryStatus,
                      items: const [
                        DropdownMenuItem(
                          value: 'Not Started',
                          child: Text('Not Started'),
                        ),
                        DropdownMenuItem(
                          value: 'Scheduled',
                          child: Text('Scheduled'),
                        ),
                        DropdownMenuItem(
                          value: 'In Progress',
                          child: Text('In Progress'),
                        ),
                        DropdownMenuItem(
                          value: 'Completed',
                          child: Text('Completed'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _deliveryStatus = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.delivery_dining),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isDonationReady ? () {
                        _formKey.currentState?.save();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrackAlertScreen(
                              foodType: _foodType,
                              quantity: _quantity,
                            ),
                          ),
                        );
                      } : _showRequirementsMessage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isDonationReady ? const Color(0xFF40df46) : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Donate Now', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}