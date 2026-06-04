import 'package:flutter/material.dart';
import '../services/mongodb_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String _selectedDept = 'CSE';
  String _selectedLevel = '1';
  String _selectedTerm = 'I';
  String _selectedRole = 'Student';
  bool _isLoading = false;

  final List<String> _roles = ['Student', 'Teacher', 'CR', 'Admin'];

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      if (!MongoDBService.isConnected) await MongoDBService.connect();
      final collection = MongoDBService.getCollection("users");
      final email = _emailController.text.trim().toLowerCase();
      
      final existingUser = await collection.findOne({"email": email});
      if (existingUser != null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email already registered")));
        setState(() => _isLoading = false);
        return;
      }

      final Map<String, dynamic> userData = {
        "name": _nameController.text.trim(),
        "studentId": _idController.text.trim(),
        "department": _selectedDept,
        "level": _selectedLevel,
        "term": _selectedTerm,
        "role": _selectedRole,
        "email": email,
        "password": _passwordController.text,
        "isVerified": _selectedRole == 'Student', 
        "saved_resources": [],
        "joinedAt": DateTime.now().toIso8601String(),
      };

      await collection.insertOne(userData);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration Successful! Please Login.")));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'web/baust_logo.png',
                height: 80,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.school_rounded,
                  size: 60,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Join the BAUST Ecosystem',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Enter your details to get started with StudyHub.', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
              const SizedBox(height: 24),
              
              _buildRoleSelector(),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: _inputDecoration(context, 'Full Name', Icons.person_outline),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _idController,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: _inputDecoration(context, 'Student/Faculty ID', Icons.badge_outlined),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDropdown('Dept', _selectedDept, ['CSE', 'EEE', 'ME', 'CE', 'BBA', 'IPE', 'English', 'GED'], (v) => setState(() => _selectedDept = v!)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdown('Level', _selectedLevel, ['1', '2', '3', '4'], (v) => setState(() => _selectedLevel = v!)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdown('Term', _selectedTerm, ['I', 'II'], (v) => setState(() => _selectedTerm = v!)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: _inputDecoration(context, 'University Email', Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: _inputDecoration(context, 'Password', Icons.lock_outline),
                obscureText: true,
                validator: (v) => v!.length < 6 ? 'Min 6 chars' : null,
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Register Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _roles.map((role) {
        final isSelected = _selectedRole == role;
        return GestureDetector(
          onTap: () => setState(() => _selectedRole = role),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.2)),
                  boxShadow: isSelected ? [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.3), blurRadius: 8)] : [],
                ),
                child: Icon(
                  role == 'Student' ? Icons.person : (role == 'Teacher' ? Icons.school : (role == 'CR' ? Icons.groups : Icons.admin_panel_settings)),
                  color: isSelected ? Colors.white : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(role, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Theme.of(context).primaryColor : Colors.grey)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: Theme.of(context).cardColor,
      decoration: _inputDecoration(context, label, null),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
      onChanged: onChanged,
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String label, IconData? icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: Theme.of(context).primaryColor) : null,
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
    );
  }
}
