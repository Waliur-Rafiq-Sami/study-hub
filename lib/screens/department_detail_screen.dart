import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import 'resource_list_screen.dart';

class DepartmentDetailScreen extends StatelessWidget {
  final String departmentName;
  final IconData icon;

  const DepartmentDetailScreen({
    super.key,
    required this.departmentName,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$departmentName Hub'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeptHeader(context),
            const SizedBox(height: 32),
            
            _buildSectionTitle(context, 'Examination & Solves'),
            const SizedBox(height: 12),
            _buildExamGrid(context),
            
            const SizedBox(height: 32),
            _buildSectionTitle(context, 'Laboratory Infrastructure'),
            const SizedBox(height: 12),
            _buildLabResources(context),
            
            const SizedBox(height: 32),
            _buildSectionTitle(context, 'Department Quick Links'),
            const SizedBox(height: 12),
            _buildQuickLinks(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDeptHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: Colors.white, size: 40),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  departmentName,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'BAUST Academic Portal',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Text(
                  '1.2k+ Resources Available',
                  style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
    );
  }

  Widget _buildExamGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildActionCard(context, 'CT Questions', Icons.quiz_outlined, Colors.orange, 'Bank & Solves', 'CT'),
        _buildActionCard(context, 'Midterm', Icons.assignment_outlined, Colors.blue, 'Previous Papers', 'Midterm'),
        _buildActionCard(context, 'Semester Final', Icons.school_outlined, Colors.purple, 'Archives', 'Final'),
        _buildActionCard(context, 'Verified Solves', Icons.verified_outlined, Colors.green, 'Step-by-step', 'Solve'),
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
              department: departmentName,
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
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).colorScheme.onSurface)),
          Text(sub, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
        ],
      ),
    );
  }

  Widget _buildLabResources(BuildContext context) {
    return Column(
      children: [
        _buildListTile(
          context,
          'Lab Report Demos',
          'Standard formatting & sample reports.',
          Icons.description_outlined,
          Colors.blueGrey,
          'Lab',
        ),
        _buildListTile(
          context,
          'Lab Manuals',
          'Official $departmentName Lab Handouts.',
          Icons.menu_book_outlined,
          Colors.indigo,
          'Lab',
        ),
        _buildListTile(
          context,
          'Software Base',
          'Setup tools & required IDEs.',
          Icons.terminal_outlined,
          Colors.teal,
          'Lab',
        ),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, String title, String sub, IconData icon, Color color, String category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: StudyHubCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResourceListScreen(
                department: departmentName,
                category: category,
              ),
            ),
          );
        },
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color),
          ),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
          subtitle: Text(sub, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
        ),
      ),
    );
  }

  Widget _buildQuickLinks(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(context, 'Routine'),
          _buildChip(context, 'Syllabus'),
          _buildChip(context, 'Faculty Info'),
          _buildChip(context, 'Notices'),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label),
        onPressed: () {},
        backgroundColor: Theme.of(context).cardColor,
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.1)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}
