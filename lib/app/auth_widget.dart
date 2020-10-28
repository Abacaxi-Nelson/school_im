import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/app/home/jobs/empty_content.dart';
import 'package:school_im/app/top_level_providers.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/app/home/models/parent.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget(
      {Key key,
      @required this.profileBuilder,
      @required this.signedInBuilder,
      @required this.nonSignedInBuilder,
      @required this.waitingBuilder,
      @required this.signedInParentBuilder})
      : super(key: key);
  final WidgetBuilder nonSignedInBuilder;
  final WidgetBuilder signedInBuilder;
  final WidgetBuilder profileBuilder;
  final WidgetBuilder waitingBuilder;
  final WidgetBuilder signedInParentBuilder;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final authStateChanges = watch(authStateChangesProvider);

    return authStateChanges.when(
      data: (user) {
        print("CHANGEMENT ETAT");
        return FutureBuilder(
            future: _data(context, user),
            //builder: (BuildContext context, AsyncSnapshot<Widget> widget) {
            builder: (context, snapshot) {
              print("PASSAGE 1 => ${snapshot.connectionState}");
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  //print('loading...');
                  return Container();
                  break;
                default:
                  print("PASSAGE DEFAULT => ${snapshot.hasError}");
                  if (snapshot.hasError) {
                    print('Error auth_widget: ${snapshot.error}');
                    return Container();
                  } else {
                    print("PASSAGE DEFAULT 2 => ${snapshot.data}");
                    return snapshot.data;
                  }
              }
            });
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const Scaffold(
        body: EmptyContent(
          title: 'Something went wrong',
          message: 'Can\'t load data right now.',
        ),
      ),
    );
  }

  Future<Widget> _data(BuildContext context, User user) async {
    final database = context.read(databaseProvider);

    print("auth_widget repassage");
    print("auth_widget user ${user}");

    if (user == null) {
      print(" auth_widgeton va retourner nonSignedInBuilder ");
      print(nonSignedInBuilder);
      return nonSignedInBuilder(context);
    }

    // user is non null, check if parents
    // last step ? is parent or not
    print("auth_widget START PARENT");
    Parent parent = await database.searchParent(user.email);
    if (parent != null) {
      print(" auth_widget PARENT, parent => ${parent}");

      if (parent.validatedDate != null) {
        print("validatedDate is non null");
        return signedInParentBuilder(context);
      }

      parent.validatedDate = DateTime.now();
      parent.parentId = user.uid;
      await database.setParent(parent, parent.id);

      //validate the child
      print("tentative getProfile => <<${parent.id}>>");
      Profile p = await database.getProfileWithUserId(parent.id);
      print("profile => ${p}");
      p.valide = true;
      await database.setProfile(p, 'profile');

      FirebaseCrashlytics.instance.setUserIdentifier(parent.parentId);
      FirebaseCrashlytics.instance.setCustomKey('str_key', parent.toString());
      return signedInParentBuilder(context);
    }

    print("auth_widget user non null1");

    print("auth_widget user non null2");
    final Profile profile = await database.getorCreateProfile(user.uid, 'profile');
    print("auth_widget user non null3");
    profile.stringify;
    print(profile);

    FirebaseCrashlytics.instance.setUserIdentifier(profile.userId);
    FirebaseCrashlytics.instance.setCustomKey('str_key', profile.toString());

    if (profile.isNewProfile()) {
      return profileBuilder(context);
    } else if (!profile.isValide()) {
      return waitingBuilder(context);
    } else {
      return signedInBuilder(context);
    }
  }
}
