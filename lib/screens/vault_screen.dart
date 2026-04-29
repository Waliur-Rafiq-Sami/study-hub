import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';

class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Personal Vault')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Saved for Study',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text('Access your bookmarked resources offline.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          _buildVaultItem('OS Memory Management.pdf', 'The Archive', Icons.picture_as_pdf),
          _buildVaultItem('MinGW Configuration.md', 'Lab Infra', Icons.description),
          _buildVaultItem('Algorithms 2023 Solved.pdf', 'Solve Engine', Icons.verified),
        ],
      ),
    );
  }

  Widget _buildVaultItem(String title, String source, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: StudyHubCard(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: const Color(0xFF1A237E), size: 30),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Source: $source', style: const TextStyle(fontSize: 12)),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
