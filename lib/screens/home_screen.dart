import 'package:flutter/material.dart';
import 'software_base_screen.dart';
import 'archive_screen.dart';
import 'solve_engine_screen.dart';
import 'vault_screen.dart';
import 'resource_finder_screen.dart';
import 'department_detail_screen.dart';
import 'upload_resource_screen.dart';
import 'verified_solutions_screen.dart';
import 'settings_screen.dart';
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
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1A237E),
          unselectedItemColor: Colors.blueGrey.shade200,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), activeIcon: Icon(Icons.bookmark_rounded), label: 'Vault'),
            BottomNavigationBarItem(icon: Icon(Icons.download_outlined), activeIcon: Icon(Icons.download_for_offline_rounded), label: 'Software'),
            BottomNavigationBarItem(icon: Icon(Icons.menu_rounded), label: 'More'),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
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

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search notes, questions, software...',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF1A237E), size: 22),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Main Pillars
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A237E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Academic Pillars',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.more_horiz, color: Colors.grey.shade400),
              ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Verified Solutions Feed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VerifiedSolutionsScreen()),
                  ),
                  child: const Text('View All'),
                ),
              ],
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
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UploadResourceScreen()),
        ),
        backgroundColor: const Color(0xFF1A237E),
        label: const Text('Upload', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.cloud_upload_rounded),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned(
                bottom: -20,
                right: -20,
                child: Icon(icon, size: 110, color: color.withOpacity(0.04)),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(icon, color: color, size: 26),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade50,
                          ),
                          child: Icon(Icons.arrow_outward_rounded, size: 14, color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sub,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey.shade300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1A237E).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF1A237E), size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blueGrey.shade300,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }
}
