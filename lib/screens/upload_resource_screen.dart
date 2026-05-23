import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';

class UploadResourceScreen extends StatefulWidget {
  const UploadResourceScreen({super.key});

  @override
  State<UploadResourceScreen> createState() => _UploadResourceScreenState();
}

class _UploadResourceScreenState extends State<UploadResourceScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedDept;
  String? selectedCategory; // Question, Note, Lab
  String? selectedType; // CT, Mid, Final
  
  final List<String> departments = ['CSE', 'EEE', 'ME', 'CE', 'BBA', 'IPE', 'English', 'GED'];
  final List<String> categories = ['Question', 'Note', 'Lab Material'];
  final List<String> types = ['CT 1', 'CT 2', 'CT 3', 'Midterm', 'Semester Final', 'Class Note', 'Lab Report'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Academic Asset'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoBanner(),
              const SizedBox(height: 32),
              
              _buildLabel('Resource Title'),
              TextFormField(
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: _inputDecoration('e.g. Operating Systems Final Solve', Icons.title),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: _buildDropdown('Department', departments, selectedDept, (v) => setState(() => selectedDept = v))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildDropdown('Category', categories, selectedCategory, (v) => setState(() => selectedCategory = v))),
                ],
              ),
              const SizedBox(height: 20),

              _buildDropdown('Resource Type', types, selectedType, (v) => setState(() => selectedType = v)),
              const SizedBox(height: 32),

              _buildLabel('Attach Document (PDF/Image)'),
              StudyHubCard(
                onTap: () {},
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.cloud_upload_outlined, size: 48, color: Theme.of(context).primaryColor.withOpacity(0.5)),
                      const SizedBox(height: 12),
                      Text('Tap to select file', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                      Text('Maximum size: 20MB', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _handleSubmission(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('SUBMIT FOR VERIFICATION', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.gpp_maybe_outlined, color: Colors.amber),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your submission will be hidden until verified by a CR or Faculty member.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: Theme.of(context).cardColor,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      decoration: _inputDecoration(label, null),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
      onChanged: onChanged,
    );
  }

  InputDecoration _inputDecoration(String hint, IconData? icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
      prefixIcon: icon != null ? Icon(icon, size: 20, color: Theme.of(context).primaryColor) : null,
      filled: true,
      fillColor: Theme.of(context).cardColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  void _handleSubmission() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          content: const Text(
            'Submission Successful!\n\nYour resource is now in the verification queue.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      ).then((_) => Navigator.pop(context));
    }
  }
}
