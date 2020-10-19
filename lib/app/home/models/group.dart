import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:school_im/app/home/models/message.dart';

class Group extends Equatable {
  Group(
      {@required this.id,
      @required this.createdBy,
      @required this.createdDate,
      this.modifiedDate,
      this.members,
      this.last});

  final String id;
  final String createdBy;
  final DateTime createdDate;
  DateTime modifiedDate;
  List<String> members;
  MessageWithoutId last;

  @override
  List<Object> get props => [id, createdBy, createdDate, modifiedDate, members, last];

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
        members: List<String>.from(value['members'].map((item) {
          return item;
        })));
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'createdBy': createdBy,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'modifiedDate': modifiedDate.millisecondsSinceEpoch,
      'last': last.toMap(),
      'members': members.map((item) {
        return item;
      }).toList(),
    };
  }
}
