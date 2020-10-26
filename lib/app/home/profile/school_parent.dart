import 'package:flutter/material.dart';
import 'package:school_im/common_widgets/custom_textfield.dart';
import 'package:school_im/common_widgets/custom_button.dart';
import 'package:school_im/app/home/models/school.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/app/top_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/routing/app_router.dart';
import 'package:school_im/app/home/profile/succes.dart';

class ParentProfilePage extends StatefulWidget {
  const ParentProfilePage({@required this.profile, @required this.school});
  final Profile profile;
  final School school;

  @override
  _ParentProfilePageState createState() => _ParentProfilePageState();
}

class _ParentProfilePageState extends State<ParentProfilePage> {
  final myControllerTel = TextEditingController();
  bool isTelOk = false;
  final myControllerEmail = TextEditingController();
  bool isEmailOk = false;

  @override
  void dispose() {
    myControllerTel.dispose();
    myControllerEmail.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    myControllerTel.addListener(_getTelValue);
    myControllerEmail.addListener(_getEmailValue);
  }

  void _getTelValue() {
    setState(() {
      isTelOk = myControllerTel.text.length == 10;
    });
  }

  void _getEmailValue() {
    setState(() {
      isEmailOk = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(myControllerEmail.text);
    });
  }

  Future<void> _submit() async {
    widget.profile.phoneParent = myControllerTel.text;
    widget.profile.emailParent = myControllerEmail.text;

    widget.profile.stringify;

    final database = context.read(databaseProvider);
    widget.profile.schoolId = widget.school.numero_uai;
    await database.setProfile(widget.profile, 'profile');

    print("Dans school_parent, school recu : ");
    widget.school.stringify;

    print("Dans school_parent, school demande : ");
    School sc = await database.getSchoolOrCreate(widget.school);
    sc.stringify;

    UserInfo userInfo = UserInfo(
        name: widget.profile.name,
        surname: widget.profile.surname,
        photoUrl: widget.profile.photoUrl,
        id: widget.profile.userId);
    sc.addMember(userInfo);
    sc.stringify;
    await database.setSchool(sc);

    //await database.setProfileSchool(widget.profile, widget.suggestion);
    //await database.setProfileChat(widget.profile, widget.suggestion);
    // Check if chat exists, or create it

    //go to dashboard !!!! tranks to auth change ?
    //await Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.dashboardPage);
    await Navigator.of(context, rootNavigator: true).pushReplacementNamed(AppRoutes.succesPage);

    /*
    //final database = context.read(databaseProvider);
    final firebaseAuth = context.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser;
    final profile = Profile(userId: user.uid, name: myControllerNom.text, surname: myControllerPrenom.text);
    //await database.setProfile(profile);
    //Navigator.of(context).pop();

    profile.stringify;

    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.schoolProfilePage,
      arguments: {'profile': profile},
    );
    */
  }

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
                    padding: const EdgeInsets.symmetric(horizontal: 30.0), //const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 20.0),
                        const Text('Bientot Fini ! Demandez a un de vos parents de saisir les infos suivantes',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
                        const SizedBox(height: 40.0),
                        CustomTextField(
                          suffixIcon: isEmailOk,
                          keyboardType: TextInputType.emailAddress,
                          inputFormatters: [],
                          hintText: "Email d\'un de vos parents",
                          controller: myControllerEmail,
                        ),
                        const SizedBox(height: 40.0),
                        CustomTextField(
                          suffixIcon: isTelOk,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [],
                          hintText: "Telephone d\'un de vos parents",
                          controller: myControllerTel,
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
                    color: !(isTelOk && isEmailOk) ? Colors.white.withAlpha(50) : const Color(0xffFFCA5D),
                    color2: !(isTelOk && isEmailOk) ? const Color(0xff0D0A06).withAlpha(50) : const Color(0xff0D0A06),
                    label: 'Continuer',
                    onPressed: () async {
                      if (isTelOk && isEmailOk) {
                        _submit();
                      }
                    },
                  ),
                  const SizedBox(height: 10.0),
                ])));
  }
}
