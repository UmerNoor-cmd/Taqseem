import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taqseem',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto', // Use your preferred font
      ),
      home: const TaqseemScreen(),
    );
  }
}

class TaqseemScreen extends StatelessWidget {
  const TaqseemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Taqseem',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.search),
          //   onPressed: () {
          //     // Implement search functionality
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Implement notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Urgent Fundraising section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Urgent Fundraising',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle "See all" action
                  },
                  child: const Text(
                    'See all',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            // Categories row with buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryButton('All', isSelected: true),
                  _buildCategoryButton('Food Relief'),
                  _buildCategoryButton('Button2'),
                  _buildCategoryButton('Button3'),
                  _buildCategoryButton('Button4'),                  
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Main project card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Taqseem: Food Relief Network',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '5,225 kg food rescued from waste',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    
                    // Progress bar
                    LinearProgressIndicator(
                      value: 0.75,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    
                    // Stats row with buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '5,225 Donators',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            const Text('2 days left'),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                // Handle donate action
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Donate Now',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Coming to an end',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            TextButton(
                              onPressed: () {
                                // Handle "See all" action
                              },
                              child: const Text(
                                'See all',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: () {
                                // Handle share action
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                side: const BorderSide(color: Colors.blue),
                              ),
                              child: const Text(
                                'Share',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Additional action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.add, 'Add Donation'),
                _buildActionButton(Icons.food_bank, 'Request Food'),
                _buildActionButton(Icons.volunteer_activism, 'Volunteer'),
              ],
            ),
          ],
        ),
      ),
      
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String text, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(text),
        selected: isSelected,
        onSelected: (bool selected) {
          // Handle category selection
        },
        selectedColor: Colors.green,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 30, color: Colors.green),
          onPressed: () {
            // Handle button action
          },
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}