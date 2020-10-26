import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/app/home/models/school.dart';
import 'package:school_im/app/top_level_providers.dart';
import 'package:school_im/app/home/models/profile.dart';

enum Type { demande, bloque, amis }

class NotificationFriendPage extends StatefulWidget {
  //const NotificationFriendPage({@required this.requests});
  @override
  State<StatefulWidget> createState() => _NotificationFriendPageState();
}

class _NotificationFriendPageState extends State<NotificationFriendPage> {
  Profile profile = null;
  List<UserInfo> requests = new List<UserInfo>();
  List<UserInfo> friends = new List<UserInfo>();
  List<UserInfo> blokeds = new List<UserInfo>();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    print("initState ");
    init();
  }

  void init() async {
    print("start ");
    final firebaseAuth = context.read(firebaseAuthProvider);
    final database = context.read(databaseProvider);
    final user = firebaseAuth.currentUser;
    blokeds = await database.getBlokedProfile();
    requests = await database.getRequestProfile();
    friends = await database.getFriendProfile();
    profile = await database.getProfile(user.uid);
    print("end ${profile} ");
    print("===========");
    print("${friends}");
    setState(() {
      blokeds = blokeds;
      requests = requests;
      friends = friends;
      profile = profile;
      loading = false;
    });
  }

  List<Widget> getBlock(List<UserInfo> data, String label, Type type) {
    if (data.isEmpty) return [Container()];

    List<Widget> list = new List<Widget>();
    list.add(Text(label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)));
    list.add(const SizedBox(height: 20.0));
    list.add(Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: Colors.black,
        ),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return getTile(data[index], type);
        },
      ),
    ));
    list.add(const SizedBox(height: 30));
    return list;
  }

  Widget getTile(UserInfo data, Type type) {
    final database = context.read(databaseProvider);
    final firebaseAuth = context.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser;

    return ListTile(
      contentPadding: EdgeInsets.all(0),
      dense: true,
      //tileColor: Colors.white,
      leading: data.photoUrl != null
          ? CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(data.photoUrl),
              backgroundColor: Colors.transparent,
            )
          : CircleAvatar(
              radius: 30.0,
              child: Text(data.surname.toUpperCase()[0]),
              backgroundColor: Color(0xff9188E5),
            ),
      title: Text('${data.surname} ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
      subtitle: Text('${data.name}', style: const TextStyle(fontSize: 14.0)),
      trailing: type == Type.demande
          ? Wrap(
              spacing: 12, // space between two icons
              children: <Widget>[
                IconButton(
                  iconSize: 35.0,
                  color: Colors.red,
                  icon: const Icon(Icons.close),
                  onPressed: () {},
                ), // icon-1
                IconButton(
                  iconSize: 35.0,
                  color: Colors.green,
                  icon: const Icon(Icons.check_circle),
                  onPressed: () async {
                    print('datta -> ${data}');
                    UserInfo myUserInfo = profile.toUserInfo();
                    print('myUserInfo -> ${myUserInfo}');
                    await database.setFriend(user.uid, data);
                    print("end1");
                    await database.setFriend(data.id, myUserInfo);
                    await database.deleteRequest(data);
                    print("end2");
                    init();
                  },
                  splashColor: Colors.blue,
                ), // icon-2
              ],
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xffF0F1F4),
      appBar: AppBar(
        //backgroundColor: Color(0xffF0F1F4),
        elevation: 0.0,
        title: const Text(
          'Amis',
          style: TextStyle(
              fontSize: 22.0,
              color: Color(0xff201F23),
              fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          FlatButton(
            child:
                const Icon(Icons.close, size: 30.0, color: Color(0xff201F23)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ...getBlock(requests, 'Demandes', Type.demande),
                    ...getBlock(blokeds, 'Bloques', Type.bloque),
                    ...getBlock(friends, 'Amis', Type.amis),
                  ],
                ),
              ),
            ),
    );
  }
}
