import 'package:flutter/material.dart';
import 'package:matrimonial_app/components/empty_item.dart';
import 'package:matrimonial_app/utils/app_constants.dart';
import 'package:provider/provider.dart';
import '../../../providers/match_provider.dart';

class NotInterestedPage extends StatefulWidget {
  const NotInterestedPage({super.key});

  @override
  State<NotInterestedPage> createState() => _NotInterestedPageState();
}

class _NotInterestedPageState extends State<NotInterestedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MatchProvider>(context, listen: false).fetchNotInterested();
    });
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final matchProvider = Provider.of<MatchProvider>(context);
    final list = matchProvider.notInterestedList;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: matchProvider.isLoadingNotInterested
          ? const Center(child: CircularProgressIndicator())
          : list.isEmpty
              ? EmptyItem(
                  title: "No Not Interests requests yet!",
                  subtitle:
                      "When you mark profiles as 'Not Interested', they will appear here. You can always revoke this decision later.",
                  icon: Icons.person_off)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final match = list[index];
                    final imagePath =
                        "${AppConstants.baseUrl}/${match.user.profile ?? ''}";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 6)
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundImage:
                                match.user.profile?.isNotEmpty == true
                                    ? NetworkImage(imagePath)
                                    : const AssetImage(
                                            'assets/images/default_image.png')
                                        as ImageProvider,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  match.user.name ?? "--",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 6),
                                if (match.user.age != null)
                                  Text("Age: ${match.user.age}",
                                      style:
                                          TextStyle(color: Colors.grey[700])),
                                if (match.user.city?.name != null)
                                  Text("City: ${match.user.city!.name}"),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final success =
                                  await matchProvider.revokeNotInterested(
                                      match.notInterestId ?? '');
                              showSnackBar(success
                                  ? "Removed '${match.user.name}' from not interested list"
                                  : "Failed to remove ${match.user.name}");
                              if (success) {
                                matchProvider
                                    .fetchNotInterested(); // Refresh list
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
