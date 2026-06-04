import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import '../models/subject.dart';
import 'resource_list_screen.dart';
import '../services/mongodb_service.dart';

class ResourceFinderScreen extends StatefulWidget {
  final String category; 
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
  String? selectedType; 

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
  ];
  
  final List<String> levels = ['1', '2', '3', '4'];
  final List<String> terms = ['I', 'II'];
  final List<String> batches = ['7th', '8th', '9th', '10th', '11th', '12th', '13th'];

  List<String> getTypes() {
    if (widget.category == 'Question') {
      return ['ct1', 'ct2', 'ct3', 'mid', 'final'];
    } else if (widget.category == 'Note') {
      return ['class-note', 'solved-note'];
    } else {
      return ['lab-report-demo', 'lab-manual'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final types = getTypes();
    return Scaffold(
      appBar: AppBar(
        title: Text('Find ${widget.category}s'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('SELECT DEPARTMENT'),
            const SizedBox(height: 16),
            _buildDeptGrid(),
            const SizedBox(height: 32),
            
            _sectionLabel('ACADEMIC FILTERS'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _awesomeDrop('Level', levels, selectedLevel, (v) => setState(() => selectedLevel = v))),
                const SizedBox(width: 12),
                Expanded(child: _awesomeDrop('Term', terms, selectedTerm, (v) => setState(() => selectedTerm = v))),
              ],
            ),
            const SizedBox(height: 16),
            _awesomeDrop('Batch', batches, selectedBatch, (v) => setState(() => selectedBatch = v)),
            const SizedBox(height: 16),
            _awesomeDrop('Specific Type', types, selectedType, (v) => setState(() => selectedType = v)),
            
            const SizedBox(height: 48),
            _buildSearchButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String t) => Text(t, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Theme.of(context).primaryColor.withOpacity(0.6), letterSpacing: 1.2));

  Widget _buildDeptGrid() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final d = departments[index];
          final isSelected = selectedDept == d['name'];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => setState(() => selectedDept = d['name']),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                      boxShadow: isSelected ? [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))] : [],
                      border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.2)),
                    ),
                    child: Icon(d['icon'], color: isSelected ? Colors.white : Theme.of(context).primaryColor, size: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(d['name'], style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Theme.of(context).primaryColor : Colors.grey)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _awesomeDrop(String hint, List<String> items, String? val, Function(String?) onC) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.withOpacity(0.1))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: val,
          hint: Text(hint, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: onC,
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: () {
          if (selectedDept == null) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a department")));
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResourceListScreen(
                department: selectedDept!,
                category: widget.category,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A237E),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: const Text('PROCEED TO ASSETS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
      ),
    );
  }
}
