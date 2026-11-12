
import 'package:flutter/material.dart';
import '../data/app_data.dart';

class ConservationScreen extends StatefulWidget {
  const ConservationScreen({super.key});

  @override
  State<ConservationScreen> createState() =>
      _ConservationScreenState();
}

class _ConservationScreenState extends State<ConservationScreen> {
  final Set<int> completed = {};

  @override
  Widget build(BuildContext context) {
    final progress = completed.length / conservationTips.length;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'Protect Our Wildlife',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Small actions can make a big difference to nature.',
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 22),
        Text(
          'Your Progress: ${completed.length}/${conservationTips.length}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: progress,
          minHeight: 9,
        ),
        const SizedBox(height: 18),
        ...List.generate(conservationTips.length, (index) {
          return Card(
            child: CheckboxListTile(
              value: completed.contains(index),
              title: Text(conservationTips[index]),
              secondary: const Icon(
                Icons.eco,
                color: Colors.green,
              ),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    completed.add(index);
                  } else {
                    completed.remove(index);
                  }
                });
              },
            ),
          );
        }),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            setState(() => completed.clear());
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Reset Checklist'),
        ),
      ],
    );
  }
}
