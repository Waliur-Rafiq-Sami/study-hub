import 'package:flutter/material.dart';
import 'resource_details_screen.dart';
import '../widgets/custom_card.dart';
import '../services/mongodb_service.dart';

class SoftwareBaseScreen extends StatefulWidget {
  const SoftwareBaseScreen({super.key});

  @override
  State<SoftwareBaseScreen> createState() => _SoftwareBaseScreenState();
}

class _SoftwareBaseScreenState extends State<SoftwareBaseScreen> {
  String searchQuery = '';
  String selectedFilter = 'All';
  List<Map<String, dynamic>> _software = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSoftware();
  }

  Future<void> _fetchSoftware() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final collection = MongoDBService.getCollection("resources");
      
      final query = MongoDBService.where
          .eq('category', 'Lab Material')
          .or(MongoDBService.where.eq('category', 'Lab Quiz'))
          .or(MongoDBService.where.eq('category', 'Academic Tool'));
      
      final results = await collection.find(query).toList();

      if (mounted) {
        setState(() {
          _software = results.map((r) => MongoDBService.sanitize(r)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _software.where((s) {
      final matchesSearch = s['title'].toString().toLowerCase().contains(searchQuery.toLowerCase()) || 
                           s['code'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      
      bool matchesFilter = true;
      if (selectedFilter == 'Lab Report Demo') {
        matchesFilter = s['type'] == 'lab-report-demo';
      } else if (selectedFilter != 'All') {
        matchesFilter = s['category'] == selectedFilter;
      }
      
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab & Toolbox'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              onChanged: (v) => setState(() => searchQuery = v),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search software, tools or quizzes...',
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildHorizontalFilter(),
              const SizedBox(height: 24),
              if (filtered.isEmpty)
                _buildEmptyState()
              else
                ...filtered.map((item) => _buildLabResourceCard(item)),
            ],
          ),
    );
  }

  Widget _buildHorizontalFilter() {
    final filters = ['All', 'Lab Report Demo', 'Lab Material', 'Lab Quiz', 'Academic Tool'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(filter, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              selected: isSelected,
              onSelected: (val) => setState(() => selectedFilter = filter),
              selectedColor: Colors.amber,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLabResourceCard(Map<String, dynamic> item) {
    final images = item['images'] as List?;
    final hasImages = images != null && images.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: StudyHubCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResourceDetailsScreen(
                title: item['title'] ?? 'Untitled',
                code: item['code'] ?? 'N/A',
                category: item['category'] ?? 'Lab',
                imageUrls: hasImages ? List<String>.from(images) : null,
                fullData: item,
              ),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: hasImages 
                  ? Image.network(images.first, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.terminal))
                  : const Icon(Icons.build_circle_outlined, color: Colors.blueGrey),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title'] ?? 'Untitled Asset', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('${item['code']} • ${item['category']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  if (item['type'] == 'lab-report-demo')
                     Padding(
                       padding: const EdgeInsets.only(top: 4.0),
                       child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                         decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                         child: const Text('LAB DEMO', style: TextStyle(color: Colors.indigo, fontSize: 9, fontWeight: FontWeight.bold)),
                       ),
                     ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Icon(Icons.biotech_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No matching lab resources', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
