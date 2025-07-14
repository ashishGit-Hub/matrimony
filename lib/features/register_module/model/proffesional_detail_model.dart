class Education {
  final int eid;
  final String name;

  Education({required this.eid, required this.name});

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      eid: json['eid'],
      name: json['name'],
    );
  }
}

class JobType {
  final int jtid;
  final String name;

  JobType({required this.jtid, required this.name});

  factory JobType.fromJson(Map<String, dynamic> json) {
    return JobType(
      jtid: json['jtid'],
      name: json['name'],
    );
  }
}

class CompanyType {
  final int ctid;
  final String name;

  CompanyType({required this.ctid, required this.name});

  factory CompanyType.fromJson(Map<String, dynamic> json) {
    return CompanyType(
      ctid: json['ctid'],
      name: json['name'],
    );
  }
}

class Occupation {
  final int oid;
  final String name;

  Occupation({required this.oid, required this.name});

  factory Occupation.fromJson(Map<String, dynamic> json) {
    return Occupation(
      oid: json['oid'],
      name: json['name'],
    );
  }
}

class AnnualIncome {
  final int aid;
  final String range;

  AnnualIncome({required this.aid, required this.range});

  factory AnnualIncome.fromJson(Map<String, dynamic> json) {
    return AnnualIncome(
      aid: json['aid'],
      range: json['range'],
    );
  }
}
