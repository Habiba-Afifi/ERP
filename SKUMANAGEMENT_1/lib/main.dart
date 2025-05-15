import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SKUManagementApp());
}

class SKUManagementApp extends StatelessWidget {
  const SKUManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SKU Management',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF5c4e2e),
          secondary: Color(0xFFb99a45),
        ),
        scaffoldBackgroundColor: const Color(0xFFf3ebd9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5c4e2e),
          titleTextStyle: TextStyle(
            color: Color(0xFFf3ebd9),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Added .0 to make it a double
          ),
          color: const Color(0xFFf7f7f7),
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Optional: Keep the MyHomePage as an alternative entry point if needed
class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          'Hello, World!',
        ),
      ),
    );
  }
}
