import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrimonal_app/features/register_module/view_model/about_service.dart';
import 'package:matrimonal_app/features/register_module/view_model/user_service.dart';
import 'package:matrimonal_app/utils/sharepref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'final_registration_screen.dart';

class AboutYourselfScreen extends StatefulWidget {
  @override
  State<AboutYourselfScreen> createState() => _AboutYourselfScreenState();
}

class _AboutYourselfScreenState extends State<AboutYourselfScreen> {
  final TextEditingController aboutController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  String? existingImageUrl;
  bool isSubmitting = false, isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final prefs = await SharedPreferences.getInstance();
    final user = await UserService.fetchUserDetails();

    final savedAbout = prefs.getString('about') ?? user?.myself ?? '';
    final savedImagePath = prefs.getString('imagePath');

    setState(() {
      aboutController.text = savedAbout;
      if (savedImagePath != null && File(savedImagePath).existsSync()) {
        _selectedImage = XFile(savedImagePath);
      } else if (user?.images != null && user!.images.toString().isNotEmpty) {
        existingImageUrl = 'https://matrimony.sqcreation.site/${user.images}';
      }
      isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('imagePath', picked.path);
      setState(() {
        _selectedImage = picked;
        existingImageUrl = null;
      });
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _completeRegistration() async {
    final aboutText = aboutController.text.trim();

    if (aboutText.isEmpty) {
      _showSnackBar("Please write something about yourself.");
      return;
    }

    if (_selectedImage == null && existingImageUrl == null) {
      _showSnackBar("Please select an image.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('about', aboutText);

    setState(() => isSubmitting = true);

    bool success = true;

    if (_selectedImage != null) {
      success = await AboutService.updateAbout(
        myself: aboutText,
        imageFile: File(_selectedImage!.path),
      );
    } else {
      success = await AboutService.updateAbout(myself: aboutText);
    }

    setState(() => isSubmitting = false);

    if (success) {
      // ✅ Navigate to next screen without dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => FinalStepScreen()),
      );
    } else {
      _showSnackBar("Failed to submit details. Try again.");
    }
  }

  Widget _buildProgressHeader() {
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 4,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation(Colors.green),
              ),
            ),
            Text("5 of 5", style: TextStyle(fontSize: 12)),
          ],
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("About Yourself", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Prev. Step: Professional Details", style: TextStyle(color: Colors.green, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        scrolledUnderElevation: 0,
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("About Yourself", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressHeader(),
              SizedBox(height: 30),
              Text("Please provide about yourself:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextField(
                controller: aboutController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Write something about yourself...",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 25),
              Text("Upload Profile", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (_selectedImage != null)
                Image.file(File(_selectedImage!.path), width: 80, height: 80, fit: BoxFit.cover)
              else if (existingImageUrl != null)
                Image.network(existingImageUrl!, width: 80, height: 80, fit: BoxFit.cover),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: isSubmitting ? null : _completeRegistration,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: isSubmitting
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Continue", style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
