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
      appBar: AppBar(
        title: Text(widget.code),
        actions: [
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border, 
                 color: isBookmarked ? Colors.amber : Theme.of(context).appBarTheme.foregroundColor),
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
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.description, size: 100, color: Theme.of(context).primaryColor),
                            const SizedBox(height: 16),
                            Text(
                              'Page ${index + 1} of $totalPages', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              'Scan of Academic Question Paper', 
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
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
                      color: Theme.of(context).primaryColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Page $currentPage / $totalPages', 
                         style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Controls & Suggestions
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButtons(),
                Divider(height: 32, color: Theme.of(context).dividerColor.withOpacity(0.1)),
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
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton.filledTonal(
            onPressed: () => _showInfoModal(context),
            icon: const Icon(Icons.info_outline),
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(15),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              foregroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Related Questions (Same Subject)', 
               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
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
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(session, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
            Text(type, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
          ],
        ),
      ),
    );
  }

  void _showQuickSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Quick Switch Question', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
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
      backgroundColor: Theme.of(context).cardColor,
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    );
  }

  void _showInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  decoration: BoxDecoration(color: Theme.of(context).dividerColor, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 24),
              Text('Asset Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              Divider(height: 32, color: Theme.of(context).dividerColor.withOpacity(0.1)),
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
