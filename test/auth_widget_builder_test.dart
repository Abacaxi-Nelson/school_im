import 'dart:async';

import 'package:starter_architecture_flutter_firebase/app/auth_widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:starter_architecture_flutter_firebase/services/firebase_auth_service.dart';

import 'mocks.dart';

void main() {
  group('AuthWidgetBuilder tests', () {
    MockAuthService mockAuthService;
    MockDatabase mockDatabase;
    StreamController<User> onAuthStateChangedController;

    setUp(() {
      mockAuthService = MockAuthService();
      mockDatabase = MockDatabase();
      onAuthStateChangedController = StreamController<User>();
    });

    tearDown(() {
      mockAuthService = null;
      mockDatabase = null;
      onAuthStateChangedController.close();
    });

    void stubOnAuthStateChangedYields(Iterable<User> onAuthStateChanged) {
      onAuthStateChangedController
          .addStream(Stream<User>.fromIterable(onAuthStateChanged));
      when(mockAuthService.onAuthStateChanged).thenAnswer((_) {
        return onAuthStateChangedController.stream;
      });
    }

    Future<void> pumpAuthWidget(
        WidgetTester tester,
        {@required
            Widget Function(BuildContext, AsyncSnapshot<User>) builder}) async {
      await tester.pumpWidget(
        Provider<FirebaseAuthService>(
          create: (_) => mockAuthService,
          child: AuthWidgetBuilder(
            databaseBuilder: (_, uid) => mockDatabase,
            builder: builder,
          ),
        ),
      );
      await tester.pump(Duration.zero);
    }

    testWidgets(
        'WHEN onAuthStateChanged in waiting state'
        'THEN calls builder with snapshot in waiting state'
        'AND doesn\'t find MultiProvider', (tester) async {
      stubOnAuthStateChangedYields(<User>[]);

      final snapshots = <AsyncSnapshot<User>>[];
      await pumpAuthWidget(tester, builder: (context, userSnapshot) {
        snapshots.add(userSnapshot);
        return Container();
      });
      expect(snapshots, [
        const AsyncSnapshot<User>.withData(ConnectionState.waiting, null),
      ]);
      expect(find.byType(MultiProvider), findsNothing);
    });

    testWidgets(
        'WHEN onAuthStateChanged returns null user'
        'THEN calls builder with null user and active state'
        'AND doesn\'t find MultiProvider', (tester) async {
      stubOnAuthStateChangedYields(<User>[null]);

      final snapshots = <AsyncSnapshot<User>>[];
      await pumpAuthWidget(tester, builder: (context, userSnapshot) {
        snapshots.add(userSnapshot);
        return Container();
      });
      expect(snapshots, [
        const AsyncSnapshot<User>.withData(ConnectionState.waiting, null),
        const AsyncSnapshot<User>.withData(ConnectionState.active, null),
      ]);
      expect(find.byType(MultiProvider), findsNothing);
    });

    testWidgets(
        'WHEN onAuthStateChanged returns valid user'
        'THEN calls builder with same user and active state'
        'AND finds MultiProvider', (tester) async {
      const user = User(uid: '123');
      stubOnAuthStateChangedYields(<User>[user]);

      final snapshots = <AsyncSnapshot<User>>[];
      await pumpAuthWidget(tester, builder: (context, userSnapshot) {
        snapshots.add(userSnapshot);
        return Container();
      });
      expect(snapshots, [
        const AsyncSnapshot<User>.withData(ConnectionState.waiting, null),
        const AsyncSnapshot<User>.withData(ConnectionState.active, user),
      ]);
      expect(find.byType(MultiProvider), findsOneWidget);
    });
  });
}
