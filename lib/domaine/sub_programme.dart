// import 'dart:convert';

import 'package:eden/domaine/animateur.dart';
import 'package:eden/domaine/programme.dart';
// import 'package:eden/domaine/programme.dart';

class SubProgramme {
  final String? id;
  final String? file;
  final String? animateur;
  final String? title;
  final String? releaseDate;
  final String? startTime;
  final String? endTime;
  final Programme programme;
  // final String categorie;

  const SubProgramme(
      {required this.id,
      required this.file,
      required this.animateur,
      required this.title,
      required this.releaseDate,
      required this.startTime,
      required this.endTime,
      required this.programme});

  factory SubProgramme.fromJson(Map<String, dynamic> json) {
    Animateur animateur = Animateur.fromJson(json["animateur"]);

    Programme programme = Programme.fromJson2(json["programme"]);
    // log("$programme");

    return SubProgramme(
        id: json["id"],
        file: json["file"],
        animateur: "${animateur.nom} ${animateur.prenom}",
        title: json["title"],
        releaseDate: json["release_date"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        programme: programme
        // categorie: json["programme"].cast<Map<String, dynamic>>()[""]
        // programme: Programme.fromJson(json["programme"])
        );
  }
}
