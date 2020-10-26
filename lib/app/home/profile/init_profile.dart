import 'package:flutter/material.dart';
import 'package:school_im/common_widgets/custom_textfield.dart';
import 'package:school_im/common_widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/services/firestore_database.dart';
import 'package:school_im/app/top_level_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/routing/app_router.dart';

class InitProfilePage extends StatefulWidget {
  @override
  _InitProfilePageState createState() => _InitProfilePageState();
}

class _InitProfilePageState extends State<InitProfilePage> {
  final myControllerNom = TextEditingController();
  final myControllerPrenom = TextEditingController();
  bool isPrenomOk = false;
  bool isNomOk = false;

  @override
  void dispose() {
    myControllerNom.dispose();
    myControllerPrenom.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    myControllerNom.addListener(_getNomValue);
    myControllerPrenom.addListener(_getPrenomValue);
  }

  void _getNomValue() {
    setState(() {
      isNomOk = myControllerNom.text.length >= 3;
    });
  }

  void _getPrenomValue() {
    setState(() {
      isPrenomOk = myControllerPrenom.text.length >= 3;
    });
  }

  Future<void> _submit() async {
    //final database = context.read(databaseProvider);
    final firebaseAuth = context.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser;
    final profile = Profile(
        photoUrl: user.photoURL != null ? user.photoURL : null,
        userId: user.uid,
        name: myControllerNom.text,
        surname: myControllerPrenom.text);
    //await database.setProfile(profile);
    //Navigator.of(context).pop();

    profile.stringify;

    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.schoolProfilePage,
      arguments: {'profile': profile},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xff9188E5),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), //const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0), //const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 100.0),
                        const Text('C\'est parti ! Comment est-ce que tu t\'appelles ?',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
                        const SizedBox(height: 20.0),
                        CustomTextField(
                          suffixIcon: isNomOk,
                          keyboardType: TextInputType.name,
                          inputFormatters: [],
                          hintText: "Julien",
                          controller: myControllerPrenom,
                        ),
                        const SizedBox(height: 5.0),
                        CustomTextField(
                          suffixIcon: isPrenomOk,
                          keyboardType: TextInputType.name,
                          inputFormatters: [],
                          hintText: "Dupuy",
                          controller: myControllerNom,
                        ),
                      ],
                    ),
                  )),
                  const Text(
                      'lorem ipsum; lorem ipsum  lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.0, color: Colors.white)),
                  const SizedBox(height: 20.0),
                  CustomButton(
                    borderColor: Colors.transparent,
                    color: !(isNomOk && isPrenomOk) ? Colors.white.withAlpha(50) : const Color(0xffFFCA5D),
                    color2: !(isNomOk && isPrenomOk) ? const Color(0xff0D0A06).withAlpha(50) : const Color(0xff0D0A06),
                    label: 'Continuer',
                    onPressed: () async {
                      if (isNomOk && isPrenomOk) {
                        await _submit();
                      }
                    },
                  ),
                  const SizedBox(height: 20.0),
                ])));
  }
}
