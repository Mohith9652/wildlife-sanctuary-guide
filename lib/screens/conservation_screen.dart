import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ConservationScreen extends StatelessWidget {
  const ConservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppTheme.deepGreen,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.eco_outlined, color: Colors.white, size: 38),
              SizedBox(height: 18),
              Text(
                'Protect Wildlife. Preserve Our Future.',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Every species plays a role in its ecosystem. '
                'Protecting wildlife and natural habitats helps '
                'maintain ecological balance for future generations.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Why conservation matters',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: AppTheme.deepGreen,
          ),
        ),
        const SizedBox(height: 12),
        const _ConservationCard(
          icon: Icons.forest_outlined,
          title: 'Protect natural habitats',
          description:
              'Forests, wetlands and grasslands provide food, shelter '
              'and breeding areas for wildlife. Habitat protection '
              'supports entire ecosystems.',
        ),
        const SizedBox(height: 12),
        const _ConservationCard(
          icon: Icons.pets_outlined,
          title: 'Safeguard threatened species',
          description:
              'Poaching, habitat loss, pollution and climate change '
              'can threaten animal populations. Conservation helps '
              'reduce these pressures.',
        ),
        const SizedBox(height: 12),
        const _ConservationCard(
          icon: Icons.water_drop_outlined,
          title: 'Keep ecosystems healthy',
          description:
              'Clean water, healthy soil and diverse plant and animal '
              'life support resilient ecosystems and human communities.',
        ),
        const SizedBox(height: 24),
        const Text(
          'Connection to the Sustainable Development Goals',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: AppTheme.deepGreen,
          ),
        ),
        const SizedBox(height: 12),
        const _SdgCard(
          number: '15',
          title: 'Life on Land',
          description:
              'Protect terrestrial ecosystems, restore degraded land, '
              'conserve biodiversity and help prevent species extinction.',
        ),
        const SizedBox(height: 12),
        const _SdgCard(
          number: '13',
          title: 'Climate Action',
          description:
              'Understand how climate change affects habitats and '
              'support efforts to reduce its impacts.',
        ),
        const SizedBox(height: 12),
        const _SdgCard(
          number: '6',
          title: 'Clean Water and Sanitation',
          description:
              'Protect rivers, wetlands and freshwater ecosystems '
              'that support wildlife and people.',
        ),
        const SizedBox(height: 24),
        const Text(
          'Small actions make a difference',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: AppTheme.deepGreen,
          ),
        ),
        const SizedBox(height: 12),
        const _ActionItem(text: 'Never feed, chase or disturb wild animals.'),
        const _ActionItem(
          text: 'Avoid single-use plastics and dispose of waste properly.',
        ),
        const _ActionItem(
          text: 'Follow park rules and remain on permitted trails.',
        ),
        const _ActionItem(
          text: 'Choose responsible wildlife tourism operators.',
        ),
        const _ActionItem(
          text: 'Support verified conservation and habitat-restoration work.',
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cream,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About this project',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.deepGreen,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Wild India is an educational wildlife sanctuary guide '
                'developed with Flutter and Dart. It helps users explore '
                'selected protected areas, learn about animal species '
                'and understand the importance of biodiversity.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Information and further reading',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.deepGreen,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'United Nations Sustainable Development Goals: '
                'sdgs.un.org/goals',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'International Union for Conservation of Nature: '
                'iucnredlist.org',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'India Ministry of Environment, Forest and Climate Change: '
                'moef.gov.in',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Learn about wildlife. Act for nature.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.forestGreen,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ConservationCard extends StatelessWidget {
  const _ConservationCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.cream,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.forestGreen, size: 25),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: AppTheme.textSecondary,
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

class _SdgCard extends StatelessWidget {
  const _SdgCard({
    required this.number,
    required this.title,
    required this.description,
  });

  final String number;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 49,
            height: 49,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.forestGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'SDG $number',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: AppTheme.textSecondary,
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

class _ActionItem extends StatelessWidget {
  const _ActionItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 21,
            color: AppTheme.forestGreen,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
