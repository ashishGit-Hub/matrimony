import 'package:flutter/material.dart';
import 'package:matrimonial_app/features/match_module/model/match_model.dart';

class SendMatchesPage extends StatelessWidget {
  final List<MatchModel> sentRequests;

  const SendMatchesPage({Key? key, required this.sentRequests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Sent Matches",style: TextStyle(color: Colors.white),)),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.white,
      body: sentRequests.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.send, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 20),
              Text(
                "No sent requests yet!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "You haven't sent any match requests so far.\nStart browsing profiles and send matches to connect!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sentRequests.length,
        itemBuilder: (context, index) {
          final match = sentRequests[index];
          final imagePath =
              "https://matrimony.sqcreation.site/${match.profile ?? ""}";

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
                      Text(
                        match.name ?? "--",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (match.age != null)
                        Text('Age: ${match.age}', style: TextStyle(color: Colors.grey[700])),
                      if (match.city != null)
                        Text('City: ${match.city}', style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ),
                Icon(Icons.send, color: Colors.orange),
              ],
            ),
          );
        },
      ),
    );
  }
}
