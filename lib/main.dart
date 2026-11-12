
import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const WildlifeApp());
}

class WildlifeApp extends StatefulWidget {
  const WildlifeApp({super.key});

  @override
  State<WildlifeApp> createState() => _WildlifeAppState();
}

class _WildlifeAppState extends State<WildlifeApp> {
  bool dark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wildlife Sanctuary Guide',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      themeMode: dark ? ThemeMode.dark : ThemeMode.light,

      home: MainScreen(
        dark: dark,
        onThemeChanged: (value) {
          setState(() => dark = value);
        },
      ),
    );
  }
}
