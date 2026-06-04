import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import '../widgets/custom_card.dart';
import '../services/mongodb_service.dart';

class UploadResourceScreen extends StatefulWidget {
  const UploadResourceScreen({super.key});

  @override
  State<UploadResourceScreen> createState() => _UploadResourceScreenState();
}

class _UploadResourceScreenState extends State<UploadResourceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  
  String? selectedDept;
  String? selectedCategory; 
  String? selectedQType; 
  String? selectedSession;
  String? selectedLevel;
  String? selectedTerm;
  String? selectedBatch;
  
  List<XFile> _selectedImages = [];
  bool isUploading = false;
  
  final List<String> departments = ['CSE', 'EEE', 'ME', 'CE', 'BBA', 'IPE', 'English', 'GED'];
  final List<String> categories = ['Question', 'Note', 'Lab Material', 'Lab Quiz', 'Academic Tool'];
  final List<String> sessions = ['Summer', 'Winter'];
  final List<String> levels = ['1', '2', '3', '4'];
  final List<String> terms = ['I', 'II'];
  final List<String> batches = ['7th', '8th', '9th', '10th', '11th', '12th', '13th'];
  
  final List<String> qTypes = [
    'ct1', 'ct2', 'ct3', 'mid', 'labmid', 'remid', 
    'final', 'labfinal', 'retake', 'backlog', 
    'class-note', 'lab-report-demo', 'quiz-handout'
  ];

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 70,
        maxWidth: 1440,
      );
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gallery Error: $e"), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  Future<List<String>> _uploadImagesToCloudinary() async {
    List<String> urls = [];
    const String cloudName = "duuaa1qag";
    const String apiKey = "812622524613978";
    const String apiSecret = "5Kh3XbFsDmj-6BKv-xRidOXzZMk";
    
    for (var image in _selectedImages) {
      try {
        final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        final String stringToSign = "timestamp=$timestamp$apiSecret";
        final signature = sha1.convert(utf8.encode(stringToSign)).toString();

        var request = http.MultipartRequest(
          'POST', 
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload')
        );
        
        request.fields['api_key'] = apiKey;
        request.fields['timestamp'] = timestamp.toString();
        request.fields['signature'] = signature;
        request.files.add(await http.MultipartFile.fromPath('file', image.path));

        var response = await request.send();
        if (response.statusCode == 200 || response.statusCode == 201) {
          var responseData = await response.stream.bytesToString();
          var data = jsonDecode(responseData);
          urls.add(data['secure_url']);
        }
      } catch (e) {
        debugPrint("Cloudinary Upload Error: $e");
      }
    }
    return urls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Asset Contribution'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('IDENTIFICATION'),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _titleController,
                    decoration: _awesomeInput('Title (e.g. CSE-3101 Mid Exam)', Icons.title_rounded),
                    validator: (v) => v!.isEmpty ? 'Title is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _codeController,
                    decoration: _awesomeInput('Course Code (e.g. CSE-3101)', Icons.qr_code_2_rounded),
                    validator: (v) => v!.isEmpty ? 'Code is required' : null,
                  ),
                  
                  const SizedBox(height: 32),
                  _buildSectionHeader('ACADEMIC METADATA'),
                  const SizedBox(height: 12),
                  _buildMetadataGrid(),
                  
                  const SizedBox(height: 32),
                  _buildSectionHeader('SCANNED IMAGES'),
                  const SizedBox(height: 12),
                  _buildImagePickerZone(),
                  
                  const SizedBox(height: 48),
                  _buildAwesomeSubmitButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          if (isUploading) _buildProgressOverlay(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: Theme.of(context).primaryColor.withOpacity(0.7),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildMetadataGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _awesomeDropdown('Department', departments, selectedDept, (v) => setState(() => selectedDept = v))),
            const SizedBox(width: 12),
            Expanded(child: _awesomeDropdown('Category', categories, selectedCategory, (v) => setState(() => selectedCategory = v))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _awesomeDropdown('Session', sessions, selectedSession, (v) => setState(() => selectedSession = v))),
            const SizedBox(width: 12),
            Expanded(child: _awesomeDropdown('Type (qtype)', qTypes, selectedQType, (v) => setState(() => selectedQType = v))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _awesomeDropdown('L', levels, selectedLevel, (v) => setState(() => selectedLevel = v))),
            const SizedBox(width: 12),
            Expanded(child: _awesomeDropdown('T', terms, selectedTerm, (v) => setState(() => selectedTerm = v))),
            const SizedBox(width: 12),
            Expanded(child: _awesomeDropdown('Batch', batches, selectedBatch, (v) => setState(() => selectedBatch = v))),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePickerZone() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2), width: 2, style: BorderStyle.solid),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Column(
              children: [
                Icon(Icons.add_photo_alternate_rounded, size: 50, color: Theme.of(context).primaryColor),
                const SizedBox(height: 12),
                const Text('Choose Multiple Images', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('Select all pages of your paper', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
        ),
        if (_selectedImages.isNotEmpty) ...[
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(_selectedImages[index].path),
                          width: 100,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedImages.removeAt(index)),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                            child: const Icon(Icons.close, color: Colors.white, size: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAwesomeSubmitButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF3949AB)]),
        boxShadow: [BoxShadow(color: const Color(0xFF1A237E).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: ElevatedButton(
        onPressed: isUploading ? null : _handleSubmission,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: isUploading 
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('SYNC TO STUDYHUB CLOUD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2)),
      ),
    );
  }

  Widget _buildProgressOverlay() {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.amber, strokeWidth: 5),
            const SizedBox(height: 32),
            const Text('PUSHING DATA TO CLOUDINARY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1)),
            const SizedBox(height: 8),
            Text('Processing ${_selectedImages.length} images...', style: const TextStyle(color: Colors.white60)),
          ],
        ),
      ),
    );
  }

  Widget _awesomeDropdown(String hint, List<String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: Theme.of(context).cardColor,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
      decoration: _awesomeInput(hint, null),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? '*' : null,
    );
  }

  InputDecoration _awesomeInput(String hint, IconData? icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: Theme.of(context).primaryColor.withOpacity(0.6), size: 20) : null,
      filled: true,
      fillColor: Theme.of(context).cardColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
    );
  }

  Future<void> _handleSubmission() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select images first!")));
      return;
    }

    setState(() => isUploading = true);

    try {
      final List<String> imageUrls = await _uploadImagesToCloudinary();
      if (imageUrls.isEmpty) throw "Upload failed";

      final collection = MongoDBService.getCollection("resources");
      final Map<String, dynamic> data = {
        "title": _titleController.text.trim(),
        "code": _codeController.text.trim().toUpperCase(),
        "department": selectedDept,
        "category": selectedCategory,
        "type": selectedQType,
        "session": selectedSession,
        "level": selectedLevel,
        "term": selectedTerm,
        "batch": selectedBatch,
        "images": imageUrls,
        "status": "pending",
        "uploadedBy": MongoDBService.currentUser?['name'] ?? "Anonymous",
        "uploaderId": MongoDBService.currentUser?['studentId'] ?? "N/A",
        "timestamp": DateTime.now().toIso8601String(),
      };

      await collection.insertOne(data);

      if (mounted) _showAwesomeSuccess();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent));
    } finally {
      if (mounted) setState(() => isUploading = false);
    }
  }

  void _showAwesomeSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Icon(Icons.cloud_done_rounded, color: Colors.green, size: 70),
        content: const Text('PUBLISHED SUCCESSFULLY!\n\nYour resource is now live in the ecosystem.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to Home
            },
            child: const Text('GREAT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )
        ],
      ),
    );
  }
}
