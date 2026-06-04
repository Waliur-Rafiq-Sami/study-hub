import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import '../services/mongodb_service.dart';
import 'resource_details_screen.dart';

class VerifiedSolutionsScreen extends StatefulWidget {
  const VerifiedSolutionsScreen({super.key});

  @override
  State<VerifiedSolutionsScreen> createState() => _VerifiedSolutionsScreenState();
}

class _VerifiedSolutionsScreenState extends State<VerifiedSolutionsScreen> {
  String selectedDept = 'All';
  final List<String> departments = ['All', 'CSE', 'EEE', 'ME', 'CE', 'BBA', 'IPE'];
  List<Map<String, dynamic>> _solves = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSolves();
  }

  Future<void> _fetchSolves() async {
    setState(() => _isLoading = true);
    try {
      final collection = MongoDBService.getCollection("resources");
      
      var query = MongoDBService.where.eq('status', 'verified').eq('category', 'Solve');
      if (selectedDept != 'All') {
        query = query.eq('department', selectedDept);
      }

      final results = await collection.find(query).toList();

      if (mounted) {
        setState(() {
          _solves = results.map((r) => MongoDBService.sanitize(r)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _solves.isEmpty 
                ? const Center(child: Text("No verified solutions found"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: _solves.length,
                    itemBuilder: (context, index) {
                      return _buildSolutionCard(_solves[index]);
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
          fillColor: Colors.white.withValues(alpha: 0.15),
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
              onSelected: (val) {
                setState(() => selectedDept = dept);
                _fetchSolves();
              },
              selectedColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              backgroundColor: Theme.of(context).cardColor,
              side: BorderSide(color: Theme.of(context).primaryColor.withValues(alpha: 0.1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSolutionCard(Map<String, dynamic> res) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: StudyHubCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResourceDetailsScreen(
                title: res['title'] ?? 'Untitled',
                code: res['code'] ?? 'N/A',
                category: 'Solve',
                imageUrls: res['images'] != null ? List<String>.from(res['images']) : null,
                fullData: res,
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
                color: Colors.green.withValues(alpha: 0.1),
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
                    res['title'] ?? 'Untitled Solve',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Dept: ${res['department']}',
                        style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      Container(width: 3, height: 3, decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      const Text(
                        'Verified',
                        style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
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
