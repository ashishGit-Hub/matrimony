import 'package:flutter/material.dart';
import 'package:matrimonial_app/components/empty_item.dart';
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
  const MatchesScreen({Key? key}) : super(key: key);

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  List<MatchModel> matches = [];
  bool isLoading = true;

  // Preferences
  static const preferences = [
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
  final selectedPreferences = <String, bool>{
    for (var pref in preferences) pref: false,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchMatchData();
  }

  Future<void> fetchMatchData() async {
    final matchProvider = Provider.of<MatchProvider>(context, listen: false);
    final response =
        await matchProvider.getMatches(stateId: "33", cityId: "677");
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
      builder: (_) => PreferenceBottomSheet(
        preferences: preferences,
        selectedPreferences: selectedPreferences,
        onChanged: (key, value) {
          setState(() => selectedPreferences[key] = value);
        },
        onClear: () {
          setState(() {
            for (var key in selectedPreferences.keys) {
              selectedPreferences[key] = false;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(builder: (context, matchProvider, _) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orange,
          elevation: 0,
          toolbarHeight: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
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
                : matches.isEmpty
                    ? EmptyItem(
                        title: "Your profile not matches with anyone!",
                        subtitle: "Keep exploring! Update your preferences and check back later for new potential matches.",
                        icon: Icons.people_outline)
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: ListView.builder(
                          itemCount: matches.length,
                          itemBuilder: (context, index) => MatchCard(
                              match: matches[index],
                              onUpdate: () {
                                setState(() {});
                              },
                              onRemove: () {
                                setState(() {
                                  matches.removeAt(index);
                                });
                              }),
                        ),
                      ),
            const SendMatchesPage(),
            const ReceiveMatchesPage(),
            const NotInterestedPage(),
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
}

class PreferenceBottomSheet extends StatelessWidget {
  final List<String> preferences;
  final Map<String, bool> selectedPreferences;
  final void Function(String, bool) onChanged;
  final VoidCallback onClear;

  const PreferenceBottomSheet({
    super.key,
    required this.preferences,
    required this.selectedPreferences,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
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
          ...preferences.map((pref) => CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(pref),
                value: selectedPreferences[pref],
                onChanged: (val) => onChanged(pref, val ?? false),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {
                  onClear();
                  Navigator.pop(context);
                },
                child: const Text("Clear"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Apply"),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final MatchModel match;
  final VoidCallback? onUpdate;
  final VoidCallback? onRemove;

  const MatchCard({
    super.key,
    required this.match,
    this.onUpdate,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
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
                      builder: (_) =>
                          ProfileDetailScreen(userId: match.id ?? ""),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
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
                child: _LikeButton(match: match, onUpdate: onUpdate),
              ),
              const Positioned(
                bottom: 10,
                left: 10,
                child: _ChatBubble(text: "Last seen 2m ago"),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(match.name ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 18,
                  runSpacing: 12,
                  children: [
                    _infoItem(
                        'assets/images/age.png', '${match.age ?? "--"} yrs'),
                    _infoItem(
                        'assets/images/age.png', '${match.height ?? "--"} cm'),
                    _infoItem(
                        'assets/images/age.png', match.education?.name ?? "--"),
                    _infoItem(
                        'assets/images/age.png', match.city?.name ?? "--"),
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
                          final provider = Provider.of<MatchProvider>(context,
                              listen: false);
                          bool success = await provider.sendInterest(
                              userId: match.id ?? "");

                          if (success) {
                            onRemove?.call();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("✅ Interest sent")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("❌ Failed to send interest")),
                            );
                          }
                        },
                        child: Text("Yes, Interested",
                            style: TextStyle(color: ColorConstant.black)),
                      ),
                    ),
                    const SizedBox(width: 10),
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
                            onRemove?.call();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Not Interested")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Failed to send not interested")),
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

  static Widget _infoItem(String imagePath, String text) {
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

class _LikeButton extends StatefulWidget {
  final MatchModel match;
  final VoidCallback? onUpdate;

  const _LikeButton({required this.match, this.onUpdate});

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton> {
  bool isLiking = false;

  @override
  Widget build(BuildContext context) {
    final match = widget.match;
    return Column(
      children: [
        GestureDetector(
          onTap: isLiking
              ? null
              : () async {
                  setState(() => isLiking = true);
                  final token = Preferences.getString(AppConstants.token,
                      defaultValue: "");
                  final success = await MatchService.updateLikeUser(
                    token: token,
                    likedId: match.id ?? "",
                  );

                  if (success) {
                    setState(() {
                      match.isLiked = !(match.isLiked ?? false);
                      match.likes =
                          (match.likes ?? 0) + (match.isLiked == true ? 1 : -1);
                    });
                    widget.onUpdate?.call();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to update like")),
                    );
                  }
                  setState(() => isLiking = false);
                },
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              match.isLiked == true ? Icons.favorite : Icons.favorite_border,
              color: match.isLiked == true ? Colors.red : Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text('${match.likes ?? 0}',
            style: const TextStyle(fontSize: 12, color: Colors.black)),
      ],
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  const _ChatBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ChatBubbleClipper(),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(text, style: const TextStyle(fontSize: 12)),
      ),
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
