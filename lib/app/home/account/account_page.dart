import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/app/top_level_providers.dart';
import 'package:school_im/common_widgets/avatar.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:school_im/constants/keys.dart';
import 'package:school_im/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';

class AccountPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context, FirebaseAuth firebaseAuth) async {
    try {
      print("signout");
      await firebaseAuth.signOut();
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: Strings.logoutFailed,
        exception: e,
      ));
    }
  }

  Future<void> _confirmSignOut(BuildContext context, FirebaseAuth firebaseAuth) async {
    final bool didRequestSignOut = await showAlertDialog(
          context: context,
          title: Strings.logout,
          content: Strings.logoutAreYouSure,
          cancelActionText: Strings.cancel,
          defaultActionText: Strings.logout,
        ) ??
        false;
    if (didRequestSignOut == true) {
      await _signOut(context, firebaseAuth);
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = context.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xff201F23), //change your color here
        ),
        /*
        actions: <Widget>[
          FlatButton(
            key: const Key(Keys.logout),
            child: const Icon(Icons.logout, color: Color(0xff201F23)),
            onPressed: () => _confirmSignOut(context, firebaseAuth),
          ),
        ],
        */
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130.0),
          child: _buildUserInfo(user),
        ),
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    return Column(
      children: [
        Avatar(
          photoUrl: user.photoURL,
          radius: 50,
          borderColor: Colors.black54,
          borderWidth: 2.0,
        ),
        const SizedBox(height: 8),
        if (user.displayName != null)
          Text(
            user.displayName,
            style: const TextStyle(),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
