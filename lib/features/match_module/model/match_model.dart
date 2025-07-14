class MatchResponse {
  final bool status;
  final String message;
  final List<MatchModel>? data;

  MatchResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory MatchResponse.fromJson(Map<String, dynamic> json) {
    return MatchResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MatchModel.fromJson(e))
          .toList(),
    );
  }
}

class MatchModel {
  final String? id;
  final String? dummyId;
  String? name;
  String? age;
  String? height;
  String? weight;
  String? profile;
  int? likes;
  bool? isLiked;
  String? email;
  String? mobile;
  String? myself;
  String? gender;

  SimpleName? education;
  SimpleName? occupation;
  SimpleName? city;
  SimpleName? caste;
  SimpleName? state;
  SimpleName? relegion;
  SimpleName? profileFor;
  SimpleName? jobType;
  SimpleName? companyType;
  SimpleName? annualIncome;

  List<GalleryModel>? galleries; // ✅ Add galleries directly

  MatchModel({
    this.id,
    this.dummyId,
    this.name,
    this.age,
    this.height,
    this.weight,
    this.profile,
    this.likes,
    this.isLiked,
    this.email,
    this.mobile,
    this.myself,
    this.gender,
    this.education,
    this.occupation,
    this.city,
    this.caste,
    this.state,
    this.relegion,
    this.profileFor,
    this.jobType,
    this.companyType,
    this.annualIncome,
    this.galleries,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id']?.toString(),
      dummyId: json['dummyid'],
      name: json['name'],
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
      profile: json['profile'],
      likes: json['likes'],
      isLiked: json['is_liked'],
      email: json['email'],
      mobile: json['mobile'],
      myself: json['myself'],
      gender: json['gender'],
      education: json['education'] != null ? SimpleName.fromJson(json['education']) : null,
      occupation: json['occupation'] != null ? SimpleName.fromJson(json['occupation']) : null,
      city: json['city'] != null ? SimpleName.fromJson(json['city']) : null,
      caste: json['caste'] != null ? SimpleName.fromJson(json['caste']) : null,
      state: json['state'] != null ? SimpleName.fromJson(json['state']) : null,
      relegion: json['relegion'] != null ? SimpleName.fromJson(json['relegion']) : null,
      profileFor: json['profileFor'] != null ? SimpleName.fromJson(json['profileFor']) : null,
      jobType: json['jobType'] != null ? SimpleName.fromJson(json['jobType']) : null,
      companyType: json['companyType'] != null ? SimpleName.fromJson(json['companyType']) : null,
      annualIncome: json['annualIncome'] != null ? SimpleName.fromJson(json['annualIncome']) : null,
      galleries: (json['galleries'] as List<dynamic>?)
          ?.map((e) => GalleryModel.fromJson(e))
          .toList(), // ✅ map gallery
    );
  }
}

class GalleryModel {
  final int? gid;
  final int? userId;
  final String imagePath;

  GalleryModel({
    this.gid,
    this.userId,
    required this.imagePath,
  });

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    return GalleryModel(
      gid: json['gid'],
      userId: json['user_id'],
      imagePath: json['image_path'] ?? '',
    );
  }
}

class SimpleName {
  final int? id;
  final String? name;

  SimpleName({this.id, this.name});

  factory SimpleName.fromJson(Map<String, dynamic> json) {
    return SimpleName(
      id: json['eid'] ??
          json['oid'] ??
          json['rid'] ??
          json['cid'] ??
          json['ptid'] ??
          json['sid'] ??
          json['cityid'] ??
          json['jtid'] ??
          json['ctid'],
      name: json['name'],
    );
  }
}
