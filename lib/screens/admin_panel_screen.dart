import 'package:flutter/material.dart';
import '../services/mongodb_service.dart';
import '../widgets/custom_card.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'dart:developer';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<Map<String, dynamic>> _pendingStaff = [];
  List<Map<String, dynamic>> _allMembers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final collection = MongoDBService.getCollection("users");
      
      final pending = await collection.find(mongo.where.eq('isVerified', false).ne('role', 'Student')).toList();
      final all = await collection.find().toList();

      if (mounted) {
        setState(() {
          _pendingStaff = pending.map((u) => MongoDBService.sanitize(u)).toList();
          _allMembers = all.map((u) => MongoDBService.sanitize(u)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      log("Fetch Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _action(String id, bool verify) async {
    try {
      final collection = MongoDBService.getCollection("users");
      if (verify) {
        await collection.updateOne(mongo.where.id(mongo.ObjectId.fromHexString(id)), mongo.modify.set('isVerified', true));
      } else {
        await collection.remove(mongo.where.id(mongo.ObjectId.fromHexString(id)));
      }
      _fetchData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(verify ? "Account Verified" : "Account Rejected/Removed")),
        );
      }
    } catch (e) {
      log("Action Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Console'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          tabs: const [Tab(text: 'PENDING STAFF'), Tab(text: 'ALL MEMBERS')],
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : TabBarView(
            controller: _tabController,
            children: [_buildPendingList(), _buildAllList()],
          ),
    );
  }

  Widget _buildPendingList() {
    if (_pendingStaff.isEmpty) return const Center(child: Text("No staff awaiting verification"));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pendingStaff.length,
      itemBuilder: (context, index) {
        final user = _pendingStaff[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: StudyHubCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(user['name'] ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    _badge(user['role'], Colors.orange),
                  ],
                ),
                const SizedBox(height: 4),
                Text("ID: ${user['studentId']}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text("Email: ${user['email']}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text("Dept: ${user['department']} | L-${user['level']} T-${user['term']}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const Divider(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _action(user['_id'], true), 
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white), 
                        child: const Text('VERIFY', style: TextStyle(fontWeight: FontWeight.bold))
                      )
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _action(user['_id'], false), 
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)), 
                        child: const Text('REJECT')
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAllList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _allMembers.length,
      itemBuilder: (context, index) {
        final user = _allMembers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: StudyHubCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Icon(_getIcon(user['role']), color: Theme.of(context).primaryColor),
              ),
              title: Text(user['name'] ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${user['role']} • ${user['department']} • L-${user['level']}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent), 
                onPressed: () => _showDeleteDialog(user['_id'], user['name'])
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(String id, String? name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove Member"),
        content: Text("Are you sure you want to remove $name? This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              _action(id, false);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  Widget _badge(String? label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), 
      child: Text(label ?? '', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold))
    );
  }

  IconData _getIcon(String? role) {
    if (role == 'Teacher') return Icons.school;
    if (role == 'Admin') return Icons.admin_panel_settings;
    if (role == 'CR') return Icons.groups;
    return Icons.person;
  }
}
