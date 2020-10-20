import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/app/home/profile/profile_list_tile.dart';
import 'package:school_im/app/home/models/school.dart';
import 'package:school_im/app/top_level_providers.dart';
import 'package:school_im/constants/strings.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/app/home/jobs/empty_content.dart';
import 'package:school_im/app/home/dashboard/friend_search_delegate.dart';

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

// watch database
class DashboardPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    AsyncValue<Profile> profile = watch(profileProvider);
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: const Text(
            Strings.dashboardPage,
            style: TextStyle(fontSize: 18.0, color: Color(0xff201F23), fontWeight: FontWeight.bold),
          ),
          /*
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffFFCA5D), //remove this when you add image.
                ),
                child: Icon(Icons.add, color: Color(0xff201F23)),
              ),
            )
          ],*/
        ),
        body: profile.when(
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => EmptyContent(
            title: 'Something went wrong',
            message: 'Can\'t load data right now.',
          ),
          data: (p) {
            return _buildContents(context, watch, p);
          },
        ));
  }

  Widget _buildContents(BuildContext context, ScopedReader watch, Profile profile) {
    final profilesAtSchoolStream = watch(profilesAtSchoolStreamProvider(profile.schoolId));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Container(
        height: 100.0,
        color: Colors.red,
        //child: _buildHeaderContents(context, watch, profilesAtSchoolStream),
        child: _buildFriends(context, watch, profile),
      ),
      Expanded(child: Container()),
    ]);
  }

  /*
  Widget _buildHeaderContents(BuildContext context, ScopedReader watch, AsyncValue<School> profilesAtSchoolStream) {
    return profilesAtSchoolStream.when(
      data: (school) => ProfileListTile(
        school: school,
        onTap: (val) {
          print(val);
        },
      ),
      loading: () => Container(),
      error: (_, __) => Container(),
    );
  }
  */

  Widget _buildFriends(BuildContext context, ScopedReader watch, Profile profile) {
    final friendsStream = watch(friendsStreamProvider);
    final profilesAtSchoolStream = watch(profilesAtSchoolStreamProvider(profile.schoolId));

    return friendsStream.when(
      data: (userInfo) => ProfileListTile(
        userInfo: userInfo,
        addFriend: () {
          print("addFriend");

          return profilesAtSchoolStream.when(
            data: (school) => showSearch(
              context: context,
              delegate: FriendSearchDelegate(school: school),
            ),
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
        onTap: (val) {
          print(val);
        },
      ),
      loading: () => Container(),
      error: (_, __) => Container(),
    );
  }
}
