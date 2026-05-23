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
import '../services/theme_manager.dart';
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
          color: Theme.of(context).cardColor,
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
          backgroundColor: Theme.of(context).cardColor,
          selectedItemColor: Theme.of(context).primaryColor,
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
      appBar: AppBar(
        title: const Text('StudyHub BAUST'),
        actions: [
          IconButton(
            icon: Icon(
              themeManager.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: Colors.white,
            ),
            onPressed: () => themeManager.toggleTheme(!themeManager.isDarkMode),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () => _showNotificationSheet(context),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            _buildPremiumHeader(context),
            const SizedBox(height: 24),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
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
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Search notes, questions, software...',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: Icon(Icons.search_rounded, color: Theme.of(context).primaryColor, size: 22),
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
              children: [
                Icon(Icons.stars_rounded, color: Theme.of(context).primaryColor, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Academic Pillars',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    letterSpacing: -0.5,
                  ),
                ),
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
                Text(
                  'Academic Departments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
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
                Text(
                  'Verified Solutions Feed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
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
              context,
              'CSE-3121: Final Question Solve',
              'Batch: 8th | Verified by Faculty',
              Icons.check_circle_outline,
            ),
            _buildRecentItem(
              context,
              'EEE-2205: Midterm Notes',
              'Batch: 9th | Verified by CR',
              Icons.description_outlined,
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A237E).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UploadResourceScreen()),
            ),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.cloud_upload_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Upload',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
              ? [Theme.of(context).primaryColor.withOpacity(0.8), Theme.of(context).cardColor]
              : [const Color(0xFF1A237E), Colors.indigo.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(isDark ? 0.1 : 0.3), 
            blurRadius: 12, 
            offset: const Offset(0, 6)
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(Icons.person, color: Colors.white, size: 35),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : color.withOpacity(0.08),
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
                child: Icon(
                  icon, 
                  size: 110, 
                  color: isDark ? Colors.white.withOpacity(0.02) : color.withOpacity(0.04)
                ),
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
                            color: color.withOpacity(isDark ? 0.2 : 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(icon, color: color, size: 26),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).dividerColor.withOpacity(0.05),
                          ),
                          child: Icon(
                            Icons.arrow_outward_rounded, 
                            size: 14, 
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sub,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
                      color: Theme.of(context).cardColor,
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
                      color: Theme.of(context).colorScheme.onSurface,
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

  void _showNotificationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Mock notification list
            final List<Map<String, dynamic>> notifications = [
              {'id': 1, 'title': 'Resource Verified!', 'desc': 'Your CSE-3101 Midterm Solve has been verified.', 'time': '1h ago', 'icon': Icons.verified_user, 'color': Colors.green},
              {'id': 2, 'title': 'New Question', 'desc': 'Batch 10th Final Question for EEE-2205 is now available.', 'time': '3h ago', 'icon': Icons.auto_stories, 'color': Colors.blue},
              {'id': 3, 'title': 'Vault Sync', 'desc': 'Your study vault has been synced successfully.', 'time': '5h ago', 'icon': Icons.cloud_done, 'color': Colors.purple},
            ];

            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Theme.of(context).dividerColor, borderRadius: BorderRadius.circular(2))),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                        TextButton(onPressed: () => setModalState(() => notifications.clear()), child: const Text('Clear All')),
                      ],
                    ),
                  ),
                  Expanded(
                    child: notifications.isEmpty 
                      ? Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_off_outlined, size: 64, color: Theme.of(context).disabledColor),
                            const SizedBox(height: 16),
                            Text('No new notifications', style: TextStyle(color: Theme.of(context).disabledColor)),
                          ],
                        ))
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final item = notifications[index];
                          return Dismissible(
                            key: Key(item['id'].toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              setModalState(() => notifications.removeAt(index));
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
                              child: const Icon(Icons.delete_outline, color: Colors.white),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: CircleAvatar(
                                    backgroundColor: item['color'].withOpacity(0.1),
                                    child: Icon(item['icon'], color: item['color'], size: 20),
                                  ),
                                  title: Text(item['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).colorScheme.onSurface)),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item['desc'], style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {},
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: const Size(50, 30),
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                            child: const Text('View', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                          ),
                                          const SizedBox(width: 12),
                                          TextButton(
                                            onPressed: () => setModalState(() => notifications.removeAt(index)),
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: const Size(50, 30),
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              foregroundColor: Colors.redAccent,
                                            ),
                                            child: const Text('Delete', style: TextStyle(fontSize: 12)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Text(item['time'], style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildRecentItem(BuildContext context, String title, String status, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
