import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import '../widgets/custom_card.dart';
import '../services/mongodb_service.dart';

class UploadSolutionScreen extends StatefulWidget {
  final String resourceId;
  final String resourceCode;

  const UploadSolutionScreen({
    super.key,
    required this.resourceId,
    required this.resourceCode,
  });

  @override
  State<UploadSolutionScreen> createState() => _UploadSolutionScreenState();
}

class _UploadSolutionScreenState extends State<UploadSolutionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  
  List<XFile> _selectedImages = [];
  bool isUploading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _commentController.dispose();
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

  Future<List<String>> _uploadToCloudinary() async {
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
        debugPrint("Cloudinary Error: $e");
      }
    }
    return urls;
  }

  Future<void> _submit() async {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select images of your solution")));
      return;
    }

    setState(() => isUploading = true);

    try {
      final List<String> urls = await _uploadToCloudinary();
      if (urls.isEmpty) throw "Image upload failed";

      final collection = MongoDBService.getCollection("solutions");
      await collection.insertOne({
        "resourceId": widget.resourceId,
        "resourceCode": widget.resourceCode,
        "comment": _commentController.text.trim(),
        "images": urls,
        "uploadedBy": MongoDBService.currentUser?['name'] ?? "Anonymous",
        "uploaderId": MongoDBService.currentUser?['studentId'] ?? "N/A",
        "timestamp": DateTime.now().toIso8601String(),
        "status": "pending"
      });

      if (mounted) {
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
            content: const Text('Solution Uploaded!\n\nIt will be visible once verified.', textAlign: TextAlign.center),
            actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context, true); }, child: const Text('OK'))],
          ),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contribute Solution'), centerTitle: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Uploading solution for ${widget.resourceCode}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 24),
                  
                  const Text('Optional Comment', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'e.g. Handwritten steps for Q3 and Q5...',
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  const Text('Scanned Solution Pages', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 12),
                  _buildPicker(),
                  
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isUploading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: isUploading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('SUBMIT SOLUTION', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUploading)
            Container(color: Colors.black54, child: const Center(child: CircularProgressIndicator(color: Colors.amber))),
        ],
      ),
    );
  }

  Widget _buildPicker() {
    return Column(
      children: [
        StudyHubCard(
          onTap: _pickImages,
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.add_a_photo_rounded, size: 40, color: Theme.of(context).primaryColor),
                const SizedBox(height: 12),
                const Text('Select Multiple Images', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        if (_selectedImages.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(File(_selectedImages[index].path), width: 100, height: 100, fit: BoxFit.cover),
                      ),
                      Positioned(
                        right: 4, top: 4,
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedImages.removeAt(index)),
                          child: Container(decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: const Icon(Icons.close, color: Colors.white, size: 16)),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ]
      ],
    );
  }
}
