import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:matrimonal_app/utils/sharepref.dart';
import '../../home_module/view/home_screen.dart';

class FinalStepScreen extends StatefulWidget {
  const FinalStepScreen({super.key});

  @override
  State<FinalStepScreen> createState() => _FinalStepScreenState();
}

class _FinalStepScreenState extends State<FinalStepScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];
  bool _isUploading = false;

  Future<void> _pickImages() async {
    final List<XFile>? selected = await _picker.pickMultiImage();
    if (selected != null && selected.isNotEmpty) {
      setState(() => _images.addAll(selected));
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _uploadImages() async {
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one image")),
      );
      return;
    }

    final token = await SharedPrefs.getToken();
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Token missing. Please login again.")),
      );
      return;
    }

    setState(() => _isUploading = true);

    var uri = Uri.parse("https://matrimony.sqcreation.site/api/update-gallery");
    var request = http.MultipartRequest("POST", uri);

    print("📤 Uploading to: ${uri.toString()}");

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    for (var image in _images) {
      request.files.add(await http.MultipartFile.fromPath('gallery[]', image.path));
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      setState(() => _isUploading = false);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("✅ Upload Status: ${jsonResponse['status']}");
        print("✅ Message: ${jsonResponse['message']}");

        if (jsonResponse['status'] == true) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Profile Completed"),
                content: const Text("Your profile has been successfully completed."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                    child: const Text("Go to Home"),
                  ),
                ],
              ),
            );
          }
        } else {
          _showError("Upload failed. Try again.");
        }
      } else {
        _showError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _isUploading = false);
      _showError("Error uploading images: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Final Step"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: ElevatedButton.icon(
                onPressed: _isUploading ? null : _pickImages,
                icon: const Icon(Icons.add_a_photo),
                label: const Text("Add Images"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _images.isEmpty
                ? const Text("No images selected yet.")
                : Expanded(
              child: GridView.builder(
                itemCount: _images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_images[index].path),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black54,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.close, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _uploadImages,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Upload & Finish"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
