import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import '../models/subject.dart';

class ResourceFinderScreen extends StatefulWidget {
  final String category; // 'Question', 'Note', 'Lab'

  const ResourceFinderScreen({super.key, required this.category});

  @override
  State<ResourceFinderScreen> createState() => _ResourceFinderScreenState();
}

class _ResourceFinderScreenState extends State<ResourceFinderScreen> {
  String? selectedDept;
  String? selectedLevel;
  String? selectedTerm;
  String? selectedBatch;
  String? selectedType; // CT, Mid, Semester
  Subject? selectedSubject;

  final List<String> departments = ['CSE', 'EEE', 'ME', 'CE', 'BBA', 'English', 'IPE'];
  final List<String> levels = ['1', '2', '3', '4'];
  final List<String> terms = ['I', 'II'];
  final List<String> types = ['CT', 'Mid', 'Semester', 'Class Note', 'Solve'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find ${widget.category}s'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('1. Select Department'),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: departments.length,
                itemBuilder: (context, index) {
                  final dept = departments[index];
                  final isSelected = selectedDept == dept;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(dept),
                      selected: isSelected,
                      onSelected: (val) => setState(() => selectedDept = val ? dept : null),
                      selectedColor: const Color(0xFF1A237E),
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('2. Filter Details'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildDropdown('Level', levels, selectedLevel, (v) => setState(() => selectedLevel = v))),
                const SizedBox(width: 12),
                Expanded(child: _buildDropdown('Term', terms, selectedTerm, (v) => setState(() => selectedTerm = v))),
              ],
            ),
            const SizedBox(height: 12),
            _buildDropdown('Batch (e.g. 8th, 9th)', ['7th', '8th', '9th', '10th', '11th'], selectedBatch, (v) => setState(() => selectedBatch = v)),
            const SizedBox(height: 12),
            if (widget.category != 'Lab')
              _buildDropdown('Type', types, selectedType, (v) => setState(() => selectedType = v)),
            const SizedBox(height: 24),
            _buildSectionTitle('3. Select Subject'),
            const SizedBox(height: 12),
            _buildSubjectSelector(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Show results logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Search Academic Assets', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSubjectSelector() {
    return StudyHubCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        title: Text(selectedSubject?.title ?? 'Choose Course'),
        subtitle: Text(selectedSubject?.code ?? 'Course Code like CSE-3121'),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: () {
          // Open a dialog or bottom sheet to select subject
        },
      ),
    );
  }
}
