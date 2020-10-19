import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Message extends Equatable {
  const Message({@required this.id, @required this.text, @required this.createdDate, @required this.createdBy});

  final String id;
  final String text;
  final String createdBy;
  final DateTime createdDate;

  @override
  List<Object> get props => [id, createdBy, createdDate, text];

  @override
  bool get stringify => true;

  factory Message.fromMap(Map<dynamic, dynamic> value, String id) {
    final createdDate = value['createdDate'] as int;
    return Message(
      id: id,
      text: value['text'],
      createdBy: value['createdBy'],
      createdDate: DateTime.fromMillisecondsSinceEpoch(createdDate),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'createdBy': createdBy,
      'createdDate': createdDate.millisecondsSinceEpoch,
    };
  }
}

class MessageWithoutId extends Equatable {
  const MessageWithoutId({@required this.text, @required this.createdDate, @required this.createdBy});

  final String text;
  final String createdBy;
  final DateTime createdDate;

  @override
  List<Object> get props => [createdBy, createdDate, text];

  @override
  bool get stringify => true;

  factory MessageWithoutId.fromMap(Map<dynamic, dynamic> value) {
    final createdDate = value['createdDate'] as int;
    return MessageWithoutId(
      text: value['text'],
      createdBy: value['createdBy'],
      createdDate: DateTime.fromMillisecondsSinceEpoch(createdDate),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'createdBy': createdBy,
      'createdDate': createdDate.millisecondsSinceEpoch,
    };
  }
}
