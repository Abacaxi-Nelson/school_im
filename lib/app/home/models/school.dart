import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class UserInfo extends Equatable {
  final String name;
  final String surname;
  final String photoUrl;
  final String id;

  @override
  List<Object> get props => [name, surname, photoUrl, id];

  @override
  bool get stringify => true;

  UserInfo({this.name, this.surname, this.photoUrl, this.id});

  factory UserInfo.fromMap(Map<dynamic, dynamic> value) {
    return UserInfo(name: value['name'], surname: value['surname'], photoUrl: value['photoUrl'], id: value['id']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'surname': surname,
      'photoUrl': photoUrl,
      'id': id,
    };
  }
}

class School extends Equatable {
  final String recordid;
  final String libelle_commune;
  final String code_postal_uai;
  final String appellation_officielle;
  final String numero_uai;
  List<UserInfo> list = List<UserInfo>();

  @override
  List<Object> get props => [recordid, libelle_commune, code_postal_uai, appellation_officielle, numero_uai, list];

  @override
  bool get stringify => true;

  School(
      {this.recordid,
      this.libelle_commune,
      this.code_postal_uai,
      this.appellation_officielle,
      this.numero_uai,
      this.list});

  void addMember(UserInfo userInfo) {
    if (list == null) {
      list = List<UserInfo>();
    }
    list.add(userInfo);
  }

  factory School.fromMap(Map<dynamic, dynamic> value) {
    return School(
        recordid: value['recordid'],
        libelle_commune: value['libelle_commune'],
        code_postal_uai: value['code_postal_uai'],
        appellation_officielle: value['appellation_officielle'],
        numero_uai: value['numero_uai'],
        list: value['list'] == null
            ? null
            : List<UserInfo>.from(value['list'].map((item) {
                return UserInfo.fromMap(item);
              })));
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'recordid': recordid,
      'libelle_commune': libelle_commune,
      'code_postal_uai': code_postal_uai,
      'appellation_officielle': appellation_officielle,
      'numero_uai': numero_uai,
      'list': list == null
          ? null
          : list.map((item) {
              return item.toMap();
            }).toList(),
    };
  }

  String get get_libelle_commune {
    return libelle_commune;
  }

  String get get_appellation_officielle {
    return appellation_officielle;
  }
}
