import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../features/match_module/model/match_model.dart';
class User {
  final String? dummyid;
  final String? name;
  final String? email;
  final String? mobile;
  final String? age;
  final String? dob;
  final String? height;
  final String? weight;
  final String? myself;
  final String? images;
  final String? gender;
  final String? profile;
  final ProfileFor? profileFor;
  final Education? education;
  final Occupation? occupation;
  final AnnualIncome? annualIncome;
  final JobType? jobType;
  final CompanyType? companyType;
  final Religion? relegion;
  final Caste? caste;
  final StateModel? state;
  final City? city;
  final List<GalleryModel>? gallery;

  User({
    this.dummyid,
    this.name,
    this.email,
    this.mobile,
    this.age,
    this.dob,
    this.height,
    this.weight,
    this.myself,
    this.images,
    this.gender,
    this.profile,
    this.profileFor,
    this.education,
    this.occupation,
    this.annualIncome,
    this.jobType,
    this.companyType,
    this.relegion,
    this.caste,
    this.state,
    this.city,
    this.gallery,
  });

  factory User.empty() {
    return User(
        dummyid: '',
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
        profile: null,
        profileFor: null,
        education: null,
        occupation: null,
        annualIncome: null,
        jobType: null,
        companyType: null,
        relegion: null,
        caste: null,
        state: null,
        city: null,
        gallery: null
    );
  }

  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) return User.empty();

    return User(
      dummyid: json['dummyid']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      mobile: json['mobile']?.toString(),
      age: json['age']?.toString(),
      dob: json['dob']?.toString(),
      height: json['height']?.toString(),
      weight: json['weight']?.toString(),
      myself: json['myself']?.toString() ?? "",
      images: json['profile']?.toString() ?? "",
      gender: json['gender']?.toString(),
      profile: json['profile']?.toString(),
      profileFor: json['profileFor'] != null ? ProfileFor.fromJson(json['profileFor']) : null,
      education: json['education'] != null ? Education.fromJson(json['education']) : null,
      occupation: json['occupation'] != null ? Occupation.fromJson(json['occupation']) : null,
      annualIncome: json['annualIncome'] != null ? AnnualIncome.fromJson(json['annualIncome']) : null,
      jobType: json['jobType'] != null ? JobType.fromJson(json['jobType']) : null,
      companyType: json['companyType'] != null ? CompanyType.fromJson(json['companyType']) : null,
      relegion: json['relegion'] != null ? Religion.fromJson(json['relegion']) : null,
      caste: json['caste'] != null ? Caste.fromJson(json['caste']) : null,
      state: json['state'] != null ? StateModel.fromJson(json['state']) : null,
      city: json['city'] != null ? City.fromJson(json['city']) : null,
      gallery: json['galleries'] != null
          ? List<GalleryModel>.from(json['galleries'].map((x) => GalleryModel.fromJson(x)))
          : null,
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

class Religion {
  final int rid;
  final String name;

  Religion({required this.rid, required this.name});

  factory Religion.fromJson(Map<String, dynamic> json) {
    return Religion(
      rid: json['rid'] ?? 0,
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
      cid: json['cid'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class StateModel {
  final int sid;
  final String name;

  StateModel({required this.sid, required this.name});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      sid: json['sid'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class City {
  final int cityId;
  final String name;

  City({required this.cityId, required this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityId: json['cityid'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}