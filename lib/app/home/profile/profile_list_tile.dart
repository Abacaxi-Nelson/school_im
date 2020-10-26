import 'package:flutter/material.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/app/home/models/school.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/app/top_level_providers.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile(
      {Key key, @required this.userInfo, this.onTap, this.addFriend})
      : super(key: key);
  final List<UserInfo> userInfo;
  final Function onTap;
  final Function addFriend;

  Widget getAvatar(bool isAdd, UserInfo userInfo, String name, String photoUrl,
      BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    isAdd ? addFriend() : onTap(userInfo);
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xff9188E5),
                    child: CircleAvatar(
                      backgroundColor: Color(0xff9188E5),
                      radius: isAdd ? 25 : 30,
                      backgroundImage: isAdd
                          ? null
                          : photoUrl == null
                              ? null
                              : NetworkImage(photoUrl),
                      child: isAdd
                          ? Icon(Icons.person_add,
                              color: Color(0xFFffca5d), size: 30.0)
                          : photoUrl == null
                              ? Text(userInfo.surname.toUpperCase()[0])
                              : Container(),
                    ),
                  )),
              const SizedBox(height: 10.0),
              Text(
                isAdd ? 'Ajouter' : name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10.0,
                  color: Colors.black,
                ),
              ),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = context.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser;
    return ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: <Widget>[
          getAvatar(true, null, null, null, context),
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: userInfo.length,
            itemBuilder: (context, index) {
              return userInfo[index].id == user.uid
                  ? Container()
                  : getAvatar(false, userInfo[index], userInfo[index].surname,
                      userInfo[index].photoUrl, context);
            },
          )
        ]);
  }
}
