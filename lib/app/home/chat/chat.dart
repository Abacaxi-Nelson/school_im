import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/app/top_level_providers.dart';
import 'package:school_im/constants/strings.dart';
import 'package:pedantic/pedantic.dart';
import 'package:school_im/app/home/models/message.dart';
import 'package:school_im/app/home/models/group.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/app/home/jobs/empty_content.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:school_im/services/firestore_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

final chatStreamProvider = StreamProvider.autoDispose.family<List<Message>, Group>((ref, group) {
  final database = ref.watch(databaseProvider);
  return database?.chatStream(group) ?? const Stream.empty();
});

class ChatPage extends StatefulWidget {
  const ChatPage({@required this.profile, @required this.group});
  final Profile profile;
  final Group group;

  @override
  _ChatPageState createState() => _ChatPageState();
}

// watch database
class _ChatPageState extends State<ChatPage> {
//class ChatPage extends ConsumerWidget {
  //ChatPage({@required this.profile, @required this.group});
  //final Profile profile;
  //final Group group;
  final picker = ImagePicker();
  FirestoreDatabase database;
  bool showProgress = false;

  Widget showTitle(BuildContext context) {
    final database = context.read(databaseProvider);
    final firebaseAuth = context.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser;

    String fiendId = "";
    for (final id in widget.group.members) {
      if (id != user.uid) {
        fiendId = id;
        break;
      }
    }

    if (fiendId == "") return Text("No NAME");

    return FutureBuilder(
        future: database.getProfile(fiendId),
        builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container();
              break;
            default:
              if (snapshot.hasError) {
                print('Error auth_widget: ${snapshot.error}');
                return Container();
              } else {
                print(snapshot.data);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    snapshot.data.photoUrl == null
                        ? Container()
                        : CircleAvatar(
                            radius: 13.0,
                            backgroundImage: NetworkImage(snapshot.data.photoUrl),
                            backgroundColor: Colors.transparent,
                          ),
                    SizedBox(width: 10.0),
                    Text(
                      snapshot.data.surname,
                      style: const TextStyle(fontSize: 16.0, color: Color(0xff201F23), fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    //Widget build(BuildContext context, ScopedReader watch) {
    database = context.read(databaseProvider);

    return Scaffold(
        //backgroundColor: Colors.red,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: showTitle(context),
          actions: <Widget>[
            FlatButton(
              child: const Icon(Icons.more_horiz, size: 30.0, color: Color(0xff201F23)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 2.0, color: Color(0xffEEEEEE))),
            image: const DecorationImage(
              image: const AssetImage("bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: showProgress
              ? const Center(child: CircularProgressIndicator())
              : Consumer(
                  builder: (context, watch, child) {
                    return _buildContents(context, watch);
                  },
                ),
          //_buildContents(context, watch),
        ));
  }

  void onSend(ChatMessage message) async {
    print("///////////////// passage onSend");
    print(message.toJson());
    print(message.user.name);

    Message mess = new Message(
        text: message.text,
        id: message.id,
        createdDate: message.createdAt,
        createdByName: message.user.name,
        createdBy: message.user.uid);

    await database.setMessage(widget.group, mess);

    print("update group");
    widget.group.last = mess.toMessageWithoutId();
    print(widget.group.last);

    if (widget.group.unread == null) widget.group.unread = List<String>();
    widget.group.membersWithInfo.forEach((profile) {
      if (profile.id != message.user.uid) widget.group.unread.add(profile.id);
    });

    await database.setGroup(widget.group);
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final chatStream = watch(chatStreamProvider(widget.group));
    final database = context.read(databaseProvider);

    print("passage _buildContents");
    return chatStream.when(
        data: (items) => _buildChat(widget.profile, widget.group, items, context),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          print(error);
          print(stack);
          return const EmptyContent(
            title: 'Something went wrong',
            message: 'Can\'t load items right now',
          );
        });
  }

  Widget _buildChat(Profile profile, Group group, List<Message> messages, BuildContext context) {
    ChatUser chatUser =
        ChatUser(uid: profile.userId, name: profile.surname, firstName: profile.name, lastName: profile.surname);
    return DashChat(
      //messagePadding: EdgeInsets.all(10.0),
      messageDecorationBuilder: (ChatMessage msg, bool isUser) {
        return BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: isUser ? Color(0xff9188E5) : Color(0xffFFFFFF), // example
        );
      },
      dateBuilder: (dateAsText) {
        return Container(
          padding: EdgeInsets.all(15.0),
          //decoration: BoxDecoration(
          //border: Border.all(width: 1.0, color: CupertinoColors.lightBackgroundGray),
          //  color: Colors.green,
          //),
          child: Text(
            dateAsText,
            style: const TextStyle(fontSize: 14.0, color: Colors.black),
          ),
        );
      },
      inputMaxLines: 5,
      dateFormat: DateFormat('dd MMMM yyyy'),
      timeFormat: DateFormat('HH:mm'),
      shouldShowLoadEarlier: true,
      onLoadEarlier: () async {
        print("onLoadEarlier");
      },
      onSend: onSend,
      /*chat.sendTextMessage(message: _.text)*/
      textInputAction: TextInputAction.send,
      inputDecoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: "Ton message ici..",
          hintStyle: TextStyle(color: Colors.white)
          //fillColor: Color(0xffEEEEEE),
          //filled: true,dfgdfg
          //contentPadding: EdgeInsets.all(10.0),
          ),
      inputContainerStyle: BoxDecoration(
        //border: Border.all(width: 1.0, color: CupertinoColors.lightBackgroundGray),
        color: Color(0xff201F23),
      ),
      user: chatUser,
      inputTextStyle: TextStyle(fontSize: 16.0, color: Colors.white),
      //inputContainerStyle: BoxDecoration(
      //  border: Border(top: BorderSide(color: Colors.black)),
      //  color: Colors.blue,
      //),
      showTraillingBeforeSend: true,
      messageContainerPadding: EdgeInsets.all(20.0),
      leading: <Widget>[
        IconButton(
            icon: Icon(Icons.image, color: Theme.of(context).accentColor),
            onPressed: () async {
              setState(() {
                showProgress = true;
              });

              print("start uploading");
              final image = await picker.getImage(source: ImageSource.gallery);
              if (image != null) {
                print("image is not null");
                final compressedFile = await FlutterNativeImage.compressImage(image.path, quality: 80, percentage: 90);
                print(image);
                print(compressedFile);
                final StorageReference storageRef =
                    FirebaseStorage.instance.ref().child(DateTime.now().toIso8601String());
                StorageUploadTask uploadTask = storageRef.putFile(
                  compressedFile,
                  StorageMetadata(
                    contentType: 'image/jpg',
                  ),
                );
                StorageTaskSnapshot download = await uploadTask.onComplete;
                print("download done");

                String url = await download.ref.getDownloadURL();
                print("url ${url}");

                ChatMessage message = ChatMessage(text: "", user: chatUser, image: url);

                Message mess = new Message(
                    text: "",
                    id: message.id,
                    createdDate: DateTime.now(),
                    createdByName: profile.surname,
                    createdBy: profile.userId,
                    image: url);

                print("on va envoyer");
                await database.setMessage(group, mess);
                setState(() {
                  showProgress = false;
                });
              }
            }),
      ],
      sendButtonBuilder: (func) => Row(
        children: [
          IconButton(icon: Icon(Icons.send, color: Color(0xff9188E5)), onPressed: () => func()),
        ],
      ),
      messages: messages
          .map(
            (e) => ChatMessage(
              id: e.id,
              text: e.text,
              image: e.image,
              createdAt: e.createdDate,
              user: ChatUser(uid: e.createdBy, name: e.createdByName),
              //user: ChatUser(uid: e.from, name: e.fromName),
            ),
          )
          .toList(),
    );
  }
}
