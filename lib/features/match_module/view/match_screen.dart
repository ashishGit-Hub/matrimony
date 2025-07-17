// Your imports...
import 'package:flutter/material.dart';
import 'package:matrimonial_app/core/constant/color_constant.dart';
import 'package:matrimonial_app/features/match_module/model/match_model.dart';
import 'package:matrimonial_app/services/match_service.dart';
import 'package:matrimonial_app/utils/sharepref.dart';

import 'profiledetailscreen.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  List<MatchModel> matches = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // fetchMatchData();
  }

  // Future<void> fetchMatchData() async {
  //   final token = await SharedPrefs.getToken();
  //
  //   final response = await MatchService.fetchMatches(
  //     stateId: "33",
  //     cityId: "677",
  //     token: token,
  //   );
  //
  //   if (response != null && response.status) {
  //     setState(() {
  //       matches = response.data ?? [];
  //       isLoading = false;
  //     });
  //   } else {
  //     setState(() => isLoading = false);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Failed to load matches")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        elevation: 0,
        toolbarHeight: 120,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search by criteria",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      body: isLoading
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
    );
  }

  Widget _matchCard({required MatchModel match}) {
    final imagePath = "https://matrimony.sqcreation.site/${match.profile ?? ""}";

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
                        final token = await SharedPrefs.getToken();
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
                          match.isLiked == true ? Icons.favorite : Icons.favorite_border,
                          color: match.isLiked == true ? Colors.red : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${match.likes ?? 0}',
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: const Text("Last seen 2m ago", style: TextStyle(fontSize: 12)),
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
                Text(match.name ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 18,
                  runSpacing: 12,
                  children: [
                    _infoItem('assets/images/age.png', '${match.age ?? "--"} yrs'),
                    _infoItem('assets/images/age.png', '${match.height ?? "--"} cm'),
                    _infoItem('assets/images/age.png', match.education?.name ?? "--"),
                    _infoItem('assets/images/age.png', match.city?.name ?? "--"),
                    _infoItem('assets/images/age.png', match.occupation?.name ?? "--"),
                  ],
                ),
                const Divider(height: 30),
                const Text("Interested with this profile?", style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text("Yes, Interested", style: TextStyle(color: ColorConstant.black)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text("No", style: TextStyle(color: ColorConstant.black)),
                      ),
                    ),
                  ],
                )
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
