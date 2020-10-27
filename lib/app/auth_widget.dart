import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/app/home/jobs/empty_content.dart';
import 'package:school_im/app/top_level_providers.dart';
import 'package:school_im/app/home/models/profile.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({
    Key key,
    @required this.profileBuilder,
    @required this.signedInBuilder,
    @required this.nonSignedInBuilder,
    @required this.waitingBuilder,
  }) : super(key: key);
  final WidgetBuilder nonSignedInBuilder;
  final WidgetBuilder signedInBuilder;
  final WidgetBuilder profileBuilder;
  final WidgetBuilder waitingBuilder;

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
    print("repassage");
    print("user ${user}");

    if (user == null) {
      print("on va retourner nonSignedInBuilder ");
      print(nonSignedInBuilder);
      return nonSignedInBuilder(context);
    }

    print("user non null1");
    final database = context.read(databaseProvider);
    print("user non null2");
    final Profile profile = await database.getorCreateProfile(user.uid, 'profile');
    print("user non null3");
    profile.stringify;
    print(profile);

    if (profile.isNewProfile()) {
      return profileBuilder(context);
    } else if (!profile.isValide()) {
      return waitingBuilder(context);
    } else {
      return signedInBuilder(context);
    }
  }
}
