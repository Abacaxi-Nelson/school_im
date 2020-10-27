import 'dart:async';

//import 'package:firestore_service/firestore_service.dart';
import 'package:meta/meta.dart';
import 'package:school_im/app/home/models/entry.dart';
import 'package:school_im/app/home/models/job.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/services/firestore_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_im/app/home/models/school.dart';
import 'package:school_im/app/home/models/group.dart';
import 'package:school_im/app/home/models/message.dart';
import 'package:school_im/services/firestore_service.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null, 'Cannot create FirestoreDatabase with null uid');
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> setMessage(Group group, Message message) {
    print("setMessage  ${FirestorePath.message(group.id, message.id)}");
    print("setMessage ${message.toMap()}");
    return _service.setData(
      path: FirestorePath.message(group.id, message.id),
      data: message.toMap(),
    );
  }

  Stream<List<Message>> chatStream(Group group) {
    print("chatStream 1 ${group}");
    print("chatStream 2 ${FirestorePath.messages(group.id)}");
    return _service.collectionStream(
        path: FirestorePath.messages(group.id),
        builder: (data, documentId) => Message.fromMap(data, documentId),
        sort: (lhs, rhs) => lhs.createdDate.compareTo(rhs.createdDate),
        limit: 50);
  }

  Stream<List<Group>> groupsStream() {
    print("PASSAGE groupsStream");
    List<String> lst = new List();
    lst.add(uid);

    return _service.collectionStream(
      path: FirestorePath.groups(),
      builder: (data, documentId) => Group.fromMap(data, documentId),
      queryBuilder: (query) => query.where('members', arrayContainsAny: lst),
      sort: (lhs, rhs) => rhs.modifiedDate.compareTo(lhs.modifiedDate),
    );
  }

  Future<void> setGroup(Group group) {
    print("setRequest ${FirestorePath.group(group.id)}");
    print("setRequest ${group.toMap()}");
    return _service.setData(
      path: FirestorePath.group(group.id),
      data: group.toMap(),
    );
  }

  Future<Group> getGroupOrCreateIt(Profile profile, UserInfo friend) async {
    print("getGroup");

    CollectionReference groupCol = FirebaseFirestore.instance.collection(FirestorePath.groups());

    List<String> lst = new List();
    lst.add(profile.userId);
    lst.add(friend.id);
    QuerySnapshot querySnapshot = await groupCol.where('members', arrayContainsAny: lst).get();

    print("querySnapshot.docs => ${querySnapshot.docs.length}");

    if (querySnapshot.docs.length > 0) {
      return Group.fromMap(querySnapshot.docs[0].data(), querySnapshot.docs[0].id);
    } else {
      print("create group");
      Group group = Group(
          modifiedDate: DateTime.now(),
          createdDate: DateTime.now(),
          createdBy: profile.userId,
          id: documentIdFromCurrentDate(),
          members: [profile.userId, friend.id],
          membersWithInfo: [profile.toUserInfo(), friend]);
      await setGroup(group);
      return group;
    }
  }

  //// REQUEST FRIEND
  Stream<List<UserInfo>> friendRequestsStream() => _service.collectionStream(
        path: FirestorePath.requests(uid),
        builder: (data, documentId) => UserInfo.fromMap(data),
      );

  Future<void> setFriend(String userToBecomeFriend, UserInfo myUserInfo) {
    print("setFriend ${FirestorePath.requests(uid)}");
    print("setFriend ${myUserInfo.toMap()}");
    return _service.setData(
      path: FirestorePath.friend(userToBecomeFriend, myUserInfo.id),
      data: myUserInfo.toMap(),
    );
  }

  Future<void> deleteRequest(UserInfo userInfo) async {
    await _service.deleteData(path: FirestorePath.request(uid, userInfo.id));
  }

  Future<void> setRequest(String userToBecomeFriend, UserInfo myUserInfo) {
    print("setRequest ${FirestorePath.requests(uid)}");
    print("setRequest ${myUserInfo.toMap()}");
    return _service.setData(
      path: FirestorePath.request(userToBecomeFriend, myUserInfo.id),
      data: myUserInfo.toMap(),
    );
  }

  //////////// SCHOOL
  Future<void> setSchool(School school) => _service.setData(
        path: FirestorePath.school(school.numero_uai),
        data: school.toMap(),
      );

  Future<School> getSchoolOrCreate(School school) async {
    CollectionReference schoolCol = FirebaseFirestore.instance.collection(FirestorePath.schools());
    final DocumentSnapshot datasnapshot = await schoolCol.doc(school.numero_uai).get();

    if (!datasnapshot.exists) {
      await setSchool(school);
      return school;
    } else {
      return School.fromMap(datasnapshot.data());
    }
  }

  ///

  //////////// PROFILE
  Stream<List<UserInfo>> friendsStream() {
    return _service.collectionStream(
      path: FirestorePath.friends(uid),
      builder: (data, documentId) => UserInfo.fromMap(data),
    );
  }

  Future<List<String>> getBlokedIDProfile() async {
    CollectionReference requests = FirebaseFirestore.instance.collection(FirestorePath.blokeds(uid));
    QuerySnapshot querySnapshot = await requests.get();
    List<String> list = new List<String>();
    querySnapshot.docs.forEach((result) {
      list.add(result.data()['id']);
    });
    return list;
  }

  Future<List<UserInfo>> getBlokedProfile() async {
    CollectionReference requests = FirebaseFirestore.instance.collection(FirestorePath.blokeds(uid));
    QuerySnapshot querySnapshot = await requests.get();
    List<UserInfo> list = new List<UserInfo>();
    querySnapshot.docs.forEach((result) {
      list.add(UserInfo.fromMap(result.data()));
    });
    return list;
  }

  Future<List<String>> getRequestIDProfile() async {
    CollectionReference requests = FirebaseFirestore.instance.collection(FirestorePath.requests(uid));
    QuerySnapshot querySnapshot = await requests.get();
    List<String> list = new List<String>();
    querySnapshot.docs.forEach((result) {
      list.add(result.data()['id']);
    });
    return list;
  }

  Future<List<UserInfo>> getRequestProfile() async {
    CollectionReference requests = FirebaseFirestore.instance.collection(FirestorePath.requests(uid));
    QuerySnapshot querySnapshot = await requests.get();
    List<UserInfo> list = new List<UserInfo>();
    querySnapshot.docs.forEach((result) {
      list.add(UserInfo.fromMap(result.data()));
    });
    return list;
  }

  Future<List<UserInfo>> getFriendProfile() async {
    CollectionReference requests = FirebaseFirestore.instance.collection(FirestorePath.friends(uid));
    QuerySnapshot querySnapshot = await requests.get();
    List<UserInfo> list = new List<UserInfo>();
    querySnapshot.docs.forEach((result) {
      list.add(UserInfo.fromMap(result.data()));
    });
    return list;
  }

  Stream<School> ProfileBySchoolIdStream({String schoolId}) {
    return _service.documentStream<School>(
        path: FirestorePath.school(schoolId),
        builder: (data, documentID) {
          return School.fromMap(data);
        });
  }

  void findProfileBySchoolId(String schoolId) {
    CollectionReference users = FirebaseFirestore.instance.collection(FirestorePath.users());
    users.where('schoolId', isEqualTo: schoolId).get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
      });
    });
  }

  Future<void> setProfile(Profile profile, String type) => _service.setData(
        path: FirestorePath.profile(uid, type),
        data: profile.toMap(),
      );

  Future<Profile> getProfile(String userId) async {
    final CollectionReference profile = FirebaseFirestore.instance.collection(FirestorePath.profiles(uid));
    //final CollectionReference profile =
    //    FirebaseFirestore.instance.collection('/users/pSjOi9DKp0ZwSZevZmvdZUyi1SA3/profiles');
    final DocumentSnapshot datasnapshot = await profile.doc('profile').get();
    if (datasnapshot.exists) {
      return Profile.fromMap(datasnapshot.data());
    } else {
      return null;
    }
  }

  Future<Profile> getorCreateProfile(String userId, String type) async {
    CollectionReference profile = FirebaseFirestore.instance.collection(FirestorePath.profiles(uid));
    final DocumentSnapshot datasnapshot = await profile.doc('profile').get();
    if (!datasnapshot.exists) {
      final profile = Profile(userId: userId, valide: false);
      await setProfile(profile, 'profile');
      return profile;
    } else {
      return Profile.fromMap(datasnapshot.data());
    }
  }

  ///END

  Future<void> setJob(Job job) => _service.setData(
        path: FirestorePath.job(uid, job.id),
        data: job.toMap(),
      );

  Future<void> deleteJob(Job job) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(job: job).first;
    for (final entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(path: FirestorePath.job(uid, job.id));
  }

  Stream<Job> jobStream({@required String jobId}) => _service.documentStream(
        path: FirestorePath.job(uid, jobId),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: FirestorePath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  Future<void> setEntry(Entry entry) => _service.setData(
        path: FirestorePath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  Future<void> deleteEntry(Entry entry) => _service.deleteData(path: FirestorePath.entry(uid, entry.id));

  Stream<List<Entry>> entriesStream({Job job}) => _service.collectionStream<Entry>(
        path: FirestorePath.entries(uid),
        queryBuilder: job != null ? (query) => query.where('jobId', isEqualTo: job.id) : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
