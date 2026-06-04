import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import '../services/mongodb_service.dart';
import 'resource_details_screen.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _bookmarkedItems = [];

  @override
  void initState() {
    super.initState();
    _syncVault();
  }

  Future<void> _syncVault() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      // 1. Get latest user data from DB to ensure local session matches DB
      final userCol = MongoDBService.getCollection("users");
      final userId = MongoDBService.currentUser?['_id'];
      if (userId == null) return;

      final updatedUser = await userCol.findOne(MongoDBService.where.id(MongoDBService.parseId(userId)));
      if (updatedUser != null) {
        await MongoDBService.saveSession(updatedUser);
      }

      final List savedCodes = MongoDBService.currentUser?['saved_resources'] ?? [];
      
      if (savedCodes.isEmpty) {
        if (mounted) setState(() { _bookmarkedItems = []; _isLoading = false; });
        return;
      }

      // 2. Fetch all resource documents for these codes
      final resourceCol = MongoDBService.getCollection("resources");
      final results = await resourceCol.find(MongoDBService.where.oneFrom('code', savedCodes)).toList();
      
      if (mounted) {
        setState(() {
          _bookmarkedItems = results.map((r) => MongoDBService.sanitize(r)).toList();
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
        title: const Text('My Study Vault'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _syncVault, icon: const Icon(Icons.sync_rounded)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _syncVault,
        child: Column(
          children: [
            _buildVaultHeader(),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _bookmarkedItems.isEmpty 
                  ? _buildEmptyVault()
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _bookmarkedItems.length,
                      itemBuilder: (context, index) => _buildVaultCard(_bookmarkedItems[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaultHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your Private Repository', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'You have ${_bookmarkedItems.length} assets saved for offline access.', 
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildVaultCard(Map<String, dynamic> item) {
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
                title: item['title'] ?? 'N/A',
                code: item['code'] ?? 'N/A',
                category: item['category'] ?? 'General',
                imageUrls: hasImages ? List<String>.from(images) : null,
                fullData: item,
              ),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: hasImages 
                  ? Image.network(images.first, fit: BoxFit.cover)
                  : const Icon(Icons.bookmark_rounded, color: Colors.amber),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title'] ?? 'Untitled', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('${item['code']} • ${item['department']}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyVault() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_add_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('Your vault is empty', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Save question papers and class notes to access them instantly from this screen.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
