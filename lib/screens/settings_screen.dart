import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import 'login_screen.dart';
import '../services/theme_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account & Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 32),
            
            _buildSectionHeader('ACADEMIC CONFIGURATION'),
            _buildSettingsGroup([
              _buildSettingItem(Icons.school_outlined, 'Department', 'CSE', () => _showEditDialog('Department', 'Computer Science & Engineering')),
              _buildSettingItem(Icons.layers_outlined, 'Level & Term', 'L-3, T-I', () => _showEditDialog('Level & Term', 'L-3, T-I')),
              _buildSettingItem(Icons.group_outlined, 'My Batch', '8th Intake', () => _showEditDialog('Batch', '8th Intake')),
            ]),
            
            const SizedBox(height: 24),
            _buildSectionHeader('APP PREFERENCES'),
            _buildSettingsGroup([
              _buildSwitchItem(Icons.notifications_active_outlined, 'Notifications', isNotificationsEnabled, (v) => setState(() => isNotificationsEnabled = v)),
              _buildSwitchItem(
                Icons.dark_mode_outlined, 
                'Dark Theme', 
                themeManager.isDarkMode, 
                (v) => themeManager.toggleTheme(v)
              ),
              _buildSettingItem(Icons.language_outlined, 'App Language', 'English', () => _showActionFeedback('Language Selection Coming Soon')),
            ]),
            
            const SizedBox(height: 24),
            _buildSectionHeader('UPCOMING INNOVATIONS'),
            _buildComingSoonSection(),
            
            const SizedBox(height: 24),
            _buildSettingsGroup([
              _buildSettingItem(Icons.help_outline, 'Help & Support', null, () => _showActionFeedback('Support Portal Opening...')),
              _buildSettingItem(Icons.info_outline, 'About StudyHub', 'v1.0.0', () => _showAboutDialog()),
            ]),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                label: const Text('Log Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.redAccent.withOpacity(0.05),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF1A237E),
                child: Icon(Icons.person, color: Colors.white, size: 40),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showActionFeedback('Image Upload Coming Soon'),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt, color: Color(0xFF1A237E), size: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Waliur Rafiq Samir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                Text('ID: 0802410205101088', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 13)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: const Text('VERIFIED STUDENT', style: TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade300, letterSpacing: 1.2),
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String? value, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1A237E), size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null) Text(value, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300, size: 18),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(IconData icon, String title, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1A237E), size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF1A237E),
      ),
    );
  }

  Widget _buildComingSoonSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildComingSoonCard('GPA Calculator', Icons.calculate_outlined, 'Calculate SGPA/CGPA easily'),
          _buildComingSoonCard('Routine Sync', Icons.event_note_outlined, 'Get class reminders'),
          _buildComingSoonCard('Faculty Hub', Icons.people_outline, 'Direct appointment booking'),
        ],
      ),
    );
  }

  Widget _buildComingSoonCard(String title, IconData icon, String desc) {
    return GestureDetector(
      onTap: () => _showActionFeedback('$title will be available in the next update!'),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16, bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF1A237E).withOpacity(0.8), const Color(0xFF1A237E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: const Color(0xFF1A237E).withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.amber, size: 28),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text(desc, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
              child: const Text('COMING SOON', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showActionFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF1A237E),
      ),
    );
  }

  void _showEditDialog(String title, String current) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextFormField(initialValue: current, decoration: const InputDecoration(border: OutlineInputBorder())),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () {
            Navigator.pop(context);
            _showActionFeedback('$title updated (Static)');
          }, child: const Text('Save')),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'StudyHub BAUST',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.school, size: 40, color: Color(0xFF1A237E)),
      children: [const Text('StudyHub is a unified academic ecosystem designed specifically for BAUST students to manage notes, questions, and lab resources.')],
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out of StudyHub?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
