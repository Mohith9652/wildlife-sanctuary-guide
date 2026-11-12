
import 'package:flutter/material.dart';
import '../models/wildlife.dart';

class AnimalCard extends StatelessWidget {
  final Animal animal;
  final bool favourite;
  final VoidCallback onFavourite;
  final VoidCallback onTap;

  const AnimalCard({
    super.key,
    required this.animal,
    required this.favourite,
    required this.onFavourite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Text(
            animal.image,
            style: const TextStyle(fontSize: 25),
          ),
        ),
        title: Text(animal.name),
        subtitle: Text('${animal.category} • ${animal.habitat}'),
        trailing: IconButton(
          onPressed: onFavourite,
          icon: Icon(
            favourite ? Icons.favorite : Icons.favorite_border,
            color: favourite ? Colors.red : Colors.grey,
          ),
        ),
      ),
    );
  }
}
