import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Archive'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search notes, codes...',
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                hintStyle: const TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSemesterSection(context, 'Level 3, Term I', [
            'CSE 3101: Operating Systems',
            'CSE 3103: Software Engineering',
            'CSE 3105: Microprocessors',
            'CSE 3100: SD Project II',
          ]),
          const SizedBox(height: 24),
          _buildSemesterSection(context, 'Level 2, Term II', [
            'CSE 2201: Computer Algorithms',
            'CSE 2203: Digital Electronics',
            'MATH 2205: Statistics',
          ]),
        ],
      ),
    );
  }

  Widget _buildSemesterSection(BuildContext context, String title, List<String> courses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
          ),
        ),
        ...courses.map((course) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: StudyHubCard(
            onTap: () {},
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.menu_book_outlined, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course, style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
                      Text('12 Verified Notes | 4 Questions', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
              ],
            ),
          ),
        )),
      ],
    );
  }
}
