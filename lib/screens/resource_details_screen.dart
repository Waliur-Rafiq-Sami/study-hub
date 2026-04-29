import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';

class ResourceDetailsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resource View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Preview Area (Mock)
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.picture_as_pdf, size: 80, color: Colors.redAccent),
                    SizedBox(height: 16),
                    Text('PDF Preview Not Available', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
          
          // Action Panel
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(code, style: const TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showInfoModal(context),
                      icon: const Icon(Icons.info_outline, color: Color(0xFF1A237E)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download_rounded),
                        label: const Text('Download PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A237E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        side: const BorderSide(color: Color(0xFF1A237E)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Icon(Icons.share_outlined, color: Color(0xFF1A237E)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {},
                  child: const Text('View Linked Solutions', style: TextStyle(decoration: TextDecoration.underline)),
                ),
              ],
            ),
          ),
        ],
      ),
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
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Resource Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(height: 32),
              _buildInfoRow(Icons.calendar_today_outlined, 'Session', 'Winter 2024'),
              _buildInfoRow(Icons.layers_outlined, 'Level/Term', 'L-3, T-I'),
              _buildInfoRow(Icons.person_outline, 'Uploaded By', 'Md. Waliur Rafiq Samir'),
              _buildInfoRow(Icons.check_circle_outline, 'Solve Status', 'Verified Solve Available', color: Colors.green),
              _buildInfoRow(Icons.history, 'Published', '2 days ago'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                    elevation: 0,
                  ),
                  child: const Text('Close'),
                ),
              ),
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
