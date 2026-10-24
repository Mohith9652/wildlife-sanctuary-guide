import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/animal.dart';
import '../models/sanctuary.dart';
import '../services/favorites_service.dart';
import '../theme/app_theme.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Set<String> _savedSanctuaryIds = <String>{};
  Set<String> _savedAnimalIds = <String>{};

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final results = await Future.wait([
        FavoritesService.getSanctuaryFavorites(),
        FavoritesService.getAnimalFavorites(),
      ]);

      if (!mounted) return;

      setState(() {
        _savedSanctuaryIds = results[0];
        _savedAnimalIds = results[1];
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to load saved items. Please try again.';
      });
    }
  }

  Future<void> _removeSanctuary(Sanctuary sanctuary) async {
    try {
      await FavoritesService.toggleSanctuaryFavorite(sanctuary.id);
      await _loadFavorites();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${sanctuary.name} removed from favorites')),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update favorites.')),
      );
    }
  }

  Future<void> _removeAnimal(Animal animal) async {
    try {
      await FavoritesService.toggleAnimalFavorite(animal.id);
      await _loadFavorites();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${animal.name} removed from favorites')),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update favorites.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedSanctuaries = sampleSanctuaries
        .where((item) => _savedSanctuaryIds.contains(item.id))
        .toList();

    final savedAnimals = sampleAnimals
        .where((item) => _savedAnimalIds.contains(item.id))
        .toList();

    final totalSaved = savedSanctuaries.length + savedAnimals.length;

    return RefreshIndicator(
      onRefresh: _loadFavorites,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Your Saved Wildlife',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: AppTheme.deepGreen,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Keep your favourite protected places and species together.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cream,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.bookmarks_outlined,
                  color: AppTheme.forestGreen,
                  size: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$totalSaved saved ${totalSaved == 1 ? 'item' : 'items'}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.deepGreen,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Your personal wildlife collection',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Refresh favorites',
                  onPressed: _loadFavorites,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(36),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_errorMessage != null)
            _MessagePanel(
              icon: Icons.error_outline,
              title: 'Could not load favorites',
              message: _errorMessage!,
              actionLabel: 'Try again',
              onAction: _loadFavorites,
            )
          else if (totalSaved == 0)
            const _MessagePanel(
              icon: Icons.bookmark_border,
              title: 'Your collection is empty',
              message:
                  'Open Sanctuaries or Animals and use the bookmark '
                  'button to save places and species here.',
            )
          else ...[
            if (savedSanctuaries.isNotEmpty) ...[
              const _SectionHeading(
                title: 'Saved sanctuaries',
                countLabel: 'Protected places',
              ),
              const SizedBox(height: 12),
              ...savedSanctuaries.map(
                (sanctuary) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _FavoriteCard(
                    title: sanctuary.name,
                    subtitle: '${sanctuary.location}, ${sanctuary.state}',
                    imageUrl: sanctuary.imageUrl,
                    icon: Icons.forest_outlined,
                    onRemove: () => _removeSanctuary(sanctuary),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (savedAnimals.isNotEmpty) ...[
              const _SectionHeading(
                title: 'Saved species',
                countLabel: 'Wildlife',
              ),
              const SizedBox(height: 12),
              ...savedAnimals.map(
                (animal) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _FavoriteCard(
                    title: animal.name,
                    subtitle: animal.scientificName,
                    imageUrl: animal.imageUrl,
                    icon: Icons.pets_outlined,
                    onRemove: () => _removeAnimal(animal),
                  ),
                ),
              ),
            ],
          ],
          const SizedBox(height: 20),
          const Text(
            'Your saved list is stored locally in this browser. '
            'Clearing browser site data may remove it.',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.countLabel});

  final String title;
  final String countLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        Text(
          countLabel,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.icon,
    required this.onRemove,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final IconData icon;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(
            width: 104,
            height: 112,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppTheme.cream,
                  alignment: Alignment.center,
                  child: Icon(icon, size: 34, color: AppTheme.leafGreen),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: 'Remove from favorites',
            onPressed: onRemove,
            icon: const Icon(
              Icons.bookmark_remove_outlined,
              color: AppTheme.forestGreen,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _MessagePanel extends StatelessWidget {
  const _MessagePanel({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 42, color: AppTheme.forestGreen),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppTheme.textSecondary,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 14),
            OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
