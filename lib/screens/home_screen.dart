import 'package:flutter/material.dart';
import 'software_base_screen.dart';
import 'archive_screen.dart';
import 'solve_engine_screen.dart';
import 'vault_screen.dart';
import '../widgets/custom_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const VaultScreen(),
    const SoftwareBaseScreen(),
    const Center(child: Text('Settings / More Coming Soon')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), activeIcon: Icon(Icons.bookmark), label: 'Vault'),
          BottomNavigationBarItem(icon: Icon(Icons.download_outlined), activeIcon: Icon(Icons.download), label: 'Software'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'More'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyHub BAUST'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            const Text(
              'Welcome back, Samir!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'ID: 0802410205101088 | CSE Dept.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search notes, questions, software...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 24),

            // Core Pillars Section
            const Text(
              'Academic Pillars',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _buildPillarCard(
                  context,
                  'The Archive',
                  Icons.folder_copy_outlined,
                  Colors.blue.shade700,
                  'Notes & Questions',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ArchiveScreen()),
                    );
                  },
                ),
                _buildPillarCard(
                  context,
                  'Solve Engine',
                  Icons.psychology_outlined,
                  Colors.orange.shade800,
                  'Verified Solutions',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SolveEngineScreen()),
                    );
                  },
                ),
                _buildPillarCard(
                  context,
                  'Lab Infra',
                  Icons.terminal_outlined,
                  Colors.green.shade700,
                  'Software Base',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SoftwareBaseScreen()),
                    );
                  },
                ),
                _buildPillarCard(
                  context,
                  'Verification',
                  Icons.verified_user_outlined,
                  Colors.purple.shade700,
                  'CR Review Queue',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Departments Section
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Departments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: null, child: Text('View All')),
              ],
            ),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildDeptIcon('CSE', Icons.computer),
                  _buildDeptIcon('EEE', Icons.bolt),
                  _buildDeptIcon('ME', Icons.settings),
                  _buildDeptIcon('CE', Icons.apartment),
                  _buildDeptIcon('BBA', Icons.business_center),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            // Recent Verified Content
            const Text(
              'Recent Verified Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildRecentItem(
              'CSE 3101: Operating Systems',
              'Verified by CR - 2 hours ago',
              Icons.description_outlined,
            ),
            _buildRecentItem(
              'EEE 2205: Electrical Machines',
              'Verified by Faculty - 5 hours ago',
              Icons.description_outlined,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        tooltip: 'Upload Resource',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPillarCard(BuildContext context, String title, IconData icon, Color color, String subtitle, {VoidCallback? onTap}) {
    return StudyHubCard(
      onTap: onTap,
      color: color.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: color.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildDeptIcon(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.indigo.shade50,
            child: Icon(icon, color: Colors.indigo),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRecentItem(String title, String status, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: StudyHubCard(
        onTap: () {},
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(status, style: const TextStyle(fontSize: 12)),
          trailing: const Icon(Icons.chevron_right, size: 20),
        ),
      ),
    );
  }
}
