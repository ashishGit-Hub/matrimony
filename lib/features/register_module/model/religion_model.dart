class Religion {
  final int rid;
  final String name;

  Religion({required this.rid, required this.name});

  factory Religion.fromJson(Map<String, dynamic> json) {
    return Religion(
      rid: json['rid'] ?? -1,
      name: json['name'] ?? '',
    );
  }
}

class Caste {
  final int cid;
  final String name;

  Caste({required this.cid, required this.name});

  factory Caste.fromJson(Map<String, dynamic> json) {
    return Caste(
      cid: json['cid'] ?? -1,
      name: json['name'] ?? '',
    );
  }
}
