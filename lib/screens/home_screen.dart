
import 'package:flutter/material.dart';
import '../data/app_data.dart';

class HomeScreen extends StatelessWidget {
  final int favouriteCount;

  const HomeScreen({
    super.key,
    required this.favouriteCount,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.green.shade800,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wildlife Sanctuary Guide',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Explore wildlife. Discover sanctuaries. Protect nature.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Explore the Wild',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _stat('Animals', '${animals.length}', Icons.pets),
            const SizedBox(width: 10),
            _stat('Sanctuaries', '${sanctuaries.length}', Icons.forest),
            const SizedBox(width: 10),
            _stat('Favourites', '$favouriteCount', Icons.favorite),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'About This Project',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'This application helps users learn about wildlife, '
          'explore Indian sanctuaries and understand the importance '
          'of protecting endangered animals.',
          style: TextStyle(fontSize: 15, height: 1.5),
        ),
        const SizedBox(height: 20),
        const Text(
          'Featured Wildlife',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...animals.take(3).map(
          (a) => Card(
            child: ListTile(
              leading: Text(
                a.image,
                style: const TextStyle(fontSize: 28),
              ),
              title: Text(a.name),
              subtitle: Text(a.habitat),
            ),
          ),
        ),
      ],
    );
  }

  Widget _stat(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 5,
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.green, size: 25),
              const SizedBox(height: 7),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
