import 'package:flutter/material.dart';
import 'package:school_im/common_widgets/custom_textfield.dart';
import 'package:school_im/common_widgets/custom_button.dart';
import 'package:school_im/app/home/models/school.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/app/top_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/routing/app_router.dart';

class ParentProfileLastPage extends StatefulWidget {
  const ParentProfileLastPage({@required this.profile, @required this.school});
  final Profile profile;
  final School school;

  @override
  _ParentProfileLastPageState createState() => _ParentProfileLastPageState();
}

class _ParentProfileLastPageState extends State<ParentProfileLastPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(0xff9188E5),
        ),
        backgroundColor: const Color(0xff9188E5),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), //const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0), //const EdgeInsets.all(16.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                const SizedBox(height: 20.0),
                                const Text('Bientot Fini ! ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
                                const SizedBox(height: 20.0),
                                Text('Demande a un de tes parents de t\'accompagner dans la derniere etape !',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17.0,
                                        color: Colors.white.withOpacity(0.7))),
                                const SizedBox(height: 30.0),
                                Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 10)),
                                    child: Icon(Icons.supervised_user_circle,
                                        size: 160, color: Color(0xffFFCA5D).withOpacity(0.8))),
                                const SizedBox(height: 30.0),
                                Text(
                                    'Parent, renseignez vos coordonnées afin d\'accéder à l\'ensemble de l\'application !',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15.0,
                                        color: Colors.white.withOpacity(0.7))),
                              ]))),
                  CustomButton(
                    borderColor: Colors.transparent,
                    color: const Color(0xffFFCA5D),
                    color2: const Color(0xff0D0A06),
                    label: 'Continuer',
                    onPressed: () async {
                      await Navigator.of(context, rootNavigator: true).pushNamed(
                        AppRoutes.parentProfilePage,
                        arguments: {'profile': widget.profile, 'school': widget.school},
                      );
                    },
                  ),
                  const SizedBox(height: 10.0),
                ])));
  }
}
