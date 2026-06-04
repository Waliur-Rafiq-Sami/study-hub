import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import '../services/mongodb_service.dart';
import 'resource_details_screen.dart';
import 'package:mongo_dart/mongo_dart.dart' show where;

class ResourceListScreen extends StatefulWidget {
  final String department;
  final String category; 
  final String? searchQuery;
  final String? initialType; // Added to allow direct filtering (e.g. Lab Report Demo)

  const ResourceListScreen({
    super.key,
    required this.department,
    required this.category,
    this.searchQuery,
    this.initialType,
  });

  @override
  State<ResourceListScreen> createState() => _ResourceListScreenState();
}

class _ResourceListScreenState extends State<ResourceListScreen> {
  String selectedType = 'All';
  String selectedSession = 'All';
  String localSearch = '';
  
  List<Map<String, dynamic>> _resources = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    localSearch = widget.searchQuery ?? '';
    selectedType = widget.initialType ?? 'All';
    _fetchResources();
  }

  Future<void> _fetchResources() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final collection = MongoDBService.getCollection("resources");
      
      var queryBuilder = where;
      
      // 1. Build Base Filter (Dept and Category)
      if (widget.category == 'Search') {
        queryBuilder = where.eq('department', widget.department);
        if (localSearch.isNotEmpty) {
          queryBuilder = queryBuilder.and(
            where.match('title', localSearch, caseInsensitive: true)
            .or(where.match('code', localSearch, caseInsensitive: true))
          );
        }
      } else {
        queryBuilder = where.eq('department', widget.department);
        if (['CT', 'Midterm', 'Final'].contains(widget.category)) {
          queryBuilder = queryBuilder.and(where.eq('category', 'Question'));
        } else {
          queryBuilder = queryBuilder.and(where.eq('category', widget.category));
        }
        
        if (localSearch.isNotEmpty) {
          queryBuilder = queryBuilder.and(
            where.match('title', localSearch, caseInsensitive: true)
            .or(where.match('code', localSearch, caseInsensitive: true))
          );
        }
      }

      // 2. Apply Action Chips Filters
      if (selectedType != 'All') queryBuilder = queryBuilder.and(where.eq('type', selectedType));
      if (selectedSession != 'All') queryBuilder = queryBuilder.and(where.eq('session', selectedSession));

      final results = await collection.find(queryBuilder).toList();

      if (mounted) {
        setState(() {
          _resources = results.map((r) => MongoDBService.sanitize(r)).toList();
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
        title: Text(widget.category == 'Search' ? 'Search in ${widget.department}' : '${widget.department} ${widget.category}'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchAndFilterHeader(),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _resources.isEmpty 
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _resources.length,
                    itemBuilder: (context, index) => _buildImageResourceCard(_resources[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterHeader() {
    List<String> subTypes = ['All'];
    if (widget.category == 'Question' || widget.category == 'CT' || widget.category == 'Midterm' || widget.category == 'Final') {
      subTypes.addAll(['ct1', 'ct2', 'ct3', 'mid', 'labmid', 'remid', 'final', 'labfinal', 'retake', 'backlog']);
    } else if (widget.category == 'Lab Material' || widget.category == 'Lab') {
      subTypes.addAll(['lab-report-demo', 'lab-manual', 'lab-quiz-handout']);
    } else {
      subTypes.addAll(['class-note', 'Regular', 'Backlog']);
    }

    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          Container(
            height: 45,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: TextField(
              onSubmitted: (v) {
                setState(() => localSearch = v);
                _fetchResources();
              },
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Filter by code or topic...',
                hintStyle: TextStyle(color: Colors.white60),
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: subTypes.map((t) => _filterChip(t.toUpperCase(), selectedType == t, (v) => _updateType(t))).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _updateType(String t) {
    setState(() => selectedType = t);
    _fetchResources();
  }

  void _updateSession(String s) {
    setState(() => selectedSession = (selectedSession == s ? 'All' : s));
    _fetchResources();
  }

  Widget _filterChip(String label, bool isSelected, Function(bool) onSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        selected: isSelected,
        onSelected: onSelected,
        selectedColor: Colors.amber,
        backgroundColor: Colors.white.withOpacity(0.1),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildImageResourceCard(Map<String, dynamic> res) {
    final images = res['images'] as List?;
    final hasImages = images != null && images.isNotEmpty;

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
                category: res['category'] ?? 'Asset',
                imageUrls: hasImages ? List<String>.from(images) : null,
                fullData: res,
              ),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: hasImages 
                  ? Image.network(images.first, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.image))
                  : const Icon(Icons.collections_rounded, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(res['title'] ?? 'Untitled', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    '${res['code']} • ${res['type']?.toString().toUpperCase()} • ${res['session']}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                if (hasImages)
                  Text('${images.length} Pgs', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text("No image-based assets found", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
          const Text("Try searching with a different course code", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
