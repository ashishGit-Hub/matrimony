import 'package:flutter/material.dart';
import 'package:matrimonial_app/features/home_module/view/change_passwordscreen.dart';
import 'package:matrimonial_app/features/login_module/view/login_screen.dart';
import 'package:matrimonial_app/features/register_module/view/about_yourself_screen.dart';
import 'package:matrimonial_app/features/register_module/view/basic_detils_screen.dart';
import 'package:matrimonial_app/features/register_module/view/final_registration_screen.dart';
import 'package:matrimonial_app/features/register_module/view/personal_details.dart';
import 'package:matrimonial_app/features/register_module/view/proffesionaldetail_screen.dart';
import 'package:matrimonial_app/features/register_module/view/releigon_details.dart';
import 'package:matrimonial_app/utils/preferences.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
// import 'package:matrimonial_app/utils/preferences.dart';
// import 'package:matrimonial_app/features/login/view/login_screen.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getUserDetails(); // ✅ call properly
    });
  }
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            /// Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                      backgroundImage: user != null && user!.images != null && user!.images!.isNotEmpty
        ? NetworkImage(user!.images!)
              : AssetImage("assets/images/user.png") as ImageProvider,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Text(
                        user?.name?.isNotEmpty == true ? user!.name! : "Guest",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 2),

                        Text(
                          "Id = ${user?.dummyid?.toString() ?? 'N/A'}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        ],
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Handle Upgrade button
                  },
                  child: const Text(
                    'Upgrade',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),

            /// Settings Cards
            _buildSettingsCard(
              context,
              icon: Icons.person,
              title: 'Basic Details',
              screen: BasicDetailsScreen(isRegisteredScreen: false),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.self_improvement,
              title: 'Religion Details',
              screen: ReligionDetailsScreen(isRegisteredScreen: false),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.info,
              title: 'Personal Details',
              screen: PersonalScreen(isRegisteredScreen: false),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.work_outline,
              title: 'Professional Details',
              screen: ProfessionalDetailsScreen(isRegisteredScreen: false),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.edit_note,
              title: 'About Yourself',
              screen: AboutYourselfScreen(isRegistrationScreen: false),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.image,
              title: 'Gallery',
              screen: FinalStepScreen(isRegistrationScreen: false),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.password,
              title: 'Change Password',
              screen: ChangePasswordScreen(),
            ),

            _buildSettingsCard(
              context,
              icon: Icons.logout,
              title: 'Logout',
              screen: const SizedBox(), // We'll override tap behavior
              onTapOverride: () {
                _onItemTapped(9);
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                        TextButton(
                          onPressed: () async {
                            // Clear preferences
                            await Preferences.clearSharPreference();

                            // First, pop the dialog
                            Navigator.of(dialogContext).pop();

                            // Then navigate from the main context (not dialogContext!)
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                                  (route) => false,
                            );
                          },
                          child: const Text("Logout", style: TextStyle(color: Colors.red)),
                        ),

                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Widget screen,
        VoidCallback? onTapOverride,
      }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange), // 🔶 changed icon color to orange
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTapOverride ??
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => screen),
              );
            },
      ),
    );
  }
}
