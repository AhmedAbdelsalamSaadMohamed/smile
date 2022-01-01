import 'dart:core';

import 'package:smile/utils/constants.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? username;
  bool? isAnonymous;
  String? profileUrl;
  String? gender;
  String? phone;

  UserModel( {
    this.id,
    this.name,
    this.email,
    this.isAnonymous,
    this.profileUrl,
    this.gender,
    this.phone,
    this.username,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json[fieldUserId],
        name = json[fieldUserName],
        email = json[fieldUserEmail],
        isAnonymous = json[fieldUserIsAnonymous],
        profileUrl = json[fieldUserProfileUrl],
        gender = json[fieldUserGender],
        phone = json[fieldUserPhone],
        username = json[fieldUserUsername];

  Map<String, dynamic> toJson() => {
        fieldUserId: id,
        fieldUserName: name,
        fieldUserEmail: email,
        fieldUserIsAnonymous: isAnonymous,
        fieldUserProfileUrl: profileUrl,
        fieldUserGender: gender,
        fieldUserPhone: phone,
        fieldUserUsername: username,
      };
}
