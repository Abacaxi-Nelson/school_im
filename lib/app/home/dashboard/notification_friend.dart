import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/app/top_level_providers.dart';
import 'package:school_im/app/home/models/school.dart';

final friendRequestsStream = StreamProvider.autoDispose<List<UserInfo>>((ref) {
  final database = ref.watch(databaseProvider);
  return database?.friendRequestsStream() ?? const Stream.empty();
});

class NotificationFriend extends ConsumerWidget {
  const NotificationFriend({Key key, @required this.click}) : super(key: key);
  final Function click;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final stream = watch(friendRequestsStream);
    return Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: GestureDetector(
            onTap: () {
              click();
            },
            child: Badge(
              elevation: 0,
              badgeColor: Color(0xff9188E5),
              position: BadgePosition.topEnd(top: 0, end: -8),
              showBadge: stream.when(
                data: (items) => items.isNotEmpty ? true : false,
                loading: () => false,
                error: (_, __) => false,
              ),
              badgeContent: Text(''),
              child: const Icon(Icons.face, size: 30.0, color: Color(0xff201F23)),
            )));
  }
}
