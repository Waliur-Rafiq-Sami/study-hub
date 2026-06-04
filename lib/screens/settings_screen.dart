import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'login_screen.dart';
import 'admin_panel_screen.dart';
import '../services/mongodb_service.dart';
import '../widgets/custom_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isSaving = false;
  late TextEditingController _nameController;
  late String _dept, _level, _term;

  @override
  void initState() {
    super.initState();
    final u = MongoDBService.currentUser;
    _nameController = TextEditingController(text: u?['name']);
    _dept = u?['department'] ?? 'CSE';
    _level = u?['level'] ?? '3';
    _term = u?['term'] ?? 'I';
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final col = MongoDBService.getCollection("users");
      final id = mongo.ObjectId.fromHexString(MongoDBService.currentUser!['_id']);
      await col.updateOne(mongo.where.id(id), mongo.modify.set('name', _nameController.text).set('department', _dept).set('level', _level).set('term', _term));
      final updated = await col.findOne(mongo.where.id(id));
      if (updated != null) await MongoDBService.saveSession(updated);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated!"), behavior: SnackBarBehavior.floating));
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"))); }
    finally { if (mounted) setState(() => _isSaving = false); }
  }

  @override
  Widget build(BuildContext context) {
    final u = MongoDBService.currentUser;
    final role = u?['role'] ?? 'Student';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _save,
            icon: _isSaving 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.done_all_rounded, color: Colors.white),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildProfileCard(u, role),
          const SizedBox(height: 32),
          _sectionLabel('EDITABLE INFORMATION'),
          const SizedBox(height: 12),
          StudyHubCard(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                _editField('Full Name', Icons.person_outline_rounded, _nameController),
                _dropdownField('Department', Icons.school_outlined, _dept, ['CSE', 'EEE', 'ME', 'CE', 'BBA'], (v) => setState(() => _dept = v!)),
                Row(
                  children: [
                    Expanded(child: _dropdownField('Level', Icons.layers_outlined, _level, ['1', '2', '3', '4'], (v) => setState(() => _level = v!))),
                    Expanded(child: _dropdownField('Term', Icons.calendar_view_day_outlined, _term, ['I', 'II'], (v) => setState(() => _term = v!))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _sectionLabel('ACCOUNT SECURITY'),
          const SizedBox(height: 12),
          StudyHubCard(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                _infoTile('Student ID', u?['studentId'] ?? 'N/A', Icons.badge_outlined),
                _infoTile('Access Role', role, Icons.security_rounded),
                if (role == 'Admin')
                  ListTile(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPanelScreen())),
                    leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.amber, size: 20)),
                    title: const Text('Admin Console', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _buildLogoutBtn(),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic>? u, String role) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          const CircleAvatar(radius: 45, backgroundColor: Color(0xFF1A237E), child: Icon(Icons.person, color: Colors.white, size: 45)),
          const SizedBox(height: 16),
          Text(u?['name'] ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
          Text(u?['email'] ?? 'N/A', style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _stat('Saves', '${u?['saved_resources']?.length ?? 0}'),
              _divider(),
              _stat('Contributions', '12'),
              _divider(),
              _stat('Rank', '#4'),
            ],
          )
        ],
      ),
    );
  }

  Widget _stat(String l, String v) => Column(children: [Text(v, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)), Text(l, style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5))]);
  Widget _divider() => Container(width: 1, height: 30, color: Colors.grey.withOpacity(0.1));

  Widget _sectionLabel(String t) => Padding(padding: const EdgeInsets.only(left: 4), child: Text(t, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Theme.of(context).primaryColor.withOpacity(0.6), letterSpacing: 1.5)));

  Widget _editField(String l, IconData i, TextEditingController c) => ListTile(leading: Icon(i, size: 20, color: Theme.of(context).primaryColor.withOpacity(0.7)), title: TextFormField(controller: c, decoration: InputDecoration(labelText: l, labelStyle: const TextStyle(fontSize: 12), border: InputBorder.none)));

  Widget _dropdownField(String l, IconData i, String v, List<String> items, Function(String?) onC) => ListTile(leading: Icon(i, size: 20, color: Theme.of(context).primaryColor.withOpacity(0.7)), title: Text(l, style: const TextStyle(fontSize: 12, color: Colors.grey)), subtitle: DropdownButtonHideUnderline(child: DropdownButton<String>(value: v, isExpanded: true, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: onC)));

  Widget _infoTile(String l, String v, IconData i) => ListTile(leading: Icon(i, size: 20, color: Theme.of(context).primaryColor.withOpacity(0.7)), title: Text(l, style: const TextStyle(fontSize: 12, color: Colors.grey)), subtitle: Text(v, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)));

  Widget _buildLogoutBtn() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.redAccent.withOpacity(0.2))),
      child: TextButton.icon(
        onPressed: () async { await MongoDBService.clearSession(); if (mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false); },
        icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
        label: const Text('Log Out Account', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900)),
        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
      ),
    );
  }
}
