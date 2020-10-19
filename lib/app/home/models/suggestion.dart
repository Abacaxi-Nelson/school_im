import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Suggestion {
  final String recordid;
  final String libelle_commune;
  final String code_postal_uai;
  final String appellation_officielle;
  final String numero_uai;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'recordid': recordid,
      'libelle_commune': libelle_commune,
      'code_postal_uai': code_postal_uai,
      'appellation_officielle': appellation_officielle,
      'numero_uai': numero_uai
    };
  }

  @override
  String toString() {
    return 'Suggestion(appellation_officielle: $appellation_officielle, numero_uai: $numero_uai, libelle_commune: $libelle_commune)';
  }

  String get get_libelle_commune {
    return libelle_commune;
  }

  String get get_appellation_officielle {
    return appellation_officielle;
  }

  Suggestion(this.recordid, this.libelle_commune, this.code_postal_uai, this.appellation_officielle, this.numero_uai);
}
