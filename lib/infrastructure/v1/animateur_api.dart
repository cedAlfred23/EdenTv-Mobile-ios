import 'dart:convert';
import 'dart:developer';
// import 'dart:developer';

import 'package:eden/domaine/animateur.dart';
import 'package:eden/utils/constante.dart';
import 'package:http/http.dart' as http;

Future<List<Animateur>> fetchAimateurs() async {
  try{
    // List<Animateur>? allAnimateurs;
  final response = await http.get(Uri.parse(baseApiUrl + getAnimateursUrl));
  // log("reponse: ${response.body}");
  if (response.statusCode == 200) {
    final parsed = json
        .decode(utf8.decode(response.bodyBytes))
        .cast<Map<String, dynamic>>();
    return parsed.map<Animateur>((json) => Animateur.fromJson(json)).toList();
  } else {
    throw Exception('Impossible de récupérer les EspacePubs');
  }
  }catch(e){

  }
  return [];
}

Future<Animateur?> fetchAnimateur(String id) async {
  Animateur? animateur;

  final response = await http.get(
    Uri.parse(baseApiUrl + getAnimateursUrl + "$id/"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  log("reponse: id: $id : ${response.statusCode}");

  if (response.statusCode == 200) {
    animateur = Animateur.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

    return animateur;
  } else {
    throw Exception("Impossible de récupérer le profil de l'animateur");
  }
}
