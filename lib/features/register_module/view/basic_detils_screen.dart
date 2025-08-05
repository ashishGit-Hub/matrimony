import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrimonial_app/features/register_module/view/releigon_details.dart';
import 'package:matrimonial_app/features/register_module/view_model/basic_detail_service.dart';
import 'package:matrimonial_app/providers/user_provider.dart';
import 'package:matrimonial_app/utils/app_constants.dart';
import 'package:matrimonial_app/utils/preferences.dart';
import 'package:provider/provider.dart';

class BasicDetailsScreen extends StatefulWidget {
  final bool isRegisteredScreen;

  const BasicDetailsScreen({super.key, this.isRegisteredScreen = true});

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

  Future<void> fetchAndPrefill() async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    var user = await userProvider.getUserDetails();

    if (!widget.isRegisteredScreen && user != null) {
      setState(() {
        if (kDebugMode) {
          log("Check Page Parameters: ${widget.isRegisteredScreen.toString()}");
        }

        ageController.text = user.age;
        dobController.text = user.dob;
        emailController.text = user.email ?? "";
        final gender = user.gender?.toLowerCase() ?? '';
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

  Future<void> showSnackBar(String message, bool isError) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: isError ? Colors.white : Colors.black),
        ),
        backgroundColor: isError ? Colors.red : Colors.blueAccent,
      ),
    );
  }

  Future<void> navigate(Widget screen) async {
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return WillPopScope(
        onWillPop: () async {
          // Disable back button in registration screen
          return !widget.isRegisteredScreen;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            leading: widget.isRegisteredScreen ? null : BackButton(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text("Basic Details",
                style: TextStyle(color: Colors.black)),
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
                  decoration:
                  const InputDecoration(border: OutlineInputBorder()),
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      dobController.text =
                      "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                    }
                  },
                ),
                const SizedBox(height: 15),
                _buildTextField(
                    'Email ID:', emailController, TextInputType.emailAddress),
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
                  child: Text(
                      widget.isRegisteredScreen ? "Continue" : "Update",
                      style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
    });
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
            Text("Basic Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Next Step: Religion Details",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, TextInputType inputType) {
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
          backgroundColor:
          selectedGender == gender ? Colors.orange : Colors.white,
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
          content: Text('Please fill all the fields',
              style: TextStyle(color: Colors.white)),
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

        if (widget.isRegisteredScreen) {
          navigate(ReligionDetailsScreen());
        } else {
          showSnackBar(response.message, false);
        }
      } else {
        showSnackBar(response.message, true);
      }
    } catch (e) {
      Navigator.pop(context);
      showSnackBar('Submission failed: $e', true);
    }
  }
}
