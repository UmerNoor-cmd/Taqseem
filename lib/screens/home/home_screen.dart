import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_application_1/screens.dart';


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
        fontFamily: 'Roboto',
      ),
      home: const TaqseemScreen(),
    );
  }
}

class TaqseemScreen extends StatefulWidget {
  const TaqseemScreen({super.key});

  @override
  State<TaqseemScreen> createState() => _TaqseemScreenState();
}

class _TaqseemScreenState extends State<TaqseemScreen> {
  int _currentPage = 0;
  int _currentNavIndex = 0;
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start automatic page rotation
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 8), (Timer timer) {
      if (_currentPage < 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Taqseem',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main project card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Taqseem Food Relief Network',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '5,225 kg food rescued from waste',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: 0.75,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '5,225 Donators',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '2 days left',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              child: const Text(
                                'Donate Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(height: 4),
                            const SizedBox(height: 12),
                            Padding( 
                              padding: const EdgeInsets.only(top: 45),
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  side: const BorderSide(color: Colors.green),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                ),
                                child: const Text(
                                  'Share',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                ),
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
            
            const SizedBox(height: 40),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20,bottom: 18),
                    child: _buildActionButton(
                      Icons.volunteer_activism,
                      'Give Help',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const GiveHelpScreen()),
                        );
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 7,bottom: 18),
                    child: _buildActionButton(
                      Icons.food_bank,
                      'Request Food',
                      () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const RequestFoodScreen()),
                        // );
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5,bottom: 18),
                    child: _buildActionButton(
                      Icons.leaderboard,
                      'Contributors',
                      () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const ContributorsScreen()),
                        // );
                      },
                    ),
                  ),
                ),
              // New Alerts button
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20,bottom: 18,left: 5),
                    child: _buildActionButton(
                      Icons.notifications_active,
                      'Alerts',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AlertPage()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

          
            const SizedBox(height: 0),
            
          // Auto-rotating banner card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias, // Ensures image respects card's rounded corners
            child: Column(
              children: [
                // Image Section (now takes 70% of card)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2, // Adjust this value
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      // Slide 1 - Top Contributors
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/banner_2.jpg'),
                            fit: BoxFit.cover, // Fills entire container
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Top Contributors of the Month',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(blurRadius: 10, color: Colors.black)
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Slide 2 - Top NGO
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/banner_1.jpg'),
                            fit: BoxFit.cover, // Fills entire container
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Top NGO of the Month',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(blurRadius: 10, color: Colors.black)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Indicator dots
                Container(
                height: 28, // Slightly taller container
                margin: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: _currentPage == index ? 24 : 8, // Active dot is wider
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4), // Slightly rounded
                        color: _currentPage == index 
                          ? Colors.green[700] 
                          : Colors.green.withOpacity(0.3),
                        boxShadow: _currentPage == index
                          ? [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.2),
                                blurRadius: 4,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                      ),
                    );
                  }),
                ),
              ),
                // Text content
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Taqseem Recognition Program',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Celebrating our top contributors and partners',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
  
      
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: BottomNavigationBar(
            currentIndex: _currentNavIndex,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              setState(() {
                _currentNavIndex = index;
              });
              // Add your navigation logic here
            },
            elevation: 10,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
  // Colors setup
  final Color buttonColor;
  final Color iconColor;
  final Color textColor;

  switch(label) {
    case 'Give Help':
      buttonColor = Colors.green.withOpacity(0.15);
      iconColor = Colors.green[800]!;
      textColor = Colors.green[900]!;
      break;
    case 'Request Food':
      buttonColor = Colors.orange.withOpacity(0.15);
      iconColor = Colors.orange[800]!;
      textColor = Colors.orange[900]!;
      break;
    case 'Contributors':
      buttonColor = Colors.blue.withOpacity(0.15);
      iconColor = Colors.blue[800]!;
      textColor = Colors.blue[900]!;
      break;

    case 'Alerts':
      buttonColor = Colors.yellow.withOpacity(0.15);
      iconColor = Colors.yellow[800]!;
      textColor = Colors.yellow[900]!;
      break;
    default:
      buttonColor = Colors.grey.withOpacity(0.15);
      iconColor = Colors.grey;
      textColor = Colors.grey[800]!;
  }

  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 11,
                spreadRadius: 5,
                offset: Offset(0, 1),
              )
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(icon, size: 30, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
            letterSpacing: 0.3,
          ),
        ),
      ],
    ),
  );
}


  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}