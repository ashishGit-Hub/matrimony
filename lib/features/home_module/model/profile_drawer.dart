import 'package:flutter/material.dart';
import 'package:matrimonal_app/features/home_module/view/change_passwordscreen.dart';
import 'package:matrimonal_app/features/home_module/view_model/logout_service.dart';
import 'package:matrimonal_app/features/login_module/view/login_screen.dart';
import 'package:matrimonal_app/features/profile_module/view/profile_screen.dart';
import 'package:matrimonal_app/features/register_module/view/basic_detils_screen.dart';
import 'package:matrimonal_app/services/sharepref.dart';

import '../view/user_detail_screen.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  int _selectedIndex = -1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        children: [
          const SizedBox(height: 50),
          const ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            title: Text('Nikhil Kumar', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('ID - TARR7333'),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {},
              child: const Text('Upgrade Membership', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 8),
          const Text('UPTO 75% OFF ALL MEMBERSHIP PLANS'),
          const Divider(height: 30),
          Expanded(
            child: ListView(
              children: [
                DrawerItem(
                  index: 0,
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                  title: 'Edit Profile',
                  icon: Icons.edit,
                  destination: ViewProfileScreen(),
                ),
                DrawerItem(
                  index: 1,
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                  title: 'Partner Preferences',
                  icon: Icons.people,
                  destination: const DummyScreen(title: 'Partner Preferences'),
                ),
                DrawerItem(
                  index: 2,
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                  title: 'Spotlight',
                  icon: Icons.star,
                  destination: const DummyScreen(title: 'Spotlight'),
                ),
                DrawerItem(
                  index: 3,
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                  title: 'Search by Keyword',
                  icon: Icons.search,
                  destination: const DummyScreen(title: 'Search by Keyword'),
                ),
                DrawerItem(
                  index: 4,
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                  title: 'Kundli Matches',
                  icon: Icons.grid_on,
                  destination: const DummyScreen(title: 'Kundli Matches'),
                ),
                DrawerItem(
                  index: 5,
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                  title: 'Astrology Services',
                  icon: Icons.brightness_4,
                  destination: const DummyScreen(title: 'Astrology Services'),
                ),
                DrawerItem(
                  index: 6,
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                  title: 'Account & Settings',
                  icon: Icons.settings,
                  destination: const ChangePasswordScreen(),
                ),
                DrawerItem(
                  index: 7,
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                  title: 'Safety Center',
                  icon: Icons.security,
                  destination: const DummyScreen(title: 'Safety Center'),
                ),

                ListTile(
                  selected: _selectedIndex == 9,
                  selectedTileColor: Colors.grey[200],
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 9;
                    });
                    Navigator.pop(context); // Close drawer

                    // Use addPostFrameCallback to delay dialog until drawer closes
                    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                                child: const Text("Logout", style: TextStyle(color: Colors.red)),
                                onPressed: () async {
                                  Navigator.of(dialogContext).pop(); // Close dialog

                                  final result = await LogoutService.logoutUser();

                                  // Delay slightly to ensure dialog is fully closed
                                  await Future.delayed(const Duration(milliseconds: 200));

                                  if (!mounted) return;

                                  if (result['status']) {
                                    await SharedPrefs.clearToken();

                                    // ✅ Do navigation safely
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (_) =>  LoginScreen()),
                                          (route) => false,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(result['message'])),
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    });
                  },
                ),



              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final String title;
  final IconData icon;
  final Widget destination;

  const DrawerItem({
    required this.index,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.title,
    required this.icon,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selectedIndex == index,
      selectedTileColor: Colors.grey[200],
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        onItemTapped(index);
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => destination),
          );
        });
      },
    );
  }
}

class DummyScreen extends StatelessWidget {
  final String title;

  const DummyScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title Screen')),
    );
  }
}
