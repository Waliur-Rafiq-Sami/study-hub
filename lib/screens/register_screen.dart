import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedDept = 'CSE';
  String _selectedLevel = '1';
  String _selectedTerm = 'I';

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
                height: 100,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.school_rounded,
                  size: 60,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Join the BAUST Ecosystem',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 8),
              Text('Enter your details to get started with StudyHub.', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
              const SizedBox(height: 32),
              
              TextFormField(
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: _inputDecoration(context, 'Full Name', Icons.person_outline),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: _inputDecoration(context, 'Student ID', Icons.badge_outlined, hint: 'e.g. 0802410...'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _selectedDept,
                      dropdownColor: Theme.of(context).cardColor,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      decoration: _inputDecoration(context, 'Dept', null),
                      items: ['CSE', 'EEE', 'ME', 'CE', 'BBA'].map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                      onChanged: (v) => setState(() => _selectedDept = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedLevel,
                      dropdownColor: Theme.of(context).cardColor,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      decoration: _inputDecoration(context, 'L', null),
                      items: ['1', '2', '3', '4'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                      onChanged: (v) => setState(() => _selectedLevel = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedTerm,
                      dropdownColor: Theme.of(context).cardColor,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      decoration: _inputDecoration(context, 'T', null),
                      items: ['I', 'II'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (v) => setState(() => _selectedTerm = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: _inputDecoration(context, 'University Email', Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              TextFormField(
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: _inputDecoration(context, 'Password', Icons.lock_outline),
                obscureText: true,
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Register Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String label, IconData? icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
      hintText: hint,
      hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
      prefixIcon: icon != null ? Icon(icon, color: Theme.of(context).primaryColor) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
    );
  }
}
