import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';


void main() {
  runApp(const TaqseemApp());
}

class TaqseemApp extends StatelessWidget {
  const TaqseemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taqseem Food Relief',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50), // Richer green shade
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0xFF4CAF50), // Matching app bar color
        ),
        // Add these for consistent text themes
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
        ),
      ),
      home: const TaqseemScreen(),
      debugShowCheckedModeBanner: false,
      // Add these for better routing experience
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(
            overscroll: false, // Disable glow effect
          ),
          child: child!,
        );
      },
    );
  }
}