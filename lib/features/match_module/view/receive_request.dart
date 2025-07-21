import 'package:flutter/material.dart';
import 'package:matrimonial_app/features/match_module/model/match_model.dart';
import 'package:matrimonial_app/features/match_module/view/profiledetailscreen.dart';

class ReceiveMatchesPage extends StatelessWidget {
  final List<MatchModel> receivedRequests;

  const ReceiveMatchesPage({Key? key, required this.receivedRequests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Received Matches",style: TextStyle(color: Colors.white),)),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.white,
      body: receivedRequests.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 20),
              Text(
                "No received requests yet!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "You haven't received any match requests so far. Stay tuned for new connections!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: receivedRequests.length,
        itemBuilder: (context, index) {
          final match = receivedRequests[index];
          final imagePath = "https://matrimony.sqcreation.site/${match.profile ?? ""}";

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(30), // match CircleAvatar radius for ripple effect
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>ProfileDetailScreen(userId: '',), // replace with your screen and pass data if needed
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: match.profile?.isNotEmpty == true
                          ? NetworkImage(imagePath)
                          : const AssetImage('assets/images/default_image.png') as ImageProvider,
                    ),
                  ),

                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          match.name ?? "--",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        Row(
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.green),
                                foregroundColor: Colors.green,
                                minimumSize: const Size(70, 32), // width: 70, height: 32 (smaller size)
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // smaller padding
                                textStyle: const TextStyle(fontSize: 14), // smaller font size
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Accepted ${match.name}")),
                                );
                              },
                              child: const Text("Accept"),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                                foregroundColor: Colors.red,
                                minimumSize: const Size(70, 32),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                              onPressed: () {
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
            ),
          );
        },
      ),
    );
  }
}
