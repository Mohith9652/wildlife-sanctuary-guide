
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'wildlife_screen.dart';
import 'sanctuary_screen.dart';
import 'conservation_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  final bool dark;
  final Function(bool) onThemeChanged;

  const MainScreen({
    super.key,
    required this.dark,
    required this.onThemeChanged,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  String userName = 'Wildlife Explorer';
  bool notifications = true;

  final Set<String> favourites = {};

  final titles = [
    'Wildlife Sanctuary Guide',
    'Explore Wildlife',
    'Wildlife Sanctuaries',
    'Conservation',
    'My Profile',
  ];

  void toggleFavourite(String name) {
    setState(() {
      if (favourites.contains(name)) {
        favourites.remove(name);
      } else {
        favourites.add(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(favouriteCount: favourites.length),
      WildlifeScreen(
        favourites: favourites,
        onFavourite: toggleFavourite,
      ),
      const SanctuaryScreen(),
      const ConservationScreen(),
      ProfileScreen(
        name: userName,
        notifications: notifications,
        dark: widget.dark,
        onNameChanged: (value) {
          setState(() => userName = value);
        },
        onNotificationsChanged: (value) {
          setState(() => notifications = value);
        },
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[selectedIndex]),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets),
            label: 'Wildlife',
          ),
          NavigationDestination(
            icon: Icon(Icons.forest_outlined),
            selectedIcon: Icon(Icons.forest),
            label: 'Places',
          ),
          NavigationDestination(
            icon: Icon(Icons.eco_outlined),
            selectedIcon: Icon(Icons.eco),
            label: 'Protect',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
