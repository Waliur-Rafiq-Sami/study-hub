import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import '../services/mongodb_service.dart';
import 'resource_details_screen.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  List<Map<String, dynamic>> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    setState(() => _isLoading = true);
    try {
      final collection = MongoDBService.getCollection("resources");
      final results = await collection.find(MongoDBService.where.eq('category', 'Note')).toList();

      if (mounted) {
        setState(() {
          _notes = results.map((r) => MongoDBService.sanitize(r)).toList();
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
      appBar: AppBar(
        title: const Text('Digital Archive'),
        centerTitle: true,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _fetchNotes,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                if (_notes.isEmpty)
                  const Center(child: Text("Archive is empty. Be the first to upload!"))
                else
                  ..._notes.map((note) => _buildArchiveCard(note)),
              ],
            ),
          ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Curated Academic Notes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
        const SizedBox(height: 4),
        Text('Browse handwritten and digital scans shared by BAUST top scorers.', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
      ],
    );
  }

  Widget _buildArchiveCard(Map<String, dynamic> note) {
    final images = note['images'] as List?;
    final hasImages = images != null && images.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: StudyHubCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResourceDetailsScreen(
                title: note['title'] ?? 'Untitled',
                code: note['code'] ?? 'N/A',
                category: 'Note',
                imageUrls: hasImages ? List<String>.from(images) : null,
                fullData: note,
              ),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: hasImages 
                  ? Image.network(images.first, fit: BoxFit.cover)
                  : const Icon(Icons.notes_rounded, color: Colors.blueGrey),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note['title'] ?? 'Untitled Note', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('${note['code']} • ${note['department']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text('HANDWRITTEN', style: TextStyle(color: Colors.green.shade700, fontSize: 9, fontWeight: FontWeight.bold)),
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
}
