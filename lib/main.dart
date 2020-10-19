//import 'package:auth_widget_builder/auth_widget_builder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:school_im/app/auth_widget.dart';
import 'package:school_im/app/home/home_page.dart';
import 'package:school_im/app/top_level_providers.dart';
import 'package:school_im/app/sign_in/sign_in_page.dart';
import 'package:school_im/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/app/home/profile/init_profile.dart';
import 'package:school_im/app/home/dashboard/dashboard_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MultiProvider for top-level services that don't depend on any runtime values (e.g. uid)
    final firebaseAuth = context.read(firebaseAuthProvider);
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: AuthWidget(
        profileBuilder: (_) => InitProfilePage(),
        nonSignedInBuilder: (_) => SignInPage(),
        signedInBuilder: (_) => DashboardPage(), //HomePage(),
      ),
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings, firebaseAuth),
    );
  }
}
