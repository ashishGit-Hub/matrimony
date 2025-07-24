import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/match_provider.dart';

class SendMatchesPage extends StatefulWidget {
  const SendMatchesPage({Key? key}) : super(key: key);

  @override
  State<SendMatchesPage> createState() => _SendMatchesPageState();
}

class _SendMatchesPageState extends State<SendMatchesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<MatchProvider>(context, listen: false).fetchSentInterests());
  }

  @override
  Widget build(BuildContext context) {
    final matchProvider = Provider.of<MatchProvider>(context);
    final sentRequests = matchProvider.sentInterests;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Sent Matches", style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.white,
      body: matchProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : matchProvider.errorMessage != null
          ? Center(child: Text(matchProvider.errorMessage ?? "Error"))
          : sentRequests.isEmpty
          ? _buildEmptyState()
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
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (match.age != null)
                        Text('Age: ${match.age}',
                            style: TextStyle(color: Colors.grey[700])),
                      if (match.city?.name != null)
                        Text('City: ${match.city!.name}',
                            style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ),
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
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
    );
  }
}
