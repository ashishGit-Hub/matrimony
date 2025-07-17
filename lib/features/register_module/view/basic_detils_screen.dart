import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrimonial_app/utils/app_constants.dart';
import 'package:matrimonial_app/utils/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matrimonial_app/features/home_module/view/home_screen.dart';
import 'package:matrimonial_app/features/register_module/view/releigon_details.dart';
import 'package:matrimonial_app/features/register_module/view_model/basic_detail_service.dart';

class BasicDetailsScreen extends StatefulWidget {
  var isRegisteredScreen = true;
  BasicDetailsScreen({super.key,  required this.isRegisteredScreen});

  @override
  State<BasicDetailsScreen> createState() => _BasicDetailsScreenState();
}

class _BasicDetailsScreenState extends State<BasicDetailsScreen> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String selectedGender = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAndPrefill();
  }


  // Future<void> fetchProfileDetails() async {
  //   final token = await SharedPrefs.getToken();
  //
  //   final result = await MatchService.getProfileDetails(widget.userId, token!);
  //   if (result != null) {
  //     setState(() {
  //       profile = result;
  //       isLoading = false;
  //     });
  //   } else {
  //     setState(() => isLoading = false);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Failed to load profile")),
  //     );
  //   }
  // }

  Future<void> fetchAndPrefill() async {
    final prefs = await SharedPreferences.getInstance();
    final isRegistered = prefs.getBool('isRegistered') ?? false;

    if (!widget.isRegisteredScreen) {
      setState(() {
        ageController.text = prefs.getString('age') ?? '';
        dobController.text = prefs.getString('dob') ?? '';
        emailController.text = prefs.getString('email') ?? '';
        final gender = prefs.getString('gender')?.toLowerCase() ?? '';
        selectedGender = gender == 'male'
            ? 'Male'
            : gender == 'female'
            ? 'Female'
            : gender == 'others'
            ? 'Others'
            : '';
        isLoading = false;
      });
    } else {
      setState(() {
        ageController.clear();
        dobController.clear();
        emailController.clear();
        selectedGender = '';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Basic Details", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressHeader(),
            const SizedBox(height: 30),
            const Text("Please provide your basic details:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildTextField('Age:', ageController, TextInputType.number),
            const SizedBox(height: 15),
            const Text('Date of Birth:'),
            const SizedBox(height: 10),
            TextField(
              controller: dobController,
              readOnly: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onTap: () async {
                FocusScope.of(context).unfocus();
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  dobController.text = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                }
              },
            ),
            const SizedBox(height: 15),
            _buildTextField('Email ID:', emailController, TextInputType.emailAddress),
            const SizedBox(height: 15),
            const Text("Gender:"),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildGenderButton("Male"),
                const SizedBox(width: 10),
                _buildGenderButton("Female"),
                const SizedBox(width: 10),
                _buildGenderButton("Others"),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Continue", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
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
                value: 0.2,
                strokeWidth: 4,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation(Colors.green),
              ),
            ),
            const Text("1 of 5", style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Basic Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Next Step: Religion Details", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType inputType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: inputType,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget _buildGenderButton(String gender) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            selectedGender = gender;
          });
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: selectedGender == gender ? Colors.orange : Colors.white,
        ),
        child: Text(gender, style: const TextStyle(color: Colors.black)),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final age = ageController.text.trim();
    final dob = dobController.text.trim();
    final email = emailController.text.trim();
    final gender = selectedGender.toLowerCase();

    if (age.isEmpty || dob.isEmpty || email.isEmpty || gender.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await BasicDetailService().submitBasicDetails(
        age: age,
        dob: dob,
        email: email,
        gender: gender,
      );

      Navigator.pop(context); // Close loader

      if (response.status) {
        Preferences.setString('age', age);
        Preferences.setString('dob', dob);
        Preferences.setString('email', email);
        Preferences.setString('gender', gender);

        Preferences.setString(AppConstants.registrationStep, "Third");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ReligionDetailsScreen()),
        );
      } else {
        String message = response.message;
        // if (response.errors != null && response.errors!.containsKey('email')) {
        //   message = response.errors!['email'][0];
        // }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submission failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
