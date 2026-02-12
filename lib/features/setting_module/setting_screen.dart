import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:matrimonial_app/features/home_module/view/change_passwordscreen.dart';
import 'package:matrimonial_app/features/login_module/view/login_screen.dart';
import 'package:matrimonial_app/features/register_module/model/registration_response.dart';
import 'package:matrimonial_app/features/register_module/view/about_yourself_screen.dart';
import 'package:matrimonial_app/features/register_module/view/basic_detils_screen.dart';
import 'package:matrimonial_app/features/register_module/view/final_registration_screen.dart';
import 'package:matrimonial_app/features/register_module/view/personal_details.dart';
import 'package:matrimonial_app/features/register_module/view/proffesionaldetail_screen.dart';
import 'package:matrimonial_app/features/register_module/view/releigon_details.dart';
import 'package:matrimonial_app/utils/preferences.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  int _selectedIndex = -1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)  {
       Provider.of<UserProvider>(context, listen: false).getUserDetails();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<UserProvider>(
        builder: (context, userProvider, child){
          log("Testing is continue ${userProvider.user}");
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: const Text('Settings'),
              backgroundColor: Colors.orange,
              centerTitle: true,
              elevation: 1,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // User Profile Card
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(18),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: (userProvider.user != null &&
                                  userProvider.user?.images != null &&
                                  userProvider.user?.images!.isNotEmpty == true)
                                  ? NetworkImage(userProvider.user!.images!)
                                  : const AssetImage("assets/images/user.png")
                              as ImageProvider,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userProvider.user?.name?.isNotEmpty == true
                                        ? userProvider.user!.name!
                                        : "Guest",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Id: ${userProvider.user?.dummyid?.toString() ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.star, size: 18, color: Colors.white),
                              onPressed: () {
                                // Handle Upgrade button
                              },
                              label: const Text(
                                'Upgrade',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Settings Sections
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionLabel('Profile'),
                        _buildSettingsCard(
                          context,
                          icon: Icons.self_improvement,
                          title: 'Basic Details',
                          screen: BasicDetailsScreen(isRegisteredScreen: false),
                        ),
                        _buildSettingsCard(
                          context,
                          icon: Icons.self_improvement,
                          title: 'Religion Details',
                          screen: ReligionDetailsScreen(isRegisteredScreen: false),
                        ),
                        _divider(),
                        _buildSettingsCard(
                          context,
                          icon: Icons.info,
                          title: 'Personal Details',
                          screen: PersonalScreen(isRegisteredScreen: false),
                        ),
                        _divider(),
                        _buildSettingsCard(
                          context,
                          icon: Icons.work_outline,
                          title: 'Professional Details',
                          screen: ProfessionalDetailsScreen(isRegisteredScreen: false),
                        ),
                        _divider(),
                        _buildSettingsCard(
                          context,
                          icon: Icons.edit_note,
                          title: 'About Yourself',
                          screen: AboutYourselfScreen(isRegistrationScreen: false),
                        ),
                        _divider(),
                        _buildSettingsCard(
                          context,
                          icon: Icons.image,
                          title: 'Gallery',
                          screen: FinalStepScreen(isRegistrationScreen: false),
                        ),
                        const SizedBox(height: 24),
                        _sectionLabel('Account'),
                        _buildSettingsCard(
                          context,
                          icon: Icons.password,
                          title: 'Change Password',
                          screen: ChangePasswordScreen(),
                        ),
                        _divider(),
                        const SizedBox(height: 24),
                        _sectionLabel('App'),
                        _buildSettingsCard(
                          context,
                          icon: Icons.logout,
                          title: 'Logout',
                          screen: const SizedBox(),
                          onTapOverride: () {
                            _onItemTapped(9);
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  title: const Text(
                                    "Logout",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  content: const Text(
                                      "Are you sure you want to logout?"),
                                  actions: [
                                    TextButton(
                                      child: const Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                      },
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await Preferences.clearSharPreference();
                                        Navigator.of(dialogContext).pop();
                                        Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (_) => LoginScreen()),
                                              (route) => false,
                                        );
                                      },
                                      child: const Text("Logout",
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

        });
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 18),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget _divider() => const Divider(
    color: Color(0xFFEEEEEE),
    thickness: 1.2,
    height: 0,
  );

  Widget _buildSettingsCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Widget screen,
        VoidCallback? onTapOverride,
      }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      leading: Icon(icon, color: Colors.orange, size: 28),
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
      onTap: onTapOverride ??
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => screen),
            );
          },
    );
  }
}