class HomeModel {
  final int totalLikes;
  final int sentRequests;
  final int receivedRequests;
  final int notInterested;

  HomeModel({
    required this.totalLikes,
    required this.sentRequests,
    required this.receivedRequests,
    required this.notInterested,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      totalLikes: json['total_likes'] ?? 0,
      sentRequests: json['sent_requests'] ?? 0,
      receivedRequests: json['received_requests'] ?? 0,
      notInterested: json['not_interested'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_likes': totalLikes,
      'sent_requests': sentRequests,
      'received_requests': receivedRequests,
      'not_interested': notInterested,
    };
  }

  @override
  String toString() {
    return 'HomeModel(totalLikes: $totalLikes, sentRequests: $sentRequests, receivedRequests: $receivedRequests, notInterested: $notInterested)';
  }
}