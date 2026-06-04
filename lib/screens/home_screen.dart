import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' show where;
import 'software_base_screen.dart';
import 'archive_screen.dart';
import 'solve_engine_screen.dart';
import 'vault_screen.dart';
import 'resource_finder_screen.dart';
import 'department_detail_screen.dart';
import 'upload_resource_screen.dart';
import 'verified_solutions_screen.dart';
import 'settings_screen.dart';
import 'resource_details_screen.dart';
import 'resource_list_screen.dart';
import '../services/mongodb_service.dart';
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
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).cardColor,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.blueGrey.shade200,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard_rounded), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline_rounded), activeIcon: Icon(Icons.bookmark_rounded), label: 'Vault'),
            BottomNavigationBarItem(icon: Icon(Icons.biotech_outlined), activeIcon: Icon(Icons.biotech_rounded), label: 'Lab Hub'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Map<String, dynamic>> _recentResources = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecentResources();
  }

  Future<void> _fetchRecentResources() async {
    if (!mounted) return;
    try {
      final collection = MongoDBService.getCollection("resources");
      final results = await collection.find(where.sortBy('timestamp', descending: true).limit(5)).toList();
      
      if (mounted) {
        setState(() {
          _recentResources = results.map((r) => MongoDBService.sanitize(r)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MongoDBService.currentUser == null) return const Center(child: CircularProgressIndicator());
    final user = MongoDBService.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyHub BAUST', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -0.5)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(themeManager.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded, size: 20),
            onPressed: () => themeManager.toggleTheme(!themeManager.isDarkMode),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () {}),
              Positioned(right: 12, top: 12, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 4)]))),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchRecentResources,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPremiumUserHeader(user),
              const SizedBox(height: 24),
              _buildGlobalSearch(context),
              const SizedBox(height: 32),
              _buildSectionTitle('Academic Pillars'),
              const SizedBox(height: 16),
              _buildPillarGrid(context),
              const SizedBox(height: 32),
              _buildSectionTitle('Quick Department Access'),
              const SizedBox(height: 16),
              _buildDepartmentStrip(context),
              const SizedBox(height: 32),
              _buildSolutionFeedHeader(context),
              const SizedBox(height: 16),
              _buildRecentFeed(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildUploadFab(context),
    );
  }

  Widget _buildPremiumUserHeader(Map<String, dynamic> user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, const Color(0xFF3949AB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white24,
                child: Text(user['name']?[0] ?? 'S', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello, ${user['name']?.split(' ')[0]}!', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                    Text('${user['role']} | ${user['department']}', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _headerStat('Saves', '${user['saved_resources']?.length ?? 0}'),
              Container(width: 1, height: 30, color: Colors.white12),
              _headerStat('Dept', '${user['department']}'),
              Container(width: 1, height: 30, color: Colors.white12),
              _headerStat('L/T', '${user['level']}/${user['term']}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildGlobalSearch(BuildContext context) {
    return StudyHubCard(
      padding: EdgeInsets.zero,
      child: TextField(
        onSubmitted: (v) {
          if (v.isNotEmpty) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ResourceListScreen(department: 'All', category: 'Search', searchQuery: v)));
          }
        },
        decoration: InputDecoration(
          hintText: 'Search course codes, topics...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: Theme.of(context).primaryColor),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.tune_rounded, size: 18, color: Theme.of(context).primaryColor),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.onSurface, letterSpacing: -0.5));
  }

  Widget _buildPillarGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _pillarCard(context, 'Exam Bank', 'Previous Papers', Icons.quiz_rounded, Colors.orange),
        _pillarCard(context, 'Lab Hub', 'Tools & Quizzes', Icons.biotech_rounded, Colors.blue),
        _pillarCard(context, 'Archive', 'Academic Notes', Icons.auto_stories_rounded, Colors.purple),
        _pillarCard(context, 'Vault', 'Bookmarked', Icons.bookmark_rounded, Colors.green),
      ],
    );
  }

  Widget _pillarCard(BuildContext context, String title, String sub, IconData icon, Color color) {
    return StudyHubCard(
      onTap: () {
        if (title == 'Exam Bank') Navigator.push(context, MaterialPageRoute(builder: (_) => const ResourceFinderScreen(category: 'Question')));
        if (title == 'Lab Hub') Navigator.push(context, MaterialPageRoute(builder: (_) => const SoftwareBaseScreen()));
        if (title == 'Archive') Navigator.push(context, MaterialPageRoute(builder: (_) => const ArchiveScreen()));
        if (title == 'Vault') Navigator.push(context, MaterialPageRoute(builder: (_) => const VaultScreen()));
      },
      color: color.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 28)),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
          Text(sub, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDepartmentStrip(BuildContext context) {
    final depts = [
      {'name': 'CSE', 'icon': Icons.computer_rounded, 'color': Colors.blue},
      {'name': 'EEE', 'icon': Icons.bolt_rounded, 'color': Colors.orange},
      {'name': 'ME', 'icon': Icons.settings_applications_rounded, 'color': Colors.red},
      {'name': 'CE', 'icon': Icons.architecture_rounded, 'color': Colors.brown},
      {'name': 'BBA', 'icon': Icons.business_center_rounded, 'color': Colors.green},
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: depts.length,
        itemBuilder: (context, index) {
          final d = depts[index];
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DepartmentDetailScreen(departmentName: d['name'] as String, icon: d['icon'] as IconData))),
              child: Column(
                children: [
                  Container(width: 56, height: 56, decoration: BoxDecoration(color: Theme.of(context).cardColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: (d['color'] as Color).withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4))]), child: Icon(d['icon'] as IconData, color: d['color'] as Color, size: 26)),
                  const SizedBox(height: 8),
                  Text(d['name'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSolutionFeedHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionTitle('Fresh Contributions'),
        TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VerifiedSolutionsScreen())), child: const Text('View All', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildRecentFeed() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_recentResources.isEmpty) return const Center(child: Text('No resources found. Be the first to upload!'));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _recentResources.length,
      itemBuilder: (context, index) {
        final res = _recentResources[index];
        final images = res['images'] as List?;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: StudyHubCard(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ResourceDetailsScreen(title: res['title'] ?? 'N/A', code: res['code'] ?? 'N/A', category: res['category'] ?? 'General', imageUrls: images != null ? List<String>.from(images) : null, fullData: res))),
            child: Row(
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(12), child: Container(width: 60, height: 60, color: Theme.of(context).primaryColor.withOpacity(0.05), child: (images != null && images.isNotEmpty) ? Image.network(images.first, fit: BoxFit.cover) : const Icon(Icons.image_outlined))),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(res['title'] ?? 'Untitled', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                      Text('${res['code']} • ${res['type']?.toString().toUpperCase()}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade300),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUploadFab(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF3949AB)]), boxShadow: [BoxShadow(color: const Color(0xFF1A237E).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]),
      child: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadResourceScreen()));
          _fetchRecentResources();
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add_a_photo_rounded, color: Colors.white),
        label: const Text('UPLOAD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
    );
  }
}
