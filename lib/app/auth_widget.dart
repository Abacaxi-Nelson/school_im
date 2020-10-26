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
  }) : super(key: key);
  final WidgetBuilder nonSignedInBuilder;
  final WidgetBuilder signedInBuilder;
  final WidgetBuilder profileBuilder;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final authStateChanges = watch(authStateChangesProvider);
    return authStateChanges.when(
      data: (user) {
        return FutureBuilder(
            future: _data(context, user),
            //builder: (BuildContext context, AsyncSnapshot<Widget> widget) {
            builder: (context, snapshot) {
              //return widget.data;
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  //print('loading...');
                  return Container();
                  break;
                default:
                  if (snapshot.hasError) {
                    print('Error auth_widget: ${snapshot.error}');
                    return Container();
                  } else {
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
    if (user == null) {
      return nonSignedInBuilder(context);
    }
    final database = context.read(databaseProvider);
    final Profile profile = await database.getorCreateProfile(user.uid, 'profile');
    if (profile.isNewProfile()) {
      return profileBuilder(context);
    } else {
      return signedInBuilder(context);
    }
  }
}
