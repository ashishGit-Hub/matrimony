import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/match_provider.dart';
import '../../../utils/preferences.dart';
import '../../../utils/app_constants.dart';

class NotInterestedpage extends StatefulWidget {
  const NotInterestedpage({Key? key}) : super(key: key);

  @override
  State<NotInterestedpage> createState() => _NotInterestedpageState();
}

class _NotInterestedpageState extends State<NotInterestedpage> {
  @override
  void initState() {
    super.initState();
    final token = Preferences.getString(AppConstants.token, defaultValue: "");
    if (token != null) {
      Future.microtask(() =>
          Provider.of<MatchProvider>(context, listen: false)
              .fetchNotInterested(token));
    }
  }

  @override
  Widget build(BuildContext context) {
    final matchProvider = Provider.of<MatchProvider>(context);
    final list = matchProvider.notInterestedList;

    return Scaffold(
      body: matchProvider.isLoadingNotInterested
          ? const Center(child: CircularProgressIndicator())
          : list.isEmpty
          ? const Center(child: Text("No not-interested profiles found"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final match = list[index];
          final imagePath =
              "https://matrimony.sqcreation.site/${match.profile ?? ''}";

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
                  backgroundImage: match.profile?.isNotEmpty == true
                      ? NetworkImage(imagePath)
                      : const AssetImage('assets/images/default_image.png')
                  as ImageProvider,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        match.name ?? "--",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      if (match.age != null)
                        Text("Age: ${match.age}",
                            style: TextStyle(color: Colors.grey[700])),
                      if (match.education?.name != null)
                        Text("Education: ${match.education!.name}"),
                      if (match.city?.name != null)
                        Text("City: ${match.city!.name}"),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final token = Preferences.getString(AppConstants.token, defaultValue: "");

                    final success = await matchProvider.revokeNotInterested(match.id ?? '', token);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success
                            ? "Removed '${match.name}' from not interested list"
                            : "Failed to remove ${match.name}"),
                      ),
                    );
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
