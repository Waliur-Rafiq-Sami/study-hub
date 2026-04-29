import 'package:flutter/material.dart';
import 'software_base_screen.dart';
import 'archive_screen.dart';
import 'solve_engine_screen.dart';
import 'vault_screen.dart';
import 'resource_finder_screen.dart';
import 'department_detail_screen.dart';
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
            _buildPremiumHeader(),
            const SizedBox(height: 24),

            // Main Pillars
            const Text(
              'Explore Academic Pillars',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildMainActionCard(
                  context,
                  'Total Question',
                  'CT, Mid, Semester',
                  Icons.quiz_rounded,
                  Colors.orange.shade800,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResourceFinderScreen(category: 'Question'))),
                ),
                _buildMainActionCard(
                  context,
                  'My Study Vault',
                  'Bookmarks & Saves',
                  Icons.bookmarks_rounded,
                  Colors.blue.shade800,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VaultScreen())),
                ),
                _buildMainActionCard(
                  context,
                  'Lab Materials',
                  'Software & Lab Info',
                  Icons.terminal_rounded,
                  Colors.green.shade800,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SoftwareBaseScreen())),
                ),
                _buildMainActionCard(
                  context,
                  'Academic Notes',
                  'Class, CT, Final Notes',
                  Icons.menu_book_rounded,
                  Colors.purple.shade800,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResourceFinderScreen(category: 'Note'))),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Enhanced Departments Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Academic Departments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                ),
                TextButton(onPressed: () {}, child: const Text('Search All')),
              ],
            ),
            const SizedBox(height: 12),
            _buildDepartmentGrid(context),
            
            const SizedBox(height: 32),
            // Verified Highlights
            const Text(
              'Verified Solutions Feed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
            ),
            const SizedBox(height: 12),
            _buildRecentItem(
              'CSE-3121: Final Question Solve',
              'Batch: 8th | Verified by Faculty',
              Icons.check_circle_outline,
            ),
            _buildRecentItem(
              'EEE-2205: Midterm Notes',
              'Batch: 9th | Verified by CR',
              Icons.description_outlined,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF1A237E),
        label: const Text('Upload'),
        icon: const Icon(Icons.cloud_upload_outlined),
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1A237E), Colors.indigo.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white, size: 35),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hello, Samir!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text('ID: 0802410205101088', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                  child: const Text('Dept: CSE | L-3 T-I', style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainActionCard(BuildContext context, String title, String sub, IconData icon, Color color, VoidCallback onTap) {
    return StudyHubCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 28),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(sub, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentGrid(BuildContext context) {
    final depts = [
      {'name': 'CSE', 'icon': Icons.computer_rounded, 'color': Colors.blue},
      {'name': 'EEE', 'icon': Icons.bolt_rounded, 'color': Colors.orange},
      {'name': 'ME', 'icon': Icons.settings_applications_rounded, 'color': Colors.red},
      {'name': 'CE', 'icon': Icons.architecture_rounded, 'color': Colors.brown},
      {'name': 'BBA', 'icon': Icons.business_center_rounded, 'color': Colors.green},
      {'name': 'IPE', 'icon': Icons.precision_manufacturing_rounded, 'color': Colors.teal},
      {'name': 'English', 'icon': Icons.translate_rounded, 'color': Colors.purple},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: depts.length,
        itemBuilder: (context, index) {
          final dept = depts[index];
          final deptColor = dept['color'] as Color;
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DepartmentDetailScreen(
                    departmentName: dept['name'] as String,
                    icon: dept['icon'] as IconData,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: deptColor.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: deptColor.withOpacity(0.1), width: 1.5),
                    ),
                    child: Icon(dept['icon'] as IconData, color: deptColor, size: 30),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dept['name'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: Colors.blue),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          subtitle: Text(status, style: const TextStyle(fontSize: 11)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        ),
      ),
    );
  }
}
