import 'package:flutter/material.dart';

import 'screens/animals_screen.dart';
import 'screens/conservation_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/sanctuaries_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const WildlifeGuideApp());
}

class WildlifeGuideApp extends StatelessWidget {
  const WildlifeGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wild India | Wildlife Sanctuary Guide',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WildlifeMainScreen(),
    );
  }
}

class WildlifeMainScreen extends StatefulWidget {
  const WildlifeMainScreen({super.key});

  @override
  State<WildlifeMainScreen> createState() => _WildlifeMainScreenState();
}

class _WildlifeMainScreenState extends State<WildlifeMainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    SanctuariesScreen(),
    AnimalsScreen(),
    ExploreScreen(),
    FavoritesScreen(),
    ConservationScreen(),
  ];

  static const List<String> _titles = [
    'Wild India',
    'Sanctuaries',
    'Animals',
    'Explore',
    'Favorites',
    'Conservation',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.forest_outlined),
            selectedIcon: Icon(Icons.forest),
            label: 'Sanctuaries',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets),
            label: 'Animals',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.eco_outlined),
            selectedIcon: Icon(Icons.eco),
            label: 'Conservation',
          ),
        ],
      ),
    );
  }
}
