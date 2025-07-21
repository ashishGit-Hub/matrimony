import 'package:flutter/material.dart';
import 'package:matrimonial_app/features/register_module/view/about_yourself_screen.dart';
import 'package:matrimonial_app/features/register_module/view/basic_detils_screen.dart';
import 'package:matrimonial_app/features/register_module/view/personal_details.dart';
import 'package:matrimonial_app/features/register_module/view/proffesionaldetail_screen.dart';
import 'package:matrimonial_app/features/register_module/view/releigon_details.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              screen: ReligionDetailsScreen(),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.info,
              title: 'Personal Details',
              screen: PersonalScreen(),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.work_outline,
              title: 'Professional Details',
              screen: ProfessionalDetailsScreen(),
            ),
            _buildSettingsCard(
              context,
              icon: Icons.edit_note,
              title: 'About Yourself',
              screen: AboutYourselfScreen(),
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
      }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
      ),
    );
  }
}
