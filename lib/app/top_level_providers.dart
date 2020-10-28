import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:school_im/services/firestore_database.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/app/home/models/parent.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateChangesProvider = StreamProvider<User>((ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final parentProvider = FutureProvider<Parent>((ref) async {
  final auth = ref.watch(authStateChangesProvider);
  final db = ref.watch(databaseProvider);

  if (auth.data?.value?.uid != null) {
    return db.getParent();
  }
  return null;
});

final profileProvider = FutureProvider<Profile>((ref) async {
  final auth = ref.watch(authStateChangesProvider);
  final db = ref.watch(databaseProvider);

  print("CHANGEMENT ETAT profileProvider ");
  print("auth.data?.value?.uid ${auth.data?.value?.uid} ");

  if (auth.data?.value?.uid != null) {
    print("retourner NON  NULL ");
    return db.getProfileWithUserId(auth.data?.value?.uid);
  }
  print("retourner NULL ");
  return null;
  //return db.getProfile("pSjOi9DKp0ZwSZevZmvdZUyi1SA3");
});

final databaseProvider = Provider<FirestoreDatabase>((ref) {
  final auth = ref.watch(authStateChangesProvider);

  if (auth.data?.value?.uid != null) {
    return FirestoreDatabase(uid: auth.data?.value?.uid);
  }
  return null;
});

final loggerProvider = Provider<Logger>((ref) => Logger(
      printer: PrettyPrinter(
        methodCount: 1,
        printEmojis: false,
      ),
    ));
