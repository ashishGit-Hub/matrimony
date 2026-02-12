import 'package:flutter/material.dart';
import 'package:matrimonial_app/features/register_module/model/registration_response.dart';
import 'package:matrimonial_app/models/user_model.dart';

import '../../../services/user_service.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // fetchUser();
  }

  // Future<void> fetchUser() async {
  //   final fetchedUser = await UserService.fetchUserDetails();
  //   setState(() {
  //     user = fetchedUser;
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Profile')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : user == null
          ? Center(child: Text('Failed to load user'))
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Name", user!.name),
            _buildLabel("Email", user!.email),
            _buildLabel("Mobile", user!.mobile),
            _buildLabel("DOB", user!.dob),
            _buildLabel("Age", user!.age),
            _buildLabel("Gender", user!.gender),
            _buildLabel("Height", user!.height),
            _buildLabel("Weight", user!.weight),
            _buildLabel("Profile For", user!.profileFor?.name),
            _buildLabel("Education", user!.education?.name),
            _buildLabel("Occupation", user!.occupation?.name),
            _buildLabel("Job Type", user!.jobType?.name),
            _buildLabel("Company Type", user!.companyType?.name),
            _buildLabel("Annual Income", user!.annualIncome?.range),
            _buildLabel("About", user!.myself),
            // Optionally show profile image
            if (user!.images != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'http://matrimony.sqcreation.site/${user!.images}',
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title: ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value?.toString() ?? '-',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
