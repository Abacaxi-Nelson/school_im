import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/app/home/job_entries/format.dart';
import 'package:school_im/app/home/profile/profile_list_tile.dart';
import 'package:school_im/app/home/models/school.dart';
import 'package:school_im/app/home/models/parent.dart';
import 'package:school_im/services/firestore_database.dart';

import 'package:school_im/app/top_level_providers.dart';
import 'package:school_im/constants/strings.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/app/home/models/group.dart';
import 'package:school_im/app/home/models/message.dart';

import 'package:school_im/app/home/jobs/empty_content.dart';
import 'package:school_im/app/home/dashboard/friend_search_delegate.dart';
import 'package:badges/badges.dart';
import 'package:school_im/app/home/dashboard/notification_friend.dart';
import 'package:school_im/routing/app_router.dart';
import 'package:school_im/app/home/chat/chat.dart';
import 'package:school_im/app/home/jobs/list_items_builder.dart';
import 'package:badges/badges.dart';
import 'package:intl/intl.dart';

final groupsStreamProvider = StreamProvider.autoDispose.family<List<Group>, String>((ref, id) {
  final database = ref.watch(databaseProvider);
  return database?.groupsStreamWithId(id) ?? const Stream.empty();
});

class DashboardParentPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    //final firebaseAuth = context.read(firebaseAuthProvider);
    //final database = context.read(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xff201F23), //change your color here
        ),
        elevation: 0.0,
        title: const Text(
          "Parent",
          style: TextStyle(fontSize: 20.0, color: Color(0xff201F23), fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Icon(Icons.logout, color: Color(0xff201F23)),
            //onPressed: () => firebaseAuth.signOut(),
          ),
        ],
      ),
      body: _buildBody(context, watch),
    );
  }

  Widget _buildBody(BuildContext context, ScopedReader watch) {
    AsyncValue<Parent> parent = watch(parentProvider);

    return parent.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => const EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load data right now.',
      ),
      data: (p) {
        print("////////");
        print(p);
        return _buildChats(context, watch, p);
      },
    );
  }

  Widget _buildChats(BuildContext context, ScopedReader watch, Parent parent) {
    final groupsStream = watch(groupsStreamProvider(parent.id));

    return ListItemsBuilder<Group>(
      title: "Pas de données",
      message: " ",
      data: groupsStream,
      itemBuilder: (context, group) => GroupListTile(
        group: group,
        user: parent.id,
        parent: parent,
        onTap: (UserInfo val) {},
      ),
    );
  }
}

class GroupListTile extends StatelessWidget {
  const GroupListTile({Key key, @required this.group, this.onTap, this.user, this.parent}) : super(key: key);
  final Group group;
  final Function onTap;
  final String user;
  final Parent parent;

  UserInfo getUserInfo() {
    UserInfo userInfo;
    group.membersWithInfo.forEach((profile) {
      print("user ${user}");
      print("---> ${profile}");
      if (profile.id != user) userInfo = profile;
    });
    print("end ${userInfo}");
    return userInfo;
  }

  String getLast(MessageWithoutId m) {
    if (m == null) return "";
    if (m.image != null) return "Image";
    if (m.text == null) return "";
    int length = m.text.length;

    final f = DateFormat('dd MMMM hh:mm');
    String d = f.format(m.createdDate);
    return m.text.substring(0, length > 40 ? 40 : length) + "... " + d;
  }

  Widget getAvatar(String photoUrl, String name) {
    return photoUrl == null
        ? CircleAvatar(
            radius: 15.0,
            child: Text(name.toUpperCase()[0], style: const TextStyle(color: Color(0xff9188E5))),
            backgroundColor: Colors.white,
          )
        : CircleAvatar(
            radius: 15.0,
            backgroundImage: NetworkImage(photoUrl),
            backgroundColor: Colors.transparent,
          );
  }

  @override
  Widget build(BuildContext context) {
    UserInfo userInfo = getUserInfo();
    print("userInfo ${userInfo}");

    Color c = Colors.white.withOpacity(0.2);
    Icon i = Icon(Icons.chevron_right);
    if (group.unread == null) {
      c = Colors.white.withOpacity(0.2);
    } else if (group.unread.contains(user)) {
      Color(0xFFffca5d).withOpacity(0.5);
      i = Icon(Icons.flash_on);
    }

    return Container(
        color: c,
        child: ListTile(
          leading: Container(width: 40, height: 40, child: getAvatar(userInfo.photoUrl, userInfo.surname)),
          title: Text('${userInfo.surname} ${userInfo.name}'),
          subtitle: Text(getLast(group.last)),
          trailing: i,
          onTap: () {
            onTap(userInfo);
          },
        ));
  }
}
