import 'package:flutter/material.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/app/home/jobs/list_items_builder.dart';
import 'package:school_im/app/home/models/school.dart';

class FriendSearchDelegate extends SearchDelegate {
  FriendSearchDelegate({
    @required this.school,
    String hintText = 'Recherche',
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  final school;

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
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return query.isEmpty
        ? ListView.builder(
            itemCount: school.list.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${school.list[index].surname} ${school.list[index].name}'),
              );
            },
          )
        : ListView.builder(
            itemCount: school.list.length,
            itemBuilder: (context, index) {
              return school.list[index].surname.toLowerCase().contains(query.toLowerCase()) ||
                      school.list[index].name.toLowerCase().contains(query.toLowerCase())
                  ? ListTile(
                      title: Text('${school.list[index].surname} ${school.list[index].name}'),
                    )
                  : Container();
            },
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return !query.isEmpty
        ? ListView.builder(
            itemCount: school.list.length,
            itemBuilder: (context, index) {
              return school.list[index].surname.toLowerCase().contains(query.toLowerCase()) ||
                      school.list[index].name.toLowerCase().contains(query.toLowerCase())
                  ? ListTile(
                      title: Text('${school.list[index].surname} ${school.list[index].name}'),
                    )
                  : Container();
            },
          )
        : ListView.builder(
            itemCount: school.list.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${school.list[index].surname} ${school.list[index].name}'),
              );
            },
          );
  }
}
