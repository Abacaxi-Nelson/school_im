import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Parent extends Equatable {
  Parent(
      {@required this.id,
      @required this.email,
      @required this.createdDate,
      @required this.phone,
      this.validatedDate,
      this.parentId});

  final String id;
  String parentId;
  final String email;
  final String phone;
  final DateTime createdDate;
  DateTime validatedDate;

  @override
  List<Object> get props => [validatedDate, id, email, phone, createdDate, parentId];

  @override
  bool get stringify => true;

  factory Parent.fromMap(Map<dynamic, dynamic> value, String id) {
    print("fromMap");
    final createdDate = value['createdDate'] as int;
    var validatedDate = null;
    if (value['validatedDate'] != null) {
      validatedDate = value['validatedDate'] as int;
    }

    return Parent(
      id: id,
      email: value['email'],
      phone: value['phone'],
      parentId: value['parentId'] == null ? null : value['parentId'],
      createdDate: DateTime.fromMillisecondsSinceEpoch(createdDate),
      validatedDate: validatedDate == null ? null : DateTime.fromMillisecondsSinceEpoch(validatedDate),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'phone': phone,
      'parentId': parentId == null ? null : parentId,
      'validatedDate': validatedDate == null ? null : validatedDate.millisecondsSinceEpoch,
      'createdDate': createdDate.millisecondsSinceEpoch,
    };
  }
}
