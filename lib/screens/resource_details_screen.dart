import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import '../models/subject.dart';

class ResourceDetailsScreen extends StatefulWidget {
  final String title;
  final String code;
  final String category;

  const ResourceDetailsScreen({
    super.key,
    required this.title,
    required this.code,
    required this.category,
  });

  @override
  State<ResourceDetailsScreen> createState() => _ResourceDetailsScreenState();
}

class _ResourceDetailsScreenState extends State<ResourceDetailsScreen> {
  bool isBookmarked = false;
  int currentPage = 1;
  final int totalPages = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.code),
        actions: [
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border, 
                 color: isBookmarked ? Colors.amber : Colors.white),
            onPressed: () => setState(() => isBookmarked = !isBookmarked),
          ),
          IconButton(
            icon: const Icon(Icons.grid_view_rounded),
            onPressed: () => _showQuickSelector(context),
            tooltip: 'Quick Switch',
          ),
        ],
      ),
      body: Column(
        children: [
          // Multi-page PDF Viewer Mock
          Expanded(
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: totalPages,
                  onPageChanged: (index) => setState(() => currentPage = index + 1),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.description, size: 100, color: Color(0xFF1A237E)),
                            const SizedBox(height: 16),
                            Text('Page ${index + 1} of $totalPages', 
                                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const Text('Scan of Academic Question Paper', 
                                 style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 30,
                  right: 30,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Page $currentPage / $totalPages', 
                         style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Controls & Suggestions
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButtons(),
                const Divider(height: 32),
                _buildRelatedSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_for_offline),
              label: const Text('DOWNLOAD ALL'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton.filledTonal(
            onPressed: () => _showInfoModal(context),
            icon: const Icon(Icons.info_outline),
            style: IconButton.styleFrom(padding: const EdgeInsets.all(15)),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Related Questions (Same Subject)', 
               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildRelatedCard('Winter 2023', 'Final'),
              _buildRelatedCard('Summer 2023', 'Final'),
              _buildRelatedCard('Winter 2022', 'Final'),
              _buildRelatedCard('Summer 2022', 'Final'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedCard(String session, String type) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: StudyHubCard(
        onTap: () {},
        padding: const EdgeInsets.all(12),
        color: Colors.indigo.withOpacity(0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(session, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Text(type, style: const TextStyle(fontSize: 10, color: Colors.blueGrey)),
          ],
        ),
      ),
    );
  }

  void _showQuickSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Quick Switch Question', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildQuickOption('CT 1'),
                  _buildQuickOption('CT 2'),
                  _buildQuickOption('Midterm'),
                  _buildQuickOption('Final'),
                  _buildQuickOption('Solve'),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickOption(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: false,
      onSelected: (_) => Navigator.pop(context),
      backgroundColor: Colors.grey[200],
    );
  }

  void _showInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Asset Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(height: 32),
              _buildInfoRow(Icons.calendar_today_outlined, 'Session', 'Winter 2024'),
              _buildInfoRow(Icons.person_outline, 'Uploaded By', 'Md. Waliur Rafiq Samir'),
              _buildInfoRow(Icons.check_circle_outline, 'Solve Status', 'Verified Solve Available', color: Colors.green),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Text('$label:', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color))),
        ],
      ),
    );
  }
}
