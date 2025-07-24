import 'package:flutter/material.dart';
import 'package:matrimonial_app/providers/match_provider.dart';
import 'package:provider/provider.dart';
import 'package:matrimonial_app/features/match_module/model/match_model.dart';
import 'package:matrimonial_app/features/match_module/view/profiledetailscreen.dart';

class ReceiveMatchesPage extends StatelessWidget {
  const ReceiveMatchesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final matchProvider = Provider.of<MatchProvider>(context);

    if (!matchProvider.isLoadingReceived &&
        matchProvider.receivedInterests.isEmpty &&
        matchProvider.errorReceived == null) {
      matchProvider.fetchReceivedInterests();
    }

    final receivedRequests = matchProvider.receivedInterests;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Received Matches",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.white,
      body: matchProvider.isLoadingReceived
          ? const Center(child: CircularProgressIndicator())
          : matchProvider.errorReceived != null
          ? Center(child: Text("Error: ${matchProvider.errorReceived}"))
          : receivedRequests.isEmpty
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
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileDetailScreen(
                            userId: match.id?.toString() ?? '',
                          ),
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
                        if (match.age != null && match.age != "0")
                          Text('Age: ${match.age}', style: TextStyle(color: Colors.grey[700])),
                        if (match.city != null)
                          Text('City: ${match.city}', style: TextStyle(color: Colors.grey[700])),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.green),
                                foregroundColor: Colors.green,
                                minimumSize: const Size(70, 32),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                              onPressed: () async {
                                final success = await matchProvider.acceptInterest(
                                  match.id?.toString() ?? '',
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(success
                                        ? "Accepted ${match.name}"
                                        : "Failed to accept ${match.name}"),
                                  ),
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
                              onPressed: () async {
                                final success = await matchProvider.rejectInterest(
                                  match.id?.toString() ?? '',
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(success
                                        ? "Rejected ${match.name}"
                                        : "Failed to reject ${match.name}"),
                                  ),
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
