import 'package:flutter/material.dart';
import 'package:school_im/common_widgets/custom_textfield.dart';
import 'package:school_im/common_widgets/custom_button.dart';
import 'package:school_im/app/home/profile/address_search.dart';
import 'package:school_im/app/home/models/school.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/routing/app_router.dart';

class SchoolProfilePage extends StatefulWidget {
  const SchoolProfilePage({@required this.profile});
  final Profile profile;

  @override
  _SchoolProfilePageState createState() => _SchoolProfilePageState();
}

class _SchoolProfilePageState extends State<SchoolProfilePage> {
  final myControllerEcole = TextEditingController();
  bool isEcoleOk = false;
  School school = null;

  @override
  void dispose() {
    myControllerEcole.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    myControllerEcole.addListener(_getNomValue);
  }

  _getNomValue() {
    setState(() {
      isEcoleOk = myControllerEcole.text.length >= 3;
    });
  }

  //https://data.education.gouv.fr/explore/dataset/fr-en-adresse-et-geolocalisation-etablissements-premier-et-second-degre/api/?disjunctive.nature_uai&disjunctive.nature_uai_libe&disjunctive.code_departement&disjunctive.code_region&disjunctive.code_academie&disjunctive.secteur_prive_code_type_contrat&disjunctive.secteur_prive_libelle_type_contrat&disjunctive.code_ministere&disjunctive.libelle_ministere&location=3,18.51593,-3.64035&basemap=jawg.streets&dataChart=eyJxdWVyaWVzIjpbeyJjb25maWciOnsiZGF0YXNldCI6ImZyLWVuLWFkcmVzc2UtZXQtZ2VvbG9jYWxpc2F0aW9uLWV0YWJsaXNzZW1lbnRzLXByZW1pZXItZXQtc2Vjb25kLWRlZ3JlIiwib3B0aW9ucyI6eyJkaXNqdW5jdGl2ZS5uYXR1cmVfdWFpIjp0cnVlLCJkaXNqdW5jdGl2ZS5uYXR1cmVfdWFpX2xpYmUiOnRydWUsImRpc2p1bmN0aXZlLmNvZGVfZGVwYXJ0ZW1lbnQiOnRydWUsImRpc2p1bmN0aXZlLmNvZGVfcmVnaW9uIjp0cnVlLCJkaXNqdW5jdGl2ZS5jb2RlX2FjYWRlbWllIjp0cnVlLCJkaXNqdW5jdGl2ZS5zZWN0ZXVyX3ByaXZlX2NvZGVfdHlwZV9jb250cmF0Ijp0cnVlLCJkaXNqdW5jdGl2ZS5zZWN0ZXVyX3ByaXZlX2xpYmVsbGVfdHlwZV9jb250cmF0Ijp0cnVlLCJkaXNqdW5jdGl2ZS5jb2RlX21pbmlzdGVyZSI6dHJ1ZSwiZGlzanVuY3RpdmUubGliZWxsZV9taW5pc3RlcmUiOnRydWV9fSwiY2hhcnRzIjpbeyJhbGlnbk1vbnRoIjp0cnVlLCJ0eXBlIjoibGluZSIsImZ1bmMiOiJBVkciLCJ5QXhpcyI6ImNvb3Jkb25uZWVfeCIsInNjaWVudGlmaWNEaXNwbGF5Ijp0cnVlLCJjb2xvciI6IiNBRjE5NzQifV0sInhBeGlzIjoiZGF0ZV9vdXZlcnR1cmUiLCJtYXhwb2ludHMiOiIiLCJ0aW1lc2NhbGUiOiJ5ZWFyIiwic29ydCI6IiJ9XSwiZGlzcGxheUxlZ2VuZCI6dHJ1ZSwiYWxpZ25Nb250aCI6dHJ1ZX0%3D

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(0xff9188E5),
        ),
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
                        const SizedBox(height: 20.0),
                        const Text('Super ! Dans quelle école est tu ?',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
                        const SizedBox(height: 40.0),
                        CustomTextField(
                          onTap: () async {
                            final School result = await showSearch(
                              context: context,
                              // we haven't created AddressSearch class
                              // this should be extending SearchDelegate
                              delegate: AddressSearch(),
                            );
                            if (result != null) {
                              setState(() {
                                school = result;
                                isEcoleOk = true;
                                myControllerEcole.text = result.appellation_officielle;
                              });
                            }
                          },
                          suffixIcon: isEcoleOk,
                          keyboardType: TextInputType.multiline,
                          inputFormatters: [],
                          hintText: 'Ecole la beouzo',
                          controller: myControllerEcole,
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
                    color: !isEcoleOk ? Colors.white.withAlpha(50) : const Color(0xffFFCA5D),
                    color2: !isEcoleOk ? const Color(0xff0D0A06).withAlpha(50) : const Color(0xff0D0A06),
                    label: 'Continuer',
                    onPressed: () async {
                      if (isEcoleOk) {
                        if (widget.profile.email != null) widget.profile.email = widget.profile.email;
                        widget.profile.schoolId = school.numero_uai;

                        await Navigator.of(context, rootNavigator: true).pushNamed(
                          AppRoutes.parentProfilePage,
                          arguments: {'profile': widget.profile, 'school': school},
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10.0),
                ])));
  }
}
