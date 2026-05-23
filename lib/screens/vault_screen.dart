import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import 'resource_details_screen.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Study Vault'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white.withOpacity(0.2) 
                    : Colors.white,
                boxShadow: [
                  if (Theme.of(context).brightness == Brightness.light)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              labelColor: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white 
                  : Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.white.withOpacity(0.6),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'QUESTIONS'),
                Tab(text: 'SOLVES'),
                Tab(text: 'LAB TOOLS'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVaultList('Question'),
          _buildVaultList('Solve'),
          _buildVaultList('Lab'),
        ],
      ),
    );
  }

  Widget _buildVaultList(String category) {
    // Mock data based on category
    final items = _getMockItems(category);

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border_rounded, size: 64, color: Theme.of(context).disabledColor),
            const SizedBox(height: 16),
            Text('No $category items saved yet', 
                 style: TextStyle(color: Theme.of(context).disabledColor, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildProfessionalVaultCard(item);
      },
    );
  }

  Widget _buildProfessionalVaultCard(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: StudyHubCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResourceDetailsScreen(
                title: item['title'],
                code: item['code'],
                category: item['type'],
              ),
            ),
          );
        },
        padding: EdgeInsets.zero,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: _getCategoryColor(item['type']),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(item['type']).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getCategoryIcon(item['type']),
                          color: _getCategoryColor(item['type']),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item['code']} • ${item['info']}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // TODO: Implement unsave logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Removed from Vault'), duration: Duration(seconds: 1)),
                          );
                        },
                        icon: const Icon(Icons.remove_circle_outline_rounded, color: Colors.redAccent, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String type) {
    switch (type) {
      case 'Question': return Colors.orange.shade700;
      case 'Solve': return Colors.green.shade700;
      case 'Lab': return Colors.blue.shade700;
      default: return const Color(0xFF1A237E);
    }
  }

  IconData _getCategoryIcon(String type) {
    switch (type) {
      case 'Question': return Icons.quiz_outlined;
      case 'Solve': return Icons.verified_outlined;
      case 'Lab': return Icons.terminal_outlined;
      default: return Icons.description_outlined;
    }
  }

  List<Map<String, dynamic>> _getMockItems(String category) {
    if (category == 'Question') {
      return [
        {'title': 'Operating Systems Final Q', 'code': 'CSE-3101', 'info': 'Winter 2024', 'type': 'Question'},
        {'title': 'Database Midterm Q', 'code': 'CSE-3121', 'info': 'Summer 2023', 'type': 'Question'},
        {'title': 'Algorithms CT 2', 'code': 'CSE-2201', 'info': 'Batch 8th', 'type': 'Question'},
      ];
    } else if (category == 'Solve') {
      return [
        {'title': 'OS Final Verified Solve', 'code': 'CSE-3101', 'info': 'By Prof. X', 'type': 'Solve'},
        {'title': 'Math 2101 Calculus Solve', 'code': 'MATH-2101', 'info': 'By CR', 'type': 'Solve'},
      ];
    } else {
      return [
        {'title': 'VS Code Starter Pack', 'code': 'IDE-Config', 'info': 'Setup Guide', 'type': 'Lab'},
        {'title': 'Proteus 8.15 ZIP', 'code': 'EEE-Lab', 'info': 'Required for L-2', 'type': 'Lab'},
      ];
    }
  }
}
