import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';

class SolveEngineScreen extends StatelessWidget {
  const SolveEngineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solve Engine')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1A237E).withOpacity(0.05),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF1A237E)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Every solution is audited by CRs and Teachers before publication.',
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade800),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSolutionItem(
                  'CSE 2201: Final Q1 (2023)',
                  'Submitted by: Rafiq Samir',
                  'Verified',
                  Colors.green,
                ),
                _buildSolutionItem(
                  'EEE 1101: Midterm Q4 (2024)',
                  'Submitted by: Anika Tabassum',
                  'Pending Audit',
                  Colors.orange,
                ),
                _buildSolutionItem(
                  'MATH 2101: Calculus Part 2',
                  'Submitted by: Zahid Hasan',
                  'Verified',
                  Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Submit Solution'),
        icon: const Icon(Icons.add_task),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSolutionItem(String title, String user, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: StudyHubCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(user, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const Divider(height: 24),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('View Solution'),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border),
                  color: const Color(0xFF1A237E),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
