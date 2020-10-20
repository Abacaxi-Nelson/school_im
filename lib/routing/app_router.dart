import 'package:email_password_sign_in_ui/email_password_sign_in_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_im/app/home/job_entries/entry_page.dart';
import 'package:school_im/app/home/jobs/edit_job_page.dart';
import 'package:school_im/app/home/models/entry.dart';
import 'package:school_im/app/home/models/job.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/app/home/models/school.dart';
import 'package:school_im/app/home/profile/school_profile.dart';
import 'package:school_im/app/home/profile/school_parent.dart';
import 'package:school_im/app/home/dashboard/dashboard_page.dart';

class AppRoutes {
  static const emailPasswordSignInPage = '/email-password-sign-in-page';
  static const editJobPage = '/edit-job-page';
  static const entryPage = '/entry-page';
  static const schoolProfilePage = '/school-profile-page';
  static const parentProfilePage = '/school-parent-page';
  static const dashboardPage = '/dashboard-page';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings, FirebaseAuth firebaseAuth) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.dashboardPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => DashboardPage(),
          settings: settings,
          fullscreenDialog: false,
        );
      case AppRoutes.parentProfilePage:
        final mapArgs = args as Map<String, dynamic>;
        final profile = mapArgs['profile'] as Profile;
        final school = mapArgs['school'] as School;
        return MaterialPageRoute<dynamic>(
          builder: (_) => ParentProfilePage(profile: profile, school: school),
          settings: settings,
          fullscreenDialog: false,
        );
      case AppRoutes.schoolProfilePage:
        final mapArgs = args as Map<String, dynamic>;
        final profile = mapArgs['profile'] as Profile;
        return MaterialPageRoute<dynamic>(
          builder: (_) => SchoolProfilePage(profile: profile),
          settings: settings,
          fullscreenDialog: false,
        );
      case AppRoutes.emailPasswordSignInPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EmailPasswordSignInPage.withFirebaseAuth(firebaseAuth, onSignedIn: args),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.editJobPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditJobPage(job: args),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.entryPage:
        final mapArgs = args as Map<String, dynamic>;
        final job = mapArgs['job'] as Job;
        final entry = mapArgs['entry'] as Entry;
        return MaterialPageRoute<dynamic>(
          builder: (_) => EntryPage(job: job, entry: entry),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
        // TODO: Throw
        return null;
    }
  }
}
