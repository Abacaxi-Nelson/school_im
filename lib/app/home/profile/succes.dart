import 'package:flutter/material.dart';
import 'package:school_im/common_widgets/custom_textfield.dart';
import 'package:school_im/common_widgets/custom_button.dart';
import 'package:school_im/app/home/models/school.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/app/top_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/routing/app_router.dart';

class SuccesPage extends ConsumerWidget {
  AnimationController animationController;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final database = context.read(databaseProvider);
    final firebaseAuth = context.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser;

    return Scaffold(
        backgroundColor: const Color(0xff9188E5),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0), //const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20.0),
                const Text('Bientot ♥ !',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
                const SizedBox(height: 20.0),
                Text('Nous attendons encore que l\'un de vos parents se connecte ..',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 17.0, color: Colors.white.withOpacity(0.7))),
                const SizedBox(height: 30.0),
                IconAnimation(),
                const SizedBox(height: 30.0),
                CustomButton(
                  borderColor: Colors.transparent,
                  color: const Color(0xffFFCA5D),
                  color2: const Color(0xff0D0A06),
                  label: 'Relancer les invitations',
                  onPressed: () async {
                    print("press");
                  },
                ),
                const SizedBox(height: 10.0),
                CustomButton(
                  borderColor: Colors.transparent,
                  color: Colors.transparent,
                  color2: const Color(0xff0D0A06),
                  label: 'Hey c\'est ok, mes parents ont valide !',
                  onPressed: () async {
                    print("press ok");
                    Profile profile = await database.getProfile();
                    if (profile.isValide()) {
                      await Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.dashboardPage);
                    } else {
                      final snackBar = SnackBar(content: Text('Toujours en attente de validation'));
                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                  },
                ),
              ]),
        ));
  }
}

class IconAnimation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IconAnimationState();
}

class _IconAnimationState extends State<IconAnimation> with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )
      ..forward()
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(animationController.value), width: 10)),
              child: Icon(Icons.offline_bolt, size: 160, color: Color(0xffFFCA5D).withOpacity(0.8)));
          /*
          Container(
            decoration: ShapeDecoration(
              color: Colors.white.withOpacity(0.5),
              shape: CircleBorder(),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0 * animationController.value),
              child: child,
            ),
          );
          */
        });
  }
}
