class RegistrationResponse {
  final bool status;
  final String message;
  final String? token;
  final User? user;

  RegistrationResponse({
    required this.status,
    required this.message,
    required this.token,
    required this.user,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] is String
          ? json['token']
          : (json['token']?['access'] ?? ''),
      user: json.containsKey('user') && json['user'] != null
          ? User.fromJson(json['user'])
          : User.empty(),
    );
  }
}

class User {
  final String? name;
  final String? email;
  final String mobile;
  final String age;
  final String dob;
  final String height;
  final String weight;
  final String? myself;
  final String? images;
  final String? gender;
  final ProfileFor? profileFor;
  final Education? education;
  final Occupation? occupation;
  final AnnualIncome? annualIncome;
  final JobType? jobType;
  final CompanyType? companyType;
  final String? relegion;
  final String? caste;

  User({
    required this.name,
    required this.email,
    required this.mobile,
    required this.age,
    required this.dob,
    required this.height,
    required this.weight,
    required this.myself,
    required this.images,
    required this.gender,
    required this.profileFor,
    required this.education,
    required this.occupation,
    required this.annualIncome,
    required this.jobType,
    required this.companyType,
    required this.relegion,
    required this.caste,
  });

  factory User.empty() {
    return User(
      name: '',
      email: '',
      mobile: '',
      age: '',
      dob: '',
      height: '',
      weight: '',
      myself: '',
      images: null,
      gender: '',
      profileFor: null,
      education: null,
      occupation: null,
      annualIncome: null,
      jobType: null,
      companyType: null,
      relegion: '',
      caste: '',
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      mobile: json['mobile']?.toString() ?? '',
      age: json['age']?.toString() ?? '',
      dob: json['dob']?.toString() ?? '',
      height: json['height']?.toString() ?? '',
      weight: json['weight']?.toString() ?? '',
      myself: json['myself'],
      images: json['images'],
      gender: json['gender'],
      profileFor: json['profileFor'] != null
          ? ProfileFor.fromJson(json['profileFor'])
          : null,
      education: json['education'] != null
          ? Education.fromJson(json['education'])
          : null,
      occupation: json['occupation'] != null
          ? Occupation.fromJson(json['occupation'])
          : null,
      annualIncome: json['annualIncome'] != null
          ? AnnualIncome.fromJson(json['annualIncome'])
          : null,
      jobType: json['jobType'] != null
          ? JobType.fromJson(json['jobType'])
          : null,
      companyType: json['companyType'] != null
          ? CompanyType.fromJson(json['companyType'])
          : null,
      relegion: json['relegion'],
      caste: json['caste'],
    );
  }
}

class ProfileFor {
  final int ptid;
  final String name;

  ProfileFor({required this.ptid, required this.name});

  factory ProfileFor.fromJson(Map<String, dynamic> json) {
    return ProfileFor(
      ptid: json['ptid'] is int ? json['ptid'] : int.tryParse(json['ptid'].toString()) ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class Education {
  final int eid;
  final String name;

  Education({required this.eid, required this.name});

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      eid: json['eid'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class Occupation {
  final int oid;
  final String name;

  Occupation({required this.oid, required this.name});

  factory Occupation.fromJson(Map<String, dynamic> json) {
    return Occupation(
      oid: json['oid'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class AnnualIncome {
  final int aid;
  final String range;

  AnnualIncome({required this.aid, required this.range});

  factory AnnualIncome.fromJson(Map<String, dynamic> json) {
    return AnnualIncome(
      aid: json['aid'] ?? 0,
      range: json['range'] ?? '',
    );
  }
}

class JobType {
  final int jtid;
  final String name;

  JobType({required this.jtid, required this.name});

  factory JobType.fromJson(Map<String, dynamic> json) {
    return JobType(
      jtid: json['jtid'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class CompanyType {
  final int ctid;
  final String name;

  CompanyType({required this.ctid, required this.name});

  factory CompanyType.fromJson(Map<String, dynamic> json) {
    return CompanyType(
      ctid: json['ctid'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
