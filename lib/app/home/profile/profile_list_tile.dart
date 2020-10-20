import 'package:flutter/material.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/app/home/models/school.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/app/top_level_providers.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({Key key, @required this.userInfo, this.onTap, this.addFriend}) : super(key: key);
  final List<UserInfo> userInfo;
  final Function onTap;
  final Function addFriend;

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = context.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser;
    return ListView(scrollDirection: Axis.horizontal, shrinkWrap: true, children: <Widget>[
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: GestureDetector(
              onTap: () {
                addFriend();
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xffFFCA5D),
                child: CircleAvatar(
                  backgroundColor: Color(0xffFFCA5D),
                  radius: 30,
                  child: Icon(Icons.add, color: Color(0xff201F23), size: 30.0),
                ),
              ))),
      ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: userInfo.length,
        itemBuilder: (context, index) {
          return userInfo[index].id == user.uid
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        userInfo[index].photoUrl == null
                            ? GestureDetector(
                                onTap: () {
                                  onTap(userInfo[index].id);
                                },
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Color(0xff9188E5).withOpacity(0.5),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 30,
                                    child: Text(userInfo[index].surname[0].toUpperCase(),
                                        style: TextStyle(color: Color(0xff201F23), fontWeight: FontWeight.bold)),
                                  ),
                                ))
                            : GestureDetector(
                                onTap: () {
                                  onTap(userInfo[index].id);
                                },
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Color(0xffFDCF09),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(userInfo[index].photoUrl),
                                  ),
                                ),
                              ),
                        SizedBox(height: 5.0),
                        Text(
                          userInfo[index].surname,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
                            color: Colors.black,
                          ),
                        )
                      ]));
        },
      )
    ]);
  }
}
