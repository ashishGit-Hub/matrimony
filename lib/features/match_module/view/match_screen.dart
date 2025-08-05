import 'package:flutter/material.dart';
import 'package:matrimonial_app/core/constant/color_constant.dart';
import 'package:matrimonial_app/features/match_module/model/match_model.dart';
import 'package:matrimonial_app/features/match_module/view/receive_request.dart';
import 'package:matrimonial_app/features/match_module/view/send_request_page.dart';
import 'package:matrimonial_app/providers/match_provider.dart';
import 'package:matrimonial_app/services/match_service.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/preferences.dart';
import 'Notinterested_screen.dart';
import 'profiledetailscreen.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<MatchModel> matches = [];
  bool isLoading = true;
  List<MatchModel> sentRequests = [];
  List<MatchModel> receivedRequests = [];


  final List<String> preferences = [
    "All Matches",
    "Newly Joined",
    "Viewed You",
    "Shortlisted You",
    "Viewed By You",
    "Shortlisted By You",
    "Sent Request",
    "Receive Request",
    "Accepted Request",
  ];
  final Map<String, bool> selectedPreferences = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    fetchMatchData();

    // Initialize preferences
    for (var pref in preferences) {
      selectedPreferences[pref] = false;
    }

    // Dummy Sent Requests
    sentRequests = [
      // MatchModel(name: "Priya Sharma", profile: "", status: "accepted"),
      // MatchModel(name: "Ravi Kumar", profile: "", status: "rejected"),
    ];

    // Dummy Received Requests
    receivedRequests = [
      MatchModel(name: "Ankita Yadav", profile: ""),
      MatchModel(name: "Raj Verma", profile: ""),
    ];
  }


  Future<void> fetchMatchData() async {
    final matchProvider = Provider.of<MatchProvider>(context, listen: false);
    final response = await matchProvider.getMatches(
      stateId: "33",
      cityId: "677",
    );

    if (response != null && response.status) {
      setState(() {
        matches = response.data ?? [];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load matches")),
      );
    }
  }

  void _showPreferenceBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Text(
                "Match Preference:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...preferences.map((pref) {
                return CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(pref),
                  value: selectedPreferences[pref],
                  onChanged: (bool? value) {
                    setState(() {
                      selectedPreferences[pref] = value ?? false;
                    });
                  },
                );
              }).toList(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        for (var key in selectedPreferences.keys) {
                          selectedPreferences[key] = false;
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Clear"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Apply"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSendTab() {
    if (sentRequests.isEmpty) {
      return const Center(child: Text("No sent requests"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sentRequests.length,
      itemBuilder: (context, index) {
        final match = sentRequests[index];
        final imagePath = "https://matrimony.sqcreation.site/${match.profile ?? ""}";
        // final status = match.status?.toLowerCase() ?? "pending";
        // final color = status == "accepted"
        //     ? Colors.green
        //     : status == "rejected"
        //     ? Colors.red
        //     : Colors.orange;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: match.profile?.isNotEmpty == true
                    ? NetworkImage(imagePath)
                    : const AssetImage('assets/images/default_image.png') as ImageProvider,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(match.name ?? "--", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    // Text("Status: ${status.toUpperCase()}",
                    //     style: TextStyle(color: color, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildReceiveTab() {
    if (receivedRequests.isEmpty) {
      return const Center(child: Text("No received requests"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: receivedRequests.length,
      itemBuilder: (context, index) {
        final match = receivedRequests[index];
        final imagePath = "https://matrimony.sqcreation.site/${match.profile ?? ""}";

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: match.profile?.isNotEmpty == true
                    ? NetworkImage(imagePath)
                    : const AssetImage('assets/images/default_image.png') as ImageProvider,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(match.name ?? "--", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            // Accept logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Accepted ${match.name}")),
                            );
                          },
                          child: const Text("Accept"),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () {
                            // Reject logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Rejected ${match.name}")),
                            );
                          },
                          child: const Text("Reject"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(builder: (context, matchProvider, child) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orange,
          elevation: 0,
          toolbarHeight: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(text: "Profile"),
                Tab(text: "Send"),
                Tab(text: "Receive"),
                Tab(text: "NotInterested"),
              ],
            ),
          ),
        ),

        body: TabBarView(
          controller: _tabController,
          children: [
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  final match = matches[index];
                  return _matchCard(match: match);
                },
              ),
            ),
            SendMatchesPage(),

            // Use new ReceiveMatchesPage widget
            ReceiveMatchesPage(),
            NotInterestedpage()
          ],
        ),
        floatingActionButton: _tabController.index == 0
            ? FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: _showPreferenceBottomSheet,
          child: const Icon(Icons.filter_alt),
        )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      );
    });
  }

  Widget _matchCard({required MatchModel match}) {
    final imagePath =
        "https://matrimony.sqcreation.site/${match.profile ?? ""}";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileDetailScreen(userId: match.id ?? ""),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/default_image.png',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final token = Preferences.getString(AppConstants.token, defaultValue: "");
                        final success = await MatchService.updateLikeUser(
                          token: token!,
                          likedId: match.id ?? "",
                        );

                        if (success) {
                          setState(() {
                            match.isLiked = !(match.isLiked ?? false);
                            if (match.isLiked == true) {
                              match.likes = (match.likes ?? 0) + 1;
                            } else {
                              match.likes = (match.likes ?? 1) - 1;
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Failed to update like")),
                          );
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          match.isLiked == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: match.isLiked == true ? Colors.red : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${match.likes ?? 0}',
                        style: const TextStyle(fontSize: 12, color: Colors.black)),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: ClipPath(
                  clipper: ChatBubbleClipper(),
                  child: Container(
                    color: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: const Text("Last seen 2m ago",
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(match.name ?? "",
                    style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 18,
                  runSpacing: 12,
                  children: [
                    _infoItem('assets/images/age.png',
                        '${match.age ?? "--"} yrs'),
                    _infoItem('assets/images/age.png',
                        '${match.height ?? "--"} cm'),
                    _infoItem('assets/images/age.png',
                        match.education?.name ?? "--"),
                    _infoItem('assets/images/age.png',
                        match.city?.name ?? "--"),
                    _infoItem('assets/images/age.png',
                        match.occupation?.name ?? "--"),
                  ],
                ),
                const Divider(height: 30),
                const Text("Interested with this profile?",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final token =
                          Preferences.getString("token", defaultValue: "");
                          final provider = Provider.of<MatchProvider>(context,
                              listen: false);
                          bool success = await provider.sendInterest(
                              token: token, userId: match.id ?? "");

                          if (success) {
                            setState(() {
                              matches.remove(match);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("✅ Interest sent")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("❌ Failed to send interest")),
                            );
                          }
                        },
                        child: Text("Yes, Interested",
                            style: TextStyle(color: ColorConstant.black)),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final token =
                          Preferences.getString("token", defaultValue: "");
                          final provider = Provider.of<MatchProvider>(context,
                              listen: false);
                          bool success = await provider.sendNotInterested(
                              token: token, userId: match.id ?? "");

                          if (success) {
                            setState(() {
                              matches.remove(match);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("🚫 Not Interested")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                  Text("❌ Failed to send not interested")),
                            );
                          }
                        },
                        child: Text("No",
                            style: TextStyle(color: ColorConstant.black)),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String imagePath, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(imagePath, height: 23, width: 22),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }
}

class ChatBubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width - 10, 0);
    path.lineTo(size.width - 10, size.height - 6);
    path.lineTo(size.width - 4, size.height);
    path.lineTo(size.width - 10, size.height - 2);
    path.lineTo(0, size.height - 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}