import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all as read', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildNotificationItem(index);
        },
      ),
    );
  }

  Widget _buildNotificationItem(int index) {
    final types = ['Verification', 'New Content', 'System', 'Vault'];
    final titles = [
      'Resource Verified!',
      'New Final Question Added',
      'System Maintenance',
      'Vault Backup Successful'
    ];
    final descs = [
      'Your CSE-3101 Midterm Solve has been verified by CR.',
      'Batch 10th Final Question for EEE-2205 is now available.',
      'StudyHub will be down for 2 hours tonight for upgrades.',
      'Your study vault has been synced to the cloud.'
    ];
    final icons = [Icons.verified_user, Icons.auto_stories, Icons.settings_suggest, Icons.cloud_done];
    final colors = [Colors.green, Colors.blue, Colors.orange, Colors.purple];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: StudyHubCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors[index % 4].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icons[index % 4], color: colors[index % 4], size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        types[index % 4],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: colors[index % 4],
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        '${index + 1}h ago',
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    titles[index % 4],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descs[index % 4],
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade600, height: 1.4),
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
