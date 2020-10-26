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
import 'package:school_im/app/home/profile/school_parent_last.dart';
import 'package:school_im/app/home/dashboard/dashboard_page.dart';
import 'package:school_im/app/home/notification/notification_friend.dart';
import 'package:school_im/app/home/chat/chat.dart';
import 'package:school_im/app/home/models/group.dart';
import 'package:school_im/app/home/profile/succes.dart';

class AppRoutes {
  static const emailPasswordSignInPage = '/email-password-sign-in-page';
  static const editJobPage = '/edit-job-page';
  static const entryPage = '/entry-page';
  static const schoolProfilePage = '/school-profile-page';
  static const parentProfilePage = '/school-parent-page';
  static const parentProfileLastPage = '/school-parent-last-page';
  static const dashboardPage = '/dashboard-page';
  static const notificationFriendPage = '/notification-friend-page';
  static const chatPage = '/chat-page';
  static const succesPage = '/succes-page';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings, FirebaseAuth firebaseAuth) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.succesPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SuccesPage(),
          settings: settings,
          fullscreenDialog: false,
        );
      case AppRoutes.chatPage:
        final mapArgs = args as Map<String, dynamic>;
        final group = mapArgs['group'] as Group;
        final profile = mapArgs['profile'] as Profile;
        return MaterialPageRoute<dynamic>(
          builder: (_) => ChatPage(profile: profile, group: group),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.notificationFriendPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => NotificationFriendPage(),
          settings: settings,
          fullscreenDialog: false,
        );
      case AppRoutes.dashboardPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => DashboardPage(),
          settings: settings,
          fullscreenDialog: false,
        );
      case AppRoutes.parentProfileLastPage:
        final mapArgs = args as Map<String, dynamic>;
        final profile = mapArgs['profile'] as Profile;
        final school = mapArgs['school'] as School;
        return MaterialPageRoute<dynamic>(
          builder: (_) => ParentProfileLastPage(profile: profile, school: school),
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
