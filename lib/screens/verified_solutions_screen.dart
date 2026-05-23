import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import 'resource_details_screen.dart';

class VerifiedSolutionsScreen extends StatefulWidget {
  const VerifiedSolutionsScreen({super.key});

  @override
  State<VerifiedSolutionsScreen> createState() => _VerifiedSolutionsScreenState();
}

class _VerifiedSolutionsScreenState extends State<VerifiedSolutionsScreen> {
  String selectedDept = 'All';
  final List<String> departments = ['All', 'CSE', 'EEE', 'ME', 'CE', 'BBA', 'IPE'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verified Solutions'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildSearchHeader(),
        ),
      ),
      body: Column(
        children: [
          _buildDeptFilter(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: 8,
              itemBuilder: (context, index) {
                return _buildSolutionCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search verified solves...',
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
          hintStyle: const TextStyle(color: Colors.white60, fontSize: 14),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildDeptFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final dept = departments[index];
          final isSelected = selectedDept == dept;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(dept),
              selected: isSelected,
              onSelected: (val) => setState(() => selectedDept = dept),
              selectedColor: const Color(0xFF1A237E),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF1A237E),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              backgroundColor: Colors.white,
              side: BorderSide(color: const Color(0xFF1A237E).withOpacity(0.1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSolutionCard(int index) {
    // Mock variations
    final titles = ['Final Question Solve', 'Midterm Solution Set', 'CT-2 Math Solve', 'Algorithm Lab Solve'];
    final subjects = ['CSE-3121', 'EEE-2205', 'MATH-2101', 'CSE-2201'];
    final verifiers = ['Faculty', 'CR', 'Top Contributor', 'Faculty'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: StudyHubCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResourceDetailsScreen(
                title: titles[index % 4],
                code: subjects[index % 4],
                category: 'Solve',
              ),
            ),
          );
        },
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${subjects[index % 4]}: ${titles[index % 4]}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Batch: ${8 + (index % 3)}th',
                        style: TextStyle(fontSize: 11, color: Colors.blueGrey.shade300, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      Container(width: 3, height: 3, decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text(
                        'Verified by ${verifiers[index % 4]}',
                        style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.black12),
          ],
        ),
      ),
    );
  }
}
