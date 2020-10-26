import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:school_im/app/home/models/school.dart';

class Profile extends Equatable {
  Profile(
      {@required this.userId,
      this.name,
      this.surname,
      this.email,
      this.phone,
      this.emailParent,
      this.phoneParent,
      this.userIdParent,
      this.schoolId,
      this.photoUrl,
      this.groups});
  final String userId;
  String name;
  String surname;
  String email;
  String photoUrl;
  String phone;
  String emailParent;
  String phoneParent;
  String userIdParent;
  String schoolId;
  List<String> groups;

  bool isNewProfile() {
    return name == null;
  }

  @override
  List<Object> get props =>
      [userId, groups, photoUrl, name, surname, email, phone, emailParent, phoneParent, userIdParent, schoolId];

  @override
  bool get stringify => true;

  factory Profile.fromMap(Map<dynamic, dynamic> value) {
    return Profile(
        userId: value['userId'],
        name: value['name'],
        surname: value['surname'],
        email: value['email'],
        phone: value['phone'],
        emailParent: value['emailParent'],
        phoneParent: value['phoneParent'],
        userIdParent: value['userIdParent'],
        schoolId: value['schoolId'],
        photoUrl: value['photoUrl'],
        groups: value['groups'] == null
            ? null
            : List<String>.from(value['groups'].map((item) {
                return item;
              })));
  }

  UserInfo toUserInfo() {
    return UserInfo(name: name, surname: surname, photoUrl: photoUrl, id: userId);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'surname': surname,
      'email': email,
      'phone': phone,
      'emailParent': emailParent,
      'phoneParent': phoneParent,
      'userIdParent': userIdParent,
      'schoolId': schoolId,
      'photoUrl': photoUrl,
      'groups': groups == null
          ? null
          : groups.map((item) {
              return item;
            }).toList(),
    };
  }
}
