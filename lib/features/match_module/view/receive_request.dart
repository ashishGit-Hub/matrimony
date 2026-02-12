import 'package:flutter/material.dart';
import 'package:matrimonial_app/providers/match_provider.dart';
import 'package:provider/provider.dart';
import 'package:matrimonial_app/features/match_module/view/profiledetailscreen.dart';


class ReceiveMatchesPage extends StatefulWidget {
  const ReceiveMatchesPage({super.key});

  @override
  State<ReceiveMatchesPage> createState() => _ReceiveMatchesPageState();
}

class _ReceiveMatchesPageState extends State<ReceiveMatchesPage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final matchProvider = Provider.of<MatchProvider>(context, listen: false);
      matchProvider.fetchReceivedInterests();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, matchProvider, child) {

        final receivedRequests = matchProvider.receivedInterests;
        final error = matchProvider.errorReceived;

        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: matchProvider.isLoadingReceived
              ? const Center(child: CircularProgressIndicator())
              : error != null
              ? Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      size: 80, color: Colors.red[300]),
                  const SizedBox(height: 20),
                  const Text(
                    "Failed to load received requests",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    error,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      matchProvider.clearErrorReceived();
                      matchProvider.fetchReceivedInterests();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          )
              : receivedRequests.isEmpty
              ? Center(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  const Text(
                    "No received requests yet!",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "You haven't received any match requests so far. Stay tuned for new connections!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 20),
            itemCount: receivedRequests.length,
            itemBuilder: (context, index) {
              final match = receivedRequests[index];
              final imagePath =
                  "https://matrimony.sqcreation.site/${match.sender.profile ?? ""}";

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
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
                              builder: (context) =>
                                  ProfileDetailScreen(
                                    userId:
                                    match.sender.id.toString() ??
                                        '',
                                  ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: match
                              .sender.profile
                              ?.isNotEmpty ==
                              true
                              ? NetworkImage(imagePath)
                              : const AssetImage(
                              'assets/images/default_image.png')
                          as ImageProvider,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              match.sender.name ?? "--",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            if (match.sender.age != null &&
                                match.sender.age != "0")
                              Text(
                                'Age: ${match.sender.age}',
                                style: TextStyle(
                                    color: Colors.grey[700]),
                              ),
                            if (match.sender.city != null)
                              Text(
                                'City: ${match.sender.city?.name}',
                                style: TextStyle(
                                    color: Colors.grey[700]),
                              ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Colors.green),
                                    foregroundColor: Colors.green,
                                    minimumSize:
                                    const Size(70, 32),
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4),
                                    textStyle: const TextStyle(
                                        fontSize: 14),
                                  ),
                                  onPressed: () async {
                                    final success = await matchProvider.acceptInterest(
                                      match.interestId.toString(),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(success
                                            ? "Accepted ${match.sender.name}"
                                            : "Failed to accept ${match.sender.name}"),
                                      ),
                                    );
                                    if(success){
                                      matchProvider.fetchReceivedInterests();
                                    }
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
                                      match.interestId.toString(), // ✅ Correct: Send interestId
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          success
                                              ? "Rejected ${match.sender.name}"
                                              : "Failed to reject ${match.sender.name}",
                                        ),
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
      },
    );
  }
}


