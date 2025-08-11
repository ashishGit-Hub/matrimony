import 'package:flutter/material.dart';
import 'package:matrimonial_app/core/constant/app_textstyle.dart';
import 'package:matrimonial_app/core/constant/color_constant.dart';
import 'package:matrimonial_app/features/chat_module/view/chat_screen.dart';
import 'package:matrimonial_app/features/home_module/view/search_screen.dart';
import 'package:matrimonial_app/features/match_module/view/match_screen.dart';
import 'package:matrimonial_app/features/register_module/view/basic_detils_screen.dart';
import 'package:matrimonial_app/features/setting_module/setting_screen.dart';
import 'package:matrimonial_app/providers/home_provider.dart';
import 'package:matrimonial_app/providers/user_provider.dart';
import 'package:matrimonial_app/utils/app_constants.dart';
import 'package:provider/provider.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getUserDetails(); // ✅ call properly
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeContent(),
      const MatchesScreen(),
      ChatScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: const ProfileDrawer(),
      backgroundColor: Colors.grey[100],
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home", backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Matches", backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat", backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting", backgroundColor: Colors.white),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<HomeProvider>(context, listen: false).getHome();
    });
  }


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    return Consumer<HomeProvider>(builder: (context, homeProvider, child){
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
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: user != null && user.images != null && user.images!.isNotEmpty
                              ? NetworkImage('${AppConstants.baseUrl}/${user.images!}')
                              : AssetImage("assets/images/user.png") as ImageProvider,

                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Welcome,", style: TextStyle(fontSize: 14)),
                            Text(
                              user?.name?.isNotEmpty == true ? user!.name! : "Guest",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// ✅ Fixed Icon Row
                  Row(
                    children: [
                      /// 🔍 Search icon
                      IconButton(
                        icon: const Icon(Icons.search, size: 28, color: Colors.black87),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SearchScreen()),
                          );
                        },
                      ),

                      /// 🔔 Notification icon with badge
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications,
                                size: 28, color: Color(0xFFFE6D00)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => NotificationListScreen(userId: 2)),
                              );
                            },
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
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
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              /// --- Profile Progress Box ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.orange.shade400,
                      Colors.orange.shade200,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.edit_document,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Profile Completion",
                                      style: AppTextStyle.mediumInterText(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Complete your profile to get better matches",
                                      style: AppTextStyle.regularInterText(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Stack(
                            children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Container(
                                height: 8,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "40% Completed",
                                style: AppTextStyle.regularInterText(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BasicDetailsScreen(isRegisteredScreen: false,)),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Complete Now",
                                      style: AppTextStyle.mediumInterText(
                                        color: Colors.orange.shade400,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 16,
                                      color: Colors.orange.shade400,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                  statusCard(homeProvider.homeModel?.totalLikes.toString()
                      ?? "0", "Total Likes", ColorConstant.gridColorOne, 'assets/images/eye.png'),
                  statusCard(homeProvider.homeModel?.sentRequests.toString() ?? "0", "Sent Request", ColorConstant.gridColortwo, 'assets/images/tele.png'),
                  statusCard(homeProvider.homeModel?.receivedRequests.toString() ?? "0", "Received Request", ColorConstant.gridColorthree, 'assets/images/message.png'),
                  statusCard(homeProvider.homeModel?.notInterested.toString() ?? "0", "Not Interested", ColorConstant.gridColorfour, 'assets/images/rename.png'),
                ],
              ),

              // const SizedBox(height: 25),
              //
              // const Text("Recommended Matches",
              //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              // const SizedBox(height: 15),
              // Container(
              //   height: 100,
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   alignment: Alignment.center,
              //   child: const Text("Match cards go here"),
              // ),
            ],
          ),
        ),
      );
    });
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
