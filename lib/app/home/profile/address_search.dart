import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_im/app/home/models/school.dart';
import 'dart:convert';
import 'package:school_im/app/home/jobs/empty_content.dart';

class AddressSearch extends SearchDelegate<School> {
  AddressSearch()
      : super(
          searchFieldLabel: 'Recherche',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  String get searchFieldLabel => 'Recherche';

  @override
  TextStyle get searchFieldStyle => TextStyle(color: Colors.white);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Color(0xff9188E5),
      textTheme: TextTheme(headline6: TextStyle(color: Colors.white)),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  Future<List<School>> fetchSuggestions(String input) async {
    final response = await http.get(
        'https://data.education.gouv.fr/api/records/1.0/search/?dataset=fr-en-adresse-et-geolocalisation-etablissements-premier-et-second-degre&q=(nature_uai_libe:ECOLE%20DE%20NIVEAU%20ELEMENTAIRE%20AND%20libelle_commune:' +
            input +
            ')&rows=20&fields=libelle_commune,code_postal_uai,appellation_officielle,numero_uai');

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['records']
          .map<School>((p) => School(
              recordid: p['recordid'],
              libelle_commune: p['fields']['libelle_commune'],
              code_postal_uai: p['fields']['code_postal_uai'],
              appellation_officielle: p['fields']['appellation_officielle'],
              numero_uai: p['fields']['numero_uai']))
          .toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        // We will put the api call here
        future: query == "" ? null : fetchSuggestions(query),
        builder: (context, snapshot) {
          if (query == '') {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text('Par exemple: paris ou ecole rousseau'),
            );
          } else {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: EmptyContent(
                    title: 'La ville ou l\'ecole n\'existe pas',
                    message: 'Verifie que l\'orthographe est bonne.',
                  ),
                ));
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      // we will display the data returned from our future here
                      title: Text(snapshot.data[index].get_appellation_officielle),
                      subtitle: Text(snapshot.data[index].get_libelle_commune),
                      onTap: () {
                        close(context, snapshot.data[index]);
                      },
                    );
                  },
                  itemCount: snapshot.data.length,
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        });
  }
}
