
import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/wildlife.dart';
import '../widgets/animal_card.dart';

class WildlifeScreen extends StatefulWidget {
  final Set<String> favourites;
  final Function(String) onFavourite;

  const WildlifeScreen({
    super.key,
    required this.favourites,
    required this.onFavourite,
  });

  @override
  State<WildlifeScreen> createState() => _WildlifeScreenState();
}

class _WildlifeScreenState extends State<WildlifeScreen> {
  String search = '';
  String category = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredAnimals = animals.where((animal) {
      final matchesSearch =
          animal.name.toLowerCase().contains(search.toLowerCase());

      final matchesCategory =
          category == 'All' || animal.category == category;

      return matchesSearch && matchesCategory;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search animals...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                search = value;
              });
            },
          ),
        ),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: ['All', 'Mammal', 'Bird', 'Reptile'].map((item) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(item),
                  selected: category == item,
                  onSelected: (selected) {
                    setState(() {
                      category = item;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),

        Expanded(
          child: filteredAnimals.isEmpty
              ? const Center(
                  child: Text('No animals found.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredAnimals.length,
                  itemBuilder: (context, index) {
                    final animal = filteredAnimals[index];

                    return AnimalCard(
                      animal: animal,
                      favourite:
                          widget.favourites.contains(animal.name),
                      onFavourite: () {
                        widget.onFavourite(animal.name);
                      },
                      onTap: () {
                        _showDetails(animal);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showDetails(Animal animal) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${animal.image} ${animal.name}'),
          content: Text(
            'Category: ${animal.category}\n'
            'Habitat: ${animal.habitat}\n\n'
            '${animal.description}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
