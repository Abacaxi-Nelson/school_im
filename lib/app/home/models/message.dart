import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Message extends Equatable {
  Message(
      {@required this.id,
      @required this.text,
      @required this.createdDate,
      @required this.createdBy,
      @required this.createdByName,
      this.image});

  final String id;
  final String text;
  final String createdBy;
  final String createdByName;
  final DateTime createdDate;
  String image;

  @override
  List<Object> get props => [createdByName, id, createdBy, createdDate, text, image];

  @override
  bool get stringify => true;

  factory Message.fromMap(Map<dynamic, dynamic> value, String id) {
    final createdDate = value['createdDate'] as int;
    return Message(
        id: id,
        createdByName: value['createdByName'],
        text: value['text'],
        createdBy: value['createdBy'],
        createdDate: DateTime.fromMillisecondsSinceEpoch(createdDate),
        image: value['image']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'createdByName': createdByName,
      'text': text,
      'createdBy': createdBy,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'image': image
    };
  }

  MessageWithoutId toMessageWithoutId() {
    return MessageWithoutId(createdDate: createdDate, text: text, createdBy: createdBy, image: image);
  }
}

class MessageWithoutId extends Equatable {
  MessageWithoutId({@required this.text, @required this.createdDate, @required this.createdBy, this.image});

  final String text;
  final String createdBy;
  final DateTime createdDate;
  String image;

  @override
  List<Object> get props => [createdBy, createdDate, text, image];

  @override
  bool get stringify => true;

  factory MessageWithoutId.fromMap(Map<dynamic, dynamic> value) {
    if (value == null) return null;
    final createdDate = value['createdDate'] as int;
    return MessageWithoutId(
        text: value['text'],
        createdBy: value['createdBy'],
        createdDate: DateTime.fromMillisecondsSinceEpoch(createdDate),
        image: value['image']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'createdBy': createdBy,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'image': image
    };
  }
}
