import 'package:flutter/material.dart';
import 'package:matrimonial_app/features/home_module/view/change_passwordscreen.dart';
import 'package:matrimonial_app/features/home_module/view_model/logout_service.dart';
import 'package:matrimonial_app/features/login_module/view/login_screen.dart';
import 'package:matrimonial_app/utils/preferences.dart';
import '../../match_module/view/receive_request.dart';
import '../../match_module/view/send_request_page.dart';
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 30, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Nikhil Kumar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'ID - TARR7333',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
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
                  // Handle Upgrade button press
                },
                child: const Text(
                  'Upgrade',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),
              SizedBox(width: 10,)
            ],
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
                  title: 'Send Matches',
                  icon: Icons.people,
                  destination:const  SendMatchesPage(),
                ),

                DrawerItem(
                  index: 2,
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                  title: 'Receive Request',
                  icon: Icons.people,
                  destination: const ReceiveMatchesPage(),
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
                                onPressed: () {
                                  Preferences.clearSharPreference();
                                  Navigator.of(dialogContext).pushAndRemoveUntil(
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
