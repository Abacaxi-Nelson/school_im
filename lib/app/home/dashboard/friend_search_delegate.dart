import 'package:flutter/material.dart';
import 'package:school_im/app/home/models/profile.dart';
import 'package:school_im/app/home/jobs/list_items_builder.dart';
import 'package:school_im/app/home/models/school.dart';

class FriendSearchDelegate extends SearchDelegate<UserInfo> {
  FriendSearchDelegate({
    @required this.data,
    @required this.user,
    @required this.requests,
    @required this.blokeds,
    String hintText = 'Recherche',
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  final data;
  final user;
  final List<String> requests;
  final List<String> blokeds;

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

  Widget getAvatar(String photoUrl, String name) {
    return photoUrl == null
        ? CircleAvatar(
            radius: 15.0,
            child: Text(name.toUpperCase()[0], style: const TextStyle(color: Color(0xff9188E5))),
            backgroundColor: Colors.white,
          )
        : CircleAvatar(
            radius: 15.0,
            backgroundImage: NetworkImage(photoUrl),
            backgroundColor: Colors.transparent,
          );
  }

  Widget listView(BuildContext context, bool full, String query) {
    print("requests: ${requests}");
    if (full) {
      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          if (data[index].id == user.uid) return Container();
          if (requests != null && requests.contains(data[index].id)) return Container();

          return ListTile(
              leading: getAvatar(data[index].photoUrl, data[index].surname),
              title: Text('${data[index].surname} ${data[index].name}'),
              onTap: () => close(context, data[index]));
        },
      );
    } else {
      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          if (data[index].id == user.uid) return Container();
          if (requests != null && requests.contains(data[index].id)) return Container();

          return data[index].surname.toLowerCase().contains(query.toLowerCase()) ||
                  data[index].name.toLowerCase().contains(query.toLowerCase())
              ? ListTile(
                  leading: getAvatar(data[index].photoUrl, data[index].surname),
                  title: Text('${data[index].surname} ${data[index].name}'),
                  onTap: () => close(context, data[index]))
              : Container();
        },
      );
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    return query.isEmpty ? listView(context, true, query) : listView(context, false, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return !query.isEmpty ? listView(context, true, query) : listView(context, false, query);
  }
}
