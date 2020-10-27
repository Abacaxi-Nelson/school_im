import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/app/home/job_entries/format.dart';
import 'package:school_im/app/home/profile/profile_list_tile.dart';
import 'package:school_im/app/home/models/school.dart';
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

final profilesAtSchoolStreamProvider = StreamProvider.autoDispose.family<School, String>((ref, schoolId) {
  final database = ref.watch(databaseProvider);
  return database != null && schoolId != null
      ? database.ProfileBySchoolIdStream(schoolId: schoolId)
      : const Stream.empty();
});

final friendsStreamProvider = StreamProvider.autoDispose<List<UserInfo>>((ref) {
  final database = ref.watch(databaseProvider);
  return database != null ? database.friendsStream() : const Stream.empty();
});

final groupsStreamProvider = StreamProvider.autoDispose<List<Group>>((ref) {
  final database = ref.watch(databaseProvider);
  return database?.groupsStream() ?? const Stream.empty();
});

// watch database
class DashboardPage extends ConsumerWidget {
  void handleFAB(BuildContext context, ScopedReader watch, Profile profile) async {
    final database = context.read(databaseProvider);
    final firebaseAuth = context.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser;

    List<UserInfo> friends = await database.getFriendProfile();
    List<String> requests = await database.getRequestIDProfile();
    List<String> blokeds = await database.getBlokedIDProfile();

    print("handleFAB friends => ${friends}");

    UserInfo userInfo = await showSearch<UserInfo>(
      context: context,
      delegate: FriendSearchDelegate(data: friends, user: user, requests: requests, blokeds: blokeds),
    );

    if (userInfo != null) {
      print("handleFAB userInfo => ${userInfo}");

      startChat(profile, userInfo, context);
    }
  }

  void startChat(Profile p, UserInfo friend, BuildContext context) async {
    final database = context.read(databaseProvider);

    // search existing group
    Group group = await database.getGroupOrCreateIt(p, friend);
    print("get group dashboard => ${group}");

    // update unread
    print("group ${group}");
    if (group.unread != null) {
      group.unread.remove(p.userId);
      await database.setGroup(group);
    }

    //redirect to chat !!!
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.chatPage,
      arguments: {
        'group': group,
        'profile': p,
      },
    );
  }

  Widget drawer(BuildContext context) {
    final firebaseAuth = context.read(firebaseAuthProvider);

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          /*
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          */
          SizedBox(height: 50.0),
          ListTile(
            title: Text('Mon compte'),
            onTap: () async {
              await Navigator.of(context, rootNavigator: true).pushNamed(
                AppRoutes.accountPage,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    AsyncValue<Profile> profile = watch(profileProvider);

    return profile.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => const EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load data right now.',
      ),
      data: (p) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Color(0xff201F23), //change your color here
            ),
            elevation: 0.0,
            title: const Text(
              Strings.dashboardPage,
              style: TextStyle(fontSize: 20.0, color: Color(0xff201F23), fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              NotificationFriend(click: () async {
                await Navigator.of(context).pushNamed(AppRoutes.notificationFriendPage);
              }),
            ],
          ),
          body: _buildContents(context, watch, p),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFFffca5d),
            foregroundColor: Colors.black,
            elevation: 0.0,
            onPressed: () {
              handleFAB(context, watch, p);
            },
            child: Icon(
              Icons.add,
              size: 30.0,
            ),
          ),
          drawer: drawer(context),
        );
      },
    );
  }

  Widget _buildContents(BuildContext context, ScopedReader watch, Profile profile) {
    final profilesAtSchoolStream = watch(profilesAtSchoolStreamProvider(profile.schoolId));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Container(
        height: 100.0,
        //color: Colors.red,
        //child: _buildHeaderContents(context, watch, profilesAtSchoolStream),
        child: _buildFriends(context, watch, profile),
      ),
      Expanded(
          child: Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 2.0, color: Color(0xffEEEEEE))),
                image: const DecorationImage(
                  image: const AssetImage("bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: _buildChats(context, watch, profile))),
      //Expanded(child: Container()),
    ]);
  }

  Widget _buildChats(BuildContext context, ScopedReader watch, Profile profile) {
    final groupsStream = watch(groupsStreamProvider);
    final firebaseAuth = context.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser;

    return ListItemsBuilder<Group>(
      title: "Pas de données",
      message: "Ajoutez vos amis, et commencez a discuter !",
      data: groupsStream,
      itemBuilder: (context, group) => Dismissible(
        key: Key('group-${group.id}'),
        background: Container(color: Colors.red),
        direction: DismissDirection.endToStart,
        //onDismissed: (direction) => _delete(context, job),
        child: GroupListTile(
          group: group,
          user: user.uid,
          profile: profile,
          onTap: (UserInfo val) {
            print(val);
            print("ListItemsBuilder on tap start chat");
            startChat(profile, val, context);
          },
          //onTap: () => JobEntriesPage.show(context, job),
        ),
      ),
    );
  }

  Widget _buildFriends(BuildContext context, ScopedReader watch, Profile profile) {
    final friendsStream = watch(friendsStreamProvider);
    final profilesAtSchoolStream = watch(profilesAtSchoolStreamProvider(profile.schoolId));
    final database = context.read(databaseProvider);
    final firebaseAuth = context.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser;
    //firebaseAuth.signOut();

    return friendsStream.when(
      data: (userInfo) => ProfileListTile(
        userInfo: userInfo,
        addFriend: () {
          return profilesAtSchoolStream.when(
            data: (school) async {
              List<String> requests = await database.getRequestIDProfile();
              //print("requests: ${requests}");

              List<String> blokeds = await database.getBlokedIDProfile();
              //print("blokeds: ${blokeds}");

              UserInfo userInfo = await showSearch<UserInfo>(
                context: context,
                delegate: FriendSearchDelegate(data: school.list, user: user, requests: requests, blokeds: blokeds),
              );

              if (userInfo != null) {
                UserInfo myUserInfo = UserInfo(
                    name: profile.name, surname: profile.surname, photoUrl: profile.photoUrl, id: profile.userId);
                await database.setRequest(userInfo.id, myUserInfo);
              }
            },
            loading: () => Container(),
            error: (_, __) => Container(),
          );
          /*
          showSearch(
            context: context,
            delegate: FriendSearchDelegate(friendsStream: friendsStream),
          );
          */
        },
        onTap: (UserInfo val) {
          print(val);
          print("on tap start chat");
          startChat(profile, val, context);
        },
      ),
      loading: () => Container(),
      error: (_, __) => Container(),
    );
  }
}

class GroupListTile extends StatelessWidget {
  const GroupListTile({Key key, @required this.group, this.onTap, this.user, this.profile}) : super(key: key);
  final Group group;
  final Function onTap;
  final String user;
  final Profile profile;

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
