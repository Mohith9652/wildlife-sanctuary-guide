import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/sanctuary.dart';
import '../services/favorites_service.dart';
import '../theme/app_theme.dart';

class SanctuariesScreen extends StatefulWidget {
  const SanctuariesScreen({super.key});

  @override
  State<SanctuariesScreen> createState() => _SanctuariesScreenState();
}

class _SanctuariesScreenState extends State<SanctuariesScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  Set<String> _favoriteIds = <String>{};
  bool _isLoadingFavorites = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await FavoritesService.getSanctuaryFavorites();

      if (!mounted) return;

      setState(() {
        _favoriteIds = favorites;
        _isLoadingFavorites = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoadingFavorites = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Sanctuary> get _filteredSanctuaries {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return sampleSanctuaries;
    }

    return sampleSanctuaries.where((sanctuary) {
      return sanctuary.name.toLowerCase().contains(query) ||
          sanctuary.location.toLowerCase().contains(query) ||
          sanctuary.state.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _toggleFavorite(Sanctuary sanctuary) async {
    try {
      await FavoritesService.toggleSanctuaryFavorite(sanctuary.id);

      await _loadFavorites();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update the saved sanctuary.')),
      );
    }
  }

  Future<void> _openDetails(Sanctuary sanctuary) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => SanctuaryDetailScreen(sanctuary: sanctuary),
      ),
    );

    if (mounted) {
      await _loadFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sanctuaries = _filteredSanctuaries;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explore protected places',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.deepGreen,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Discover habitats and wildlife across India.',
                  style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search name, location or state',
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
                const SizedBox(height: 12),
                Text(
                  '${sanctuaries.length} protected places',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: sanctuaries.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: AppTheme.textSecondary,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No sanctuaries found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Try another name, location or state.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    itemCount: sanctuaries.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final sanctuary = sanctuaries[index];

                      return _SanctuaryCard(
                        sanctuary: sanctuary,
                        isFavorite: _favoriteIds.contains(sanctuary.id),
                        onFavorite: () => _toggleFavorite(sanctuary),
                        onTap: () => _openDetails(sanctuary),
                      );
                    },
                  ),
          ),
          if (_isLoadingFavorites)
            const LinearProgressIndicator(
              minHeight: 2,
              color: AppTheme.forestGreen,
            ),
        ],
      ),
    );
  }
}

class _SanctuaryCard extends StatelessWidget {
  final Sanctuary sanctuary;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  const _SanctuaryCard({
    required this.sanctuary,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppTheme.border),
    );

    return Material(
      color: AppTheme.surface,
      shape: cardShape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  sanctuary.imageUrl,
                  width: double.infinity,
                  height: 175,
                  fit: BoxFit.cover,
                  errorBuilder: (_, error, stackTrace) {
                    return Container(
                      height: 175,
                      width: double.infinity,
                      color: const Color(0xFFE6EDE1),
                      child: const Icon(
                        Icons.forest,
                        size: 54,
                        color: AppTheme.forestGreen,
                      ),
                    );
                  },
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
                      onPressed: onFavorite,
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sanctuary.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.deepGreen,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${sanctuary.location}, ${sanctuary.state}',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    sanctuary.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Text(
                        'View sanctuary details',
                        style: TextStyle(
                          color: AppTheme.forestGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
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

class SanctuaryDetailScreen extends StatefulWidget {
  final Sanctuary sanctuary;

  const SanctuaryDetailScreen({super.key, required this.sanctuary});

  @override
  State<SanctuaryDetailScreen> createState() => _SanctuaryDetailScreenState();
}

class _SanctuaryDetailScreenState extends State<SanctuaryDetailScreen> {
  bool _isFavorite = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    try {
      final favorites = await FavoritesService.getSanctuaryFavorites();

      if (!mounted) return;

      setState(() {
        _isFavorite = favorites.contains(widget.sanctuary.id);
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      await FavoritesService.toggleSanctuaryFavorite(widget.sanctuary.id);

      if (!mounted) return;

      setState(() {
        _isFavorite = !_isFavorite;
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update the saved sanctuary.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sanctuary = widget.sanctuary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sanctuary details'),
        actions: [
          IconButton(
            tooltip: _isFavorite ? 'Remove favorite' : 'Save favorite',
            onPressed: _isLoading ? null : _toggleFavorite,
            icon: Icon(_isFavorite ? Icons.bookmark : Icons.bookmark_border),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          Image.network(
            sanctuary.imageUrl,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, error, stackTrace) {
              return Container(
                height: 250,
                color: const Color(0xFFE6EDE1),
                child: const Icon(
                  Icons.forest,
                  size: 70,
                  color: AppTheme.forestGreen,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sanctuary.name,
                  style: const TextStyle(
                    fontSize: 27,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.deepGreen,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppTheme.forestGreen,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${sanctuary.location}, ${sanctuary.state}',
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'About this place',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  sanctuary.description,
                  style: const TextStyle(height: 1.7),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Wildlife and habitat highlights',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                ...sanctuary.highlights.map(
                  (highlight) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.eco_outlined,
                          size: 20,
                          color: AppTheme.forestGreen,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            highlight,
                            style: const TextStyle(height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isLoading ? null : _toggleFavorite,
                    icon: Icon(
                      _isFavorite ? Icons.bookmark : Icons.bookmark_add,
                    ),
                    label: Text(
                      _isFavorite
                          ? 'Remove from saved places'
                          : 'Save this sanctuary',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
