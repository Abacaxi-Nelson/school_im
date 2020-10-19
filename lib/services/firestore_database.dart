import 'dart:async';

import 'package:firestore_service/firestore_service.dart';
import 'package:meta/meta.dart';
import 'package:school_im/app/home/models/entry.dart';
import 'package:school_im/app/home/models/job.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/services/firestore_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_im/app/home/models/suggestion.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null, 'Cannot create FirestoreDatabase with null uid');
  final String uid;

  final _service = FirestoreService.instance;

  //////////// CHAT
  Future<Profile> getorCreateChat(String schoolId, String type) async {}

  ///

  //////////// PROFILE
  Future<void> setProfileSchool(Profile profile, Suggestion suggestion) => _service.setData(
        path: FirestorePath.profile(uid, 'school'),
        data: suggestion.toMap(),
      );

  Future<void> setProfile(Profile profile, String type) => _service.setData(
        path: FirestorePath.profile(uid, type),
        data: profile.toMap(),
      );

  Future<Profile> getorCreateProfile(String userId, String type) async {
    print("1.1");
    print(FirestorePath.profiles(uid));
    CollectionReference profile = FirebaseFirestore.instance.collection(FirestorePath.profiles(uid));
    print("1.11");
    final DocumentSnapshot datasnapshot = await profile.doc('profile').get();
    print("2.1");
    if (!datasnapshot.exists) {
      print("3.1");
      final profile = Profile(userId: userId);
      await setProfile(profile, 'profile');
      print("4.1");
      return profile;
    } else {
      print("5.1");
      return Profile.fromMap(datasnapshot.data());
    }
    print("6.1");
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
