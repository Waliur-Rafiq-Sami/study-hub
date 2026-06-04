import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import 'resource_list_screen.dart';
import '../services/mongodb_service.dart';

class DepartmentDetailScreen extends StatefulWidget {
  final String departmentName;
  final IconData icon;

  const DepartmentDetailScreen({
    super.key,
    required this.departmentName,
    required this.icon,
  });

  @override
  State<DepartmentDetailScreen> createState() => _DepartmentDetailScreenState();
}

class _DepartmentDetailScreenState extends State<DepartmentDetailScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResourceListScreen(
          department: widget.departmentName,
          category: 'Search',
          searchQuery: query,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userRole = MongoDBService.currentUser?['role'] ?? 'Student';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, userRole),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBox(context),
                  const SizedBox(height: 32),
                  _buildSectionHeader('EXAMINATION BANK'),
                  const SizedBox(height: 16),
                  _buildExamGrid(context),
                  const SizedBox(height: 32),
                  _buildSectionHeader('PRACTICAL & LAB HUB'),
                  const SizedBox(height: 16),
                  _buildLabSection(context),
                  const SizedBox(height: 32),
                  _buildSectionHeader('QUICK ACCESS TOOLS'),
                  const SizedBox(height: 16),
                  _buildQuickTools(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, String userRole) {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        if (userRole != 'Student')
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_rounded, color: Colors.amber),
            onPressed: () => _showModeratorTools(context, userRole),
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          '${widget.departmentName} HUB',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                widget.icon,
                size: 200,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: Colors.white, size: 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: _onSearch,
        decoration: InputDecoration(
          hintText: 'Search within ${widget.departmentName}...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: Theme.of(context).primaryColor),
          suffixIcon: IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {},
            color: Colors.grey,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildExamGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildActionCard(context, 'CT PORTAL', Icons.quiz_rounded, Colors.orange, 'Bank & Solutions', 'CT'),
        _buildActionCard(context, 'MID EXAMS', Icons.assignment_rounded, Colors.blue, 'Previous Papers', 'Midterm'),
        _buildActionCard(context, 'FINAL PAPERS', Icons.school_rounded, Colors.purple, 'Master Archives', 'Final'),
        _buildActionCard(context, 'EXAM SOLVES', Icons.verified_rounded, Colors.green, 'Step-by-step', 'Solve'),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color, String sub, String category) {
    return StudyHubCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResourceListScreen(
              department: widget.departmentName,
              category: category,
            ),
          ),
        );
      },
      color: color.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text(sub, style: TextStyle(fontSize: 9, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildLabSection(BuildContext context) {
    return Column(
      children: [
        _buildLabTile(context, 'Lab Report Demos', 'Standard formatting guides', Icons.description_rounded, Colors.indigo, 'lab-report-demo'),
        const SizedBox(height: 12),
        _buildLabTile(context, 'Lab Manuals', 'Official university handouts', Icons.menu_book_rounded, Colors.teal, 'lab-manual'),
        const SizedBox(height: 12),
        _buildLabTile(context, 'Lab Quiz Bank', 'Previous year viva & quiz', Icons.psychology_rounded, Colors.deepOrange, 'lab-quiz-handout'),
      ],
    );
  }

  Widget _buildLabTile(BuildContext context, String title, String sub, IconData icon, Color color, String type) {
    return StudyHubCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResourceListScreen(
              department: widget.departmentName,
              category: 'Lab Material',
              initialType: type,
            ),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(sub, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildQuickTools(BuildContext context) {
    return Row(
      children: [
        _toolIcon(context, 'ROUTINE', Icons.event_note_rounded, Colors.blue),
        const SizedBox(width: 12),
        _toolIcon(context, 'SYLLABUS', Icons.import_contacts_rounded, Colors.purple),
        const SizedBox(width: 12),
        _toolIcon(context, 'FACULTY', Icons.groups_rounded, Colors.teal),
      ],
    );
  }

  Widget _toolIcon(BuildContext context, String label, IconData icon, Color color) {
    return Expanded(
      child: StudyHubCard(
        onTap: () {},
        color: color.withOpacity(0.05),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: color)),
          ],
        ),
      ),
    );
  }

  void _showModeratorTools(BuildContext context, String userRole) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 32),
            Text('$userRole Control Center', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _modTile(Icons.pending_actions_rounded, 'Verify Uploads', '8 items pending', Colors.orange),
            _modTile(Icons.people_outline_rounded, 'Manage Members', 'Dept database', Colors.blue),
            _modTile(Icons.analytics_outlined, 'Dept Analytics', 'View engagement', Colors.green),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _modTile(IconData icon, String title, String sub, Color color) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {},
    );
  }
}
