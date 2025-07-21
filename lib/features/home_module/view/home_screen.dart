import 'package:flutter/material.dart';
import 'package:matrimonial_app/core/constant/app_textstyle.dart';
import 'package:matrimonial_app/core/constant/color_constant.dart';
import 'package:matrimonial_app/features/chat_module/view/chat_screen.dart';
import 'package:matrimonial_app/features/home_module/view/change_passwordscreen.dart';
import 'package:matrimonial_app/features/match_module/view/match_screen.dart';
import 'package:matrimonial_app/features/profile_module/view/profile_screen.dart';
import 'package:matrimonial_app/features/register_module/view/basic_detils_screen.dart';
import 'package:matrimonial_app/features/setting_module/setting_screen.dart';

import '../../notification_module/view/notification_list_screen.dart';
import '../model/profile_drawer.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, this.username = "Teja"});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeContent(username: widget.username, scaffoldKey: _scaffoldKey),
      const MatchesScreen(),
      ChatScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: const ProfileDrawer(),
      backgroundColor: Colors.white,
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Matches"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String username;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeContent({
    super.key,
    required this.username,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- Header Row ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => scaffoldKey.currentState?.openDrawer(), // 👈 Opens drawer
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage("assets/images/user.png"),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Welcome,", style: TextStyle(fontSize: 14)),
                          Text(username,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationListScreen(), // Your notification screen
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      const Icon(
                        Icons.notifications,
                        size: 28,
                        color: Color(0xFFFE6D00), // or use your ColorConstant.notifyColor
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.green,
                          child: const Text(
                            "2",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),

            const SizedBox(height: 20),

            const TextField(
              decoration: InputDecoration(
                hintText: "Search by criteria",
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            /// --- Profile Progress Box ---
            Container(
              height: 150,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/images/user.png"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Oops! Your profile is inprogress.",
                            style: AppTextStyle.regularInterText(fontSize: 14)),
                        Text("Complete now to get more matches.",
                            style: AppTextStyle.regularInterText(fontSize: 14)),
                        const SizedBox(height: 10),
                        Stack(
                          children: [
                            Container(
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Container(
                              height: 12,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.topCenter,
                              child: const Text(
                                "40%",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text("Complete Now",
                            style: AppTextStyle.mediumInterText(
                              color: ColorConstant.nowColor,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// --- Status Grid ---
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 5,
              crossAxisSpacing: 10,
              childAspectRatio: 183 / 137,
              children: [
                statusCard("5", "Viewed You", ColorConstant.gridColorOne, 'assets/images/eye.png'),
                statusCard("5", "Sent Request", ColorConstant.gridColortwo, 'assets/images/tele.png'),
                statusCard("5", "Received Request", ColorConstant.gridColorthree, 'assets/images/message.png'),
                statusCard("5", "Request Accepted", ColorConstant.gridColorfour, 'assets/images/rename.png'),
              ],
            ),

            const SizedBox(height: 25),

            const Text("Recommended Matches",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text("Match cards go here"),
            ),
          ],
        ),
      ),
    );
  }

  Widget statusCard(String count, String label, Color color, String imagePath) {
    return Container(
      width: 180,
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  imagePath,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              count,
              style: AppTextStyle.regularInterText(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyle.regularInterText(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            right: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
