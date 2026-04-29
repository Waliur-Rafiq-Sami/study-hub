import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';

class SoftwareBaseScreen extends StatelessWidget {
  const SoftwareBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Software Base'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.help_outline)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoBanner(),
          const SizedBox(height: 20),
          _buildSoftwareItem(
            'CSE 1st Year Starter Pack',
            'Includes: VSCode, MinGW, Git, Python, and Setup Guide.',
            '1.2 GB',
            Icons.code_rounded,
            Colors.blue,
          ),
          _buildSoftwareItem(
            'Proteus Design Suite 8.15',
            'Pre-configured for EEE/CSE Digital Electronics labs.',
            '450 MB',
            Icons.memory_rounded,
            Colors.orange,
          ),
          _buildSoftwareItem(
            'Cisco Packet Tracer',
            'Network Simulation tool for Data Communication labs.',
            '200 MB',
            Icons.router_rounded,
            Colors.green,
          ),
          _buildSoftwareItem(
            'AutoCAD 2024 (Student Edition)',
            'Standard engineering drawing software for ME/CE.',
            '2.5 GB',
            Icons.architecture_rounded,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1A237E), Colors.indigo.shade400],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.terminal, color: Colors.white, size: 40),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lab Readiness',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  'Optimized ZIP archives for BAUST lab computers.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoftwareItem(String title, String desc, String size, IconData icon, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: StudyHubCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accentColor, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.storage, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(size, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_for_offline_rounded, size: 18),
                  label: const Text('Download ZIP'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
