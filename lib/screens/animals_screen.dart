import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/animal.dart';
import '../services/favorites_service.dart';
import '../theme/app_theme.dart';

class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});

  @override
  State<AnimalsScreen> createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> {
  final TextEditingController _searchController = TextEditingController();

  Set<String> _favoriteIds = <String>{};
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await FavoritesService.getAnimalFavorites();

      if (!mounted) return;

      setState(() {
        _favoriteIds = favorites;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(Animal animal) async {
    try {
      await FavoritesService.toggleAnimalFavorite(animal.id);
      final updatedFavorites = await FavoritesService.getAnimalFavorites();

      if (!mounted) return;

      setState(() {
        _favoriteIds = updatedFavorites;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _favoriteIds.contains(animal.id)
                ? '${animal.name} added to favorites'
                : '${animal.name} removed from favorites',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to update favorites. Please try again.'),
        ),
      );
    }
  }

  List<Animal> get _filteredAnimals {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) return sampleAnimals;

    return sampleAnimals.where((animal) {
      return animal.name.toLowerCase().contains(query) ||
          animal.scientificName.toLowerCase().contains(query) ||
          animal.category.toLowerCase().contains(query) ||
          animal.habitat.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final animals = _filteredAnimals;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Discover Wildlife',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: AppTheme.deepGreen,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Meet the remarkable animals that depend on India’s wild places.',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search species, category or habitat',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear search',
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Species collection',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            Text(
              '${animals.length} ${animals.length == 1 ? 'species' : 'species'}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (animals.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: const Column(
              children: [
                Icon(Icons.search_off, size: 42, color: AppTheme.textSecondary),
                SizedBox(height: 12),
                Text(
                  'No species found',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 6),
                Text(
                  'Try another animal name or habitat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ],
            ),
          )
        else
          ...animals.map(
            (animal) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _AnimalCard(
                animal: animal,
                isFavorite: _favoriteIds.contains(animal.id),
                onFavoriteTap: () => _toggleFavorite(animal),
                onTap: () async {
                  await Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => AnimalDetailScreen(
                        animal: animal,
                        initiallyFavorite: _favoriteIds.contains(animal.id),
                      ),
                    ),
                  );

                  if (mounted) {
                    await _loadFavorites();
                  }
                },
              ),
            ),
          ),
        const SizedBox(height: 12),
        const Text(
          'Wildlife information is provided for educational purposes. '
          'Species conservation status can change over time.',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _AnimalCard extends StatelessWidget {
  const _AnimalCard({
    required this.animal,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onTap,
  });

  final Animal animal;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppTheme.border),
    );

    return Material(
      color: AppTheme.surface,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 190,
                  width: double.infinity,
                  child: Image.network(
                    animal.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.cream,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.pets,
                          size: 54,
                          color: AppTheme.leafGreen,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: isFavorite
                          ? 'Remove from favorites'
                          : 'Add to favorites',
                      onPressed: onFavoriteTap,
                      icon: Icon(
                        isFavorite ? Icons.bookmark : Icons.bookmark_border,
                        color: AppTheme.forestGreen,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    animal.name,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    animal.scientificName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoTag(
                        icon: Icons.category_outlined,
                        label: animal.category,
                      ),
                      _InfoTag(
                        icon: Icons.landscape_outlined,
                        label: animal.habitat,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'View species details',
                        style: TextStyle(
                          color: AppTheme.forestGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 17,
                        color: AppTheme.forestGreen,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  const _InfoTag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.cream,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.forestGreen),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimalDetailScreen extends StatefulWidget {
  const AnimalDetailScreen({
    super.key,
    required this.animal,
    required this.initiallyFavorite,
  });

  final Animal animal;
  final bool initiallyFavorite;

  @override
  State<AnimalDetailScreen> createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initiallyFavorite;
  }

  Future<void> _toggleFavorite() async {
    try {
      await FavoritesService.toggleAnimalFavorite(widget.animal.id);

      if (!mounted) return;

      setState(() {
        _isFavorite = !_isFavorite;
      });
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to update favorites. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final animal = widget.animal;

    return Scaffold(
      appBar: AppBar(
        title: Text(animal.name),
        actions: [
          IconButton(
            tooltip: _isFavorite ? 'Remove from favorites' : 'Add to favorites',
            onPressed: _toggleFavorite,
            icon: Icon(_isFavorite ? Icons.bookmark : Icons.bookmark_border),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              animal.imageUrl,
              height: 240,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 240,
                  color: AppTheme.cream,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.pets,
                    size: 64,
                    color: AppTheme.leafGreen,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            animal.name,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w800,
              color: AppTheme.deepGreen,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            animal.scientificName,
            style: const TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 22),
          _DetailSection(
            title: 'About this species',
            content: animal.description,
          ),
          _DetailSection(title: 'Habitat', content: animal.habitat),
          _DetailSection(title: 'Category', content: animal.category),
          _DetailSection(
            title: 'Conservation status',
            content: animal.conservationStatus,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _toggleFavorite,
            icon: Icon(
              _isFavorite ? Icons.bookmark_remove : Icons.bookmark_add,
            ),
            label: Text(
              _isFavorite ? 'Remove from saved species' : 'Save this species',
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.forestGreen,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
