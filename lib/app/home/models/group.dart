import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:school_im/app/home/models/message.dart';
import 'package:school_im/app/home/models/school.dart';

class Group extends Equatable {
  Group(
      {@required this.id,
      @required this.createdBy,
      @required this.createdDate,
      this.modifiedDate,
      this.members,
      this.last,
      this.membersWithInfo,
      this.unread});

  final String id;
  final String createdBy;
  final DateTime createdDate;
  DateTime modifiedDate;
  List<String> members;
  List<UserInfo> membersWithInfo;
  MessageWithoutId last;
  List<String> unread;

  @override
  List<Object> get props => [unread, id, createdBy, createdDate, modifiedDate, members, last, membersWithInfo];

  @override
  bool get stringify => true;

  factory Group.fromMap(Map<dynamic, dynamic> value, String id) {
    final createdDate = value['createdDate'] as int;
    final modifiedDate = value['modifiedDate'] as int;
    return Group(
        id: id,
        createdBy: value['createdBy'],
        createdDate: DateTime.fromMillisecondsSinceEpoch(createdDate),
        modifiedDate: DateTime.fromMillisecondsSinceEpoch(modifiedDate),
        last: MessageWithoutId.fromMap(value['last']),
        unread: value['unread'] == null
            ? null
            : List<String>.from(value['unread'].map((item) {
                return item;
              })),
        membersWithInfo: value['membersWithInfo'] == null
            ? null
            : List<UserInfo>.from(value['membersWithInfo'].map((item) {
                return UserInfo.fromMap(item);
              })),
        members: value['members'] == null
            ? null
            : List<String>.from(value['members'].map((item) {
                return item;
              })));
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'createdBy': createdBy,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'modifiedDate': modifiedDate.millisecondsSinceEpoch,
      'last': last != null ? last.toMap() : null,
      'unread': unread == null
          ? null
          : unread.map((item) {
              return item;
            }).toList(),
      'membersWithInfo': membersWithInfo == null
          ? null
          : membersWithInfo.map((item) {
              return item.toMap();
            }).toList(),
      'members': members == null
          ? null
          : members.map((item) {
              return item;
            }).toList(),
    };
  }
}
