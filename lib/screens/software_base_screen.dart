import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';

class SoftwareBaseScreen extends StatefulWidget {
  const SoftwareBaseScreen({super.key});

  @override
  State<SoftwareBaseScreen> createState() => _SoftwareBaseScreenState();
}

class _SoftwareBaseScreenState extends State<SoftwareBaseScreen> {
  String searchQuery = '';
  String selectedLab = 'All Labs';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Toolbox'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (v) => setState(() => searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search software or lab name...',
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                hintStyle: const TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLabFilter(),
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
        ],
      ),
    );
  }

  Widget _buildLabFilter() {
    final labs = ['All Labs', 'Programming', 'Electronics', 'Machine Shop', 'Circuits'];
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: labs.map((lab) {
          final isSelected = selectedLab == lab;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(lab, style: TextStyle(color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface, fontSize: 12)),
              selected: isSelected,
              onSelected: (val) => setState(() => selectedLab = lab),
              selectedColor: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.1)),
              ),
            ),
          );
        }).toList(),
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
                      Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
                      Text(desc, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 24, color: Theme.of(context).dividerColor.withOpacity(0.1)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.storage, size: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                    const SizedBox(width: 4),
                    Text(size, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4), fontWeight: FontWeight.w500)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_for_offline_rounded, size: 18),
                  label: const Text('Download ZIP'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
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
