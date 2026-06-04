import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../widgets/custom_card.dart';
import '../services/mongodb_service.dart';
import 'upload_solution_screen.dart';

class ResourceDetailsScreen extends StatefulWidget {
  final String title;
  final String code;
  final String category;
  final List<String>? imageUrls;
  final Map<String, dynamic>? fullData;

  const ResourceDetailsScreen({
    super.key,
    required this.title,
    required this.code,
    required this.category,
    this.imageUrls,
    this.fullData,
  });

  @override
  State<ResourceDetailsScreen> createState() => _ResourceDetailsScreenState();
}

class _ResourceDetailsScreenState extends State<ResourceDetailsScreen> {
  bool isBookmarked = false;
  bool isDownloading = false;
  bool _loadingSolutions = true;
  List<Map<String, dynamic>> _solutions = [];
  int currentPage = 1;
  late int totalPages;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    totalPages = (widget.imageUrls != null && widget.imageUrls!.isNotEmpty) 
        ? widget.imageUrls!.length 
        : 1;
    _checkBookmarkStatus();
    _fetchSolutions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _checkBookmarkStatus() {
    final user = MongoDBService.currentUser;
    if (user != null && user['saved_resources'] != null) {
      final List saved = user['saved_resources'];
      setState(() => isBookmarked = saved.contains(widget.code));
    }
  }

  Future<void> _fetchSolutions() async {
    final resourceId = widget.fullData?['_id'];
    if (resourceId == null) return;
    try {
      final collection = MongoDBService.getCollection("solutions");
      final results = await collection.find(MongoDBService.where.eq('resourceId', resourceId)).toList();
      if (mounted) setState(() { _solutions = results.map((s) => MongoDBService.sanitize(s)).toList(); _loadingSolutions = false; });
    } catch (e) { if (mounted) setState(() => _loadingSolutions = false); }
  }

  Future<void> _toggleBookmark() async {
    final user = MongoDBService.currentUser;
    if (user == null) return;
    try {
      final collection = MongoDBService.getCollection("users");
      List saved = List.from(user['saved_resources'] ?? []);
      if (isBookmarked) saved.remove(widget.code); else saved.add(widget.code);
      await collection.updateOne(MongoDBService.where.id(MongoDBService.parseId(user['_id'])), MongoDBService.modify.set('saved_resources', saved));
      user['saved_resources'] = saved;
      await MongoDBService.saveSession(user);
      setState(() => isBookmarked = !isBookmarked);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isBookmarked ? 'Added to Vault' : 'Removed from Vault'), behavior: SnackBarBehavior.floating));
    } catch (e) { developer.log("Bookmark Error: $e"); }
  }

  Future<void> _downloadImages() async {
    if (widget.imageUrls == null || widget.imageUrls!.isEmpty) return;
    setState(() => isDownloading = true);
    try {
      final directory = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
      final resourceDir = Directory('${directory.path}/${widget.code}_${DateTime.now().millisecondsSinceEpoch}');
      await resourceDir.create(recursive: true);
      int count = 0;
      for (String url in widget.imageUrls!) {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final file = File('${resourceDir.path}/page_${count + 1}.jpg');
          await file.writeAsBytes(response.bodyBytes);
          count++;
        }
      }
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloaded $count pages successfully!'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Download failed: $e'), backgroundColor: Colors.redAccent)); }
    finally { if (mounted) setState(() => isDownloading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.code, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            Text('PAGE $currentPage OF $totalPages', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(icon: Icon(isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, color: isBookmarked ? Colors.amber : Colors.white), onPressed: _toggleBookmark),
          IconButton(icon: const Icon(Icons.info_outline_rounded), onPressed: () => _showDetailedInfo(context)),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(flex: 11, child: _buildImagePager()),
              Expanded(flex: 9, child: _buildContentArea()),
            ],
          ),
          if (isDownloading) Container(color: Colors.black54, child: const Center(child: CircularProgressIndicator(color: Colors.white))),
        ],
      ),
    );
  }

  Widget _buildImagePager() {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: totalPages,
          onPageChanged: (i) => setState(() => currentPage = i + 1),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _showFullScreenImage(context, index),
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: (widget.imageUrls != null && widget.imageUrls!.isNotEmpty)
                      ? InteractiveViewer(child: Image.network(widget.imageUrls![index], fit: BoxFit.contain, loadingBuilder: (c, child, lp) => lp == null ? child : const Center(child: CircularProgressIndicator())))
                      : const Center(child: Icon(Icons.description_rounded, size: 80, color: Colors.grey)),
                ),
              ),
            );
          },
        ),
        if (totalPages > 1) ...[
          Positioned(left: 20, top: 0, bottom: 0, child: Center(child: IconButton.filledTonal(onPressed: () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut), icon: const Icon(Icons.chevron_left)))),
          Positioned(right: 20, top: 0, bottom: 0, child: Center(child: IconButton.filledTonal(onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut), icon: const Icon(Icons.chevron_right)))),
        ]
      ],
    );
  }

  Widget _buildContentArea() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(32)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -10))]),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5), maxLines: 2),
                  const SizedBox(height: 4),
                  Text('${widget.category} • ${widget.fullData?['session'] ?? 'Session'}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.bold)),
                ])),
                _buildStatusBadge(widget.fullData?['status']),
              ],
            ),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(child: _actionBtn('SAVE OFFLINE', Icons.download_rounded, isDownloading ? null : _downloadImages, Colors.green)),
              const SizedBox(width: 12),
              Expanded(child: _actionBtn('SHARE LINK', Icons.share_rounded, () => Share.share('Academic Help: ${widget.title} on StudyHub'), Theme.of(context).primaryColor)),
            ]),
            const Divider(height: 48),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('COMMUNITY SOLVES', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1)),
              TextButton.icon(onPressed: () async {
                final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => UploadSolutionScreen(resourceId: widget.fullData?['_id'], resourceCode: widget.code)));
                if (res == true) _fetchSolutions();
              }, icon: const Icon(Icons.add_circle_outline, size: 18), label: const Text('UPLOAD SOLVE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
            ]),
            const SizedBox(height: 12),
            if (_loadingSolutions) const Center(child: CircularProgressIndicator())
            else if (_solutions.isEmpty) _emptySolves()
            else ..._solutions.map((sol) => _solCard(sol)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(String l, IconData i, VoidCallback? t, Color c) => StudyHubCard(onTap: t, padding: const EdgeInsets.symmetric(vertical: 16), color: c.withOpacity(0.08), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(i, size: 18, color: c), const SizedBox(width: 8), Text(l, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: c))]));

  Widget _solCard(Map<String, dynamic> sol) => Padding(padding: const EdgeInsets.only(bottom: 12), child: StudyHubCard(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ResourceDetailsScreen(title: 'Solution by ${sol['uploadedBy']}', code: widget.code, category: 'Solution', imageUrls: List<String>.from(sol['images'] ?? []), fullData: sol))), child: Row(children: [Container(width: 45, height: 45, decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.verified_rounded, color: Colors.green, size: 20)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Solved by: ${sol['uploadedBy']}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)), Text(sol['comment'] ?? 'No detail', style: TextStyle(fontSize: 12, color: Colors.grey.shade600), maxLines: 1)]))])));

  Widget _emptySolves() => Container(padding: const EdgeInsets.all(24), width: double.infinity, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), borderRadius: BorderRadius.circular(24)), child: const Column(children: [Icon(Icons.psychology_alt_outlined, color: Colors.grey, size: 40), SizedBox(height: 12), Text('No solutions yet', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))]));

  Widget _buildStatusBadge(String? s) { final v = s == 'verified'; return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: (v ? Colors.green : Colors.amber).withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Text(v ? 'VERIFIED' : 'PENDING', style: TextStyle(color: v ? Colors.green : Colors.amber, fontSize: 10, fontWeight: FontWeight.w900))); }

  void _showDetailedInfo(BuildContext context) { showModalBottomSheet(context: context, builder: (c) => Container(padding: const EdgeInsets.all(32), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Academic Intelligence', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), const SizedBox(height: 24), _infoRow(Icons.school, 'Department', widget.fullData?['department']), _infoRow(Icons.calendar_month, 'Session', widget.fullData?['session']), _infoRow(Icons.layers, 'Level/Term', 'L-${widget.fullData?['level']} T-${widget.fullData?['term']}'), _infoRow(Icons.person, 'Uploaded By', widget.fullData?['uploadedBy']), const SizedBox(height: 16)]))); }

  Widget _infoRow(IconData i, String l, dynamic v) => Padding(padding: const EdgeInsets.only(bottom: 16), child: Row(children: [Icon(i, size: 20, color: Colors.grey), const SizedBox(width: 16), Text('$l:', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)), const SizedBox(width: 8), Text(v?.toString() ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.w900))]));

  void _showFullScreenImage(BuildContext context, int index) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(backgroundColor: Colors.black, appBar: AppBar(backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white)), body: Center(child: InteractiveViewer(child: Image.network(widget.imageUrls![index]))))));
  }
}
