import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:school_im/app/home/models/parent.dart';
import 'package:school_im/app/top_level_providers.dart';

class SignInViewModel with ChangeNotifier {
  SignInViewModel({@required this.auth});
  final FirebaseAuth auth;
  bool isLoading = false;
  dynamic error;

  Future<void> _signIn(Future<UserCredential> Function() signInMethod) async {
    try {
      isLoading = true;
      notifyListeners();
      await signInMethod();
      error = null;
    } catch (e) {
      error = e;
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInAnonymously() async {
    await _signIn(auth.signInAnonymously);
  }

  Future<void> signInGoogle() async {
    isLoading = true;
    notifyListeners();

    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      print('googleUser => ${googleUser}');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      print('googleAuth => ${googleAuth}');
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await auth.signInWithCredential(credential);
    } else {
      isLoading = false;
      notifyListeners();
      print('googleUser is null');
      throw PlatformException(
        code: 'ERROR_AUTHORIZATION_DENIED',
        message: 'googleUser is null',
      );
    }
  }

  Future<void> signInIos() async {
    isLoading = true;
    notifyListeners();
    // 1. perform the sign-in request
    const List<Scope> scopes = [Scope.email, Scope.fullName];
    final result = await AppleSignIn.performRequests([AppleIdRequest(requestedScopes: scopes)]);

    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
        );

        print("credentials");
        print(String.fromCharCodes(appleIdCredential.identityToken));
        print(String.fromCharCodes(appleIdCredential.authorizationCode));

        if (scopes.contains(Scope.fullName)) {
          print(appleIdCredential.email);
          print(appleIdCredential.fullName.givenName);
          print(appleIdCredential.fullName.familyName);
        }

        await auth.signInWithCredential(credential);

        // create profile

        //final authResult = await auth.signInWithCredential(credential);
        //final firebaseUser = authResult.user;

        //return firebaseUser;
        break;
      case AuthorizationStatus.error:
        isLoading = false;
        notifyListeners();

        print(result.error.toString());
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        isLoading = false;
        notifyListeners();

        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
    }
  }
}
