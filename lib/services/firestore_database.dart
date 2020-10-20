import 'dart:async';

import 'package:firestore_service/firestore_service.dart';
import 'package:meta/meta.dart';
import 'package:school_im/app/home/models/entry.dart';
import 'package:school_im/app/home/models/job.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/services/firestore_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_im/app/home/models/school.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null, 'Cannot create FirestoreDatabase with null uid');
  final String uid;

  final _service = FirestoreService.instance;

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
    print("debut friendsStream => ${FirestorePath.friends(uid)}");
    return _service.collectionStream(
      path: FirestorePath.friends(uid),
      builder: (data, documentId) => UserInfo.fromMap(data),
    );
  }

  Stream<School> ProfileBySchoolIdStream({String schoolId}) {
    return _service.documentStream<School>(
        path: FirestorePath.school(schoolId),
        builder: (data, documentID) {
          print("passage builder ");
          print(data);
          print(documentID);
          return School.fromMap(data);
        });
  }

  void findProfileBySchoolId(String schoolId) {
    print("findProfileBySchoolId");
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
    print('passage getProfile ${FirebaseFirestore.instance.collection(FirestorePath.profiles(uid))}');
    //final CollectionReference profile = FirebaseFirestore.instance.collection(FirestorePath.profiles(uid));
    final CollectionReference profile =
        FirebaseFirestore.instance.collection('/users/pSjOi9DKp0ZwSZevZmvdZUyi1SA3/profiles');
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
      final profile = Profile(userId: userId);
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
