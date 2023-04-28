// import 'dart:developer';

import 'package:eden/domaine/categorie.dart';
import 'package:eden/domaine/sub_programme.dart';

class Programme {
  final String? id;
  final Categorie? categorie;
  final String? title;
  final String? description;
  final String? couverture;
  final String? type;
  List<SubProgramme>? subProgramme;
  SubProgramme? subProg;
  // final String? date;

  Programme({
    required this.id,
    this.categorie,
    required this.description,
    required this.couverture,
    required this.title,
    required this.type,
    this.subProgramme,
    this.subProg,
    // required this.date
  });

  factory Programme.fromJson(Map<String, dynamic> json) {
    // log("subProg ${json['subProgrammes']}");
    return Programme(
        id: json["id"],
        categorie: Categorie.fromJson(json["categorie"]),
        description: json["description"],
        couverture: json["couverture"],
        title: json["title"],
        type: json["type"],
        /*date: json["date"]*/
        subProgramme: json["subProgrammes"]
            .map<SubProgramme>((json) => SubProgramme.fromJson(json))
            .toList());
  }

  factory Programme.fromJson2(Map<String, dynamic> json) {
    // log(json["subProgrammes"]);
    return Programme(
      id: json["id"],
      categorie: Categorie.fromJson(json["categorie"]),
      description: json["description"],
      couverture: json["couverture"],
      title: json["title"],
      type: json["type"],
    );
  }
}
