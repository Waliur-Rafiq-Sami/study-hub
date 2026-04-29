import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import '../models/subject.dart';
import 'resource_details_screen.dart';

class ResourceFinderScreen extends StatefulWidget {
  final String category; // 'Question', 'Note', 'Lab'
  final String? initialDept;

  const ResourceFinderScreen({super.key, required this.category, this.initialDept});

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

  @override
  void initState() {
    super.initState();
    selectedDept = widget.initialDept;
  }

  final List<Map<String, dynamic>> departments = [
    {'name': 'CSE', 'icon': Icons.computer},
    {'name': 'EEE', 'icon': Icons.bolt},
    {'name': 'ME', 'icon': Icons.settings},
    {'name': 'CE', 'icon': Icons.architecture},
    {'name': 'BBA', 'icon': Icons.business_center},
    {'name': 'IPE', 'icon': Icons.precision_manufacturing},
    {'name': 'English', 'icon': Icons.translate},
    {'name': 'GED', 'icon': Icons.history_edu},
  ];
  
  final List<String> levels = ['1', '2', '3', '4'];
  final List<String> terms = ['I', 'II'];
  final List<String> batches = ['7th', '8th', '9th', '10th', '11th', '12th', '13th'];

  List<String> getTypes() {
    if (widget.category == 'Question') {
      return ['CT', 'Midterm', 'Semester Final'];
    } else if (widget.category == 'Note') {
      return ['Class Note', 'CT Question Note', 'CT Solve', 'Mid Solve', 'Semester Solve', 'Other Note'];
    } else {
      return ['Lab Report', 'Software Pack', 'Lab Manual', 'Lab Solution'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final types = getTypes();
    return Scaffold(
      appBar: AppBar(
        title: Text('Search ${widget.category}s'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Department', Icons.business_outlined),
            const SizedBox(height: 16),
            _buildDepartmentSelector(),
            const SizedBox(height: 32),
            
            _buildSectionHeader('Course Details', Icons.filter_list_rounded),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildDropdown('Level', levels, selectedLevel, (v) => setState(() => selectedLevel = v))),
                const SizedBox(width: 12),
                Expanded(child: _buildDropdown('Term', terms, selectedTerm, (v) => setState(() => selectedTerm = v))),
              ],
            ),
            const SizedBox(height: 16),
            _buildDropdown('Batch (Selection)', batches, selectedBatch, (v) => setState(() => selectedBatch = v)),
            const SizedBox(height: 16),
            _buildDropdown('${widget.category} Category', types, selectedType, (v) => setState(() => selectedType = v)),
            const SizedBox(height: 32),
            
            _buildSectionHeader('Subject', Icons.book_outlined),
            const SizedBox(height: 16),
            _buildSubjectSelector(),
            
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedSubject != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResourceDetailsScreen(
                          title: selectedSubject!.title,
                          code: selectedSubject!.code,
                          category: widget.category,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
                child: const Text('SEARCH ASSETS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF1A237E)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
      ],
    );
  }

  Widget _buildDepartmentSelector() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final dept = departments[index];
          final isSelected = selectedDept == dept['name'];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => setState(() => selectedDept = dept['name'] as String),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1A237E) : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? const Color(0xFF1A237E) : Colors.grey.shade300,
                        width: 2,
                      ),
                      boxShadow: isSelected 
                          ? [BoxShadow(color: const Color(0xFF1A237E).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))]
                          : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
                    ),
                    child: Center(
                      child: Icon(
                        dept['icon'] as IconData,
                        color: isSelected ? Colors.white : const Color(0xFF1A237E),
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dept['name'] as String,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF1A237E) : Colors.black87,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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

  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSubjectSelector() {
    return StudyHubCard(
      padding: EdgeInsets.zero,
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFF1A237E).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.class_outlined, color: Color(0xFF1A237E)),
        ),
        title: Text(selectedSubject?.title ?? 'Select Course', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(selectedSubject?.code ?? 'e.g. CSE-3121', style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.keyboard_arrow_down_rounded),
        onTap: () => _showSubjectPicker(),
      ),
    );
  }

  void _showSubjectPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            final filteredSubjects = mockSubjects.where((s) => selectedDept == null || s.department == selectedDept).toList();
            return Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Pick Academic Course', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: filteredSubjects.length,
                    itemBuilder: (context, index) {
                      final s = filteredSubjects[index];
                      return ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                          child: Text(s.department, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                        ),
                        title: Text(s.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(s.code),
                        trailing: const Icon(Icons.add_circle_outline, size: 20, color: Color(0xFF1A237E)),
                        onTap: () {
                          setState(() => selectedSubject = s);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
