
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String name;
  final bool notifications;
  final bool dark;

  final Function(String) onNameChanged;
  final Function(bool) onNotificationsChanged;
  final Function(bool) onThemeChanged;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.notifications,
    required this.dark,
    required this.onNameChanged,
    required this.onNotificationsChanged,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const CircleAvatar(
          radius: 48,
          child: Icon(Icons.person, size: 55),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _editName(context),
          ),
        ),
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            value: notifications,
            onChanged: onNotificationsChanged,
          ),
        ),
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            value: dark,
            onChanged: onThemeChanged,
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Project'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Wildlife Sanctuary Guide',
              applicationVersion: '1.0.0',
              children: const [
                Text(
                  'A Flutter college project to explore wildlife '
                  'and learn about conservation.',
                ),
              ],
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: const Text('Feedback'),
            onTap: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Feedback'),
                content: const Text(
                  'Thank you for using Wildlife Sanctuary Guide!',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _editName(BuildContext context) {
    final controller = TextEditingController(text: name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Your name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onNameChanged(controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
