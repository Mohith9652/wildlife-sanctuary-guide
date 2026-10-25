import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/sample_data.dart';
import '../models/sanctuary.dart';
import '../theme/app_theme.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  Future<void> _openMap(BuildContext context, Sanctuary sanctuary) async {
    final destination =
        '${sanctuary.name}, ${sanctuary.location}, ${sanctuary.state}, India';

    final uri = Uri.https('www.google.com', '/maps/search/', <String, String>{
      'api': '1',
      'query': destination,
    });

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open Maps. Please try again.'),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open the map link. Check your browser.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Explore Wild India',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: AppTheme.deepGreen,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Discover protected landscapes, learn where they are located, '
          'and open map directions for further planning.',
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cream,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.explore_outlined,
                color: AppTheme.forestGreen,
                size: 27,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan a responsible visit',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppTheme.deepGreen,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Check official park guidance, entry permits, '
                      'opening times and local travel conditions before '
                      'you leave.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Destinations',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...sampleSanctuaries.map(
          (sanctuary) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _DestinationCard(
              sanctuary: sanctuary,
              onOpenMap: () => _openMap(context, sanctuary),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Map links open an external mapping service. '
          'Displayed destinations are educational examples; '
          'verify exact locations and visitor access before travelling.',
          style: TextStyle(
            fontSize: 12,
            height: 1.5,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _DestinationCard extends StatelessWidget {
  const _DestinationCard({required this.sanctuary, required this.onOpenMap});

  final Sanctuary sanctuary;
  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 175,
            child: Image.network(
              sanctuary.imageUrl,
              width: double.infinity,
              height: 175,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 175,
                  color: AppTheme.cream,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.forest_outlined,
                    size: 48,
                    color: AppTheme.leafGreen,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sanctuary.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.deepGreen,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: AppTheme.forestGreen,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '${sanctuary.location}, ${sanctuary.state}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  sanctuary.description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onOpenMap,
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('View on Google Maps'),
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
