import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import 'resource_details_screen.dart';

class ResourceListScreen extends StatefulWidget {
  final String department;
  final String category; // 'CT', 'Midterm', 'Final', 'Lab', 'Note'

  const ResourceListScreen({
    super.key,
    required this.department,
    required this.category,
  });

  @override
  State<ResourceListScreen> createState() => _ResourceListScreenState();
}

class _ResourceListScreenState extends State<ResourceListScreen> {
  String selectedType = 'All'; // e.g., 'CT 1', 'CT 2', 'CT 3'
  String selectedBatch = 'All';
  String selectedLevelTerm = 'L-3, T-I';

  @override
  Widget build(BuildContext context) {
    List<String> subTypes = [];
    if (widget.category == 'CT') {
      subTypes = ['All', 'CT 1', 'CT 2', 'CT 3'];
    } else if (widget.category == 'Lab') {
      subTypes = ['All', 'Manual', 'Report Demo', 'Solution'];
    } else {
      subTypes = ['All', 'Regular', 'Backlog'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.department} ${widget.category}s'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterHeader(subTypes),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10, // Mock count
              itemBuilder: (context, index) {
                return _buildResourceCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterHeader(List<String> subTypes) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: subTypes.map((type) {
                final isSelected = selectedType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (val) => setState(() => selectedType = type),
                    selectedColor: Colors.amber,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: Theme.of(context).cardColor,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildSmallFilter('Batch', ['All', '8th', '9th', '10th']),
                const SizedBox(width: 8),
                _buildSmallFilter('L-T', ['L-1, T-I', 'L-2, T-II', 'L-3, T-I']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallFilter(String hint, List<String> items) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: items[0],
            isExpanded: true,
            dropdownColor: Theme.of(context).cardColor,
            icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).primaryColor),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
        ),
      ),
    );
  }

  Widget _buildResourceCard(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: StudyHubCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResourceDetailsScreen(
                title: 'Operating Systems ${widget.category}',
                code: 'CSE-3101',
                category: widget.category,
              ),
            ),
          );
        },
        child: Row(
          children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.category == 'Lab' ? Icons.terminal : Icons.description_outlined,
              color: Theme.of(context).primaryColor,
            ),
          ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.category} Question - Set A',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Batch: 8th | L-3, T-I | Winter 2024',
                    style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
