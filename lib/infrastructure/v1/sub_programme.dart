import 'dart:convert';
import 'dart:developer';
import 'package:eden/domaine/sub_programme.dart';
import 'package:eden/utils/constante.dart';
import 'package:http/http.dart' as http;

Future<SubProgramme?> getCurrentEmission(String type) async {
  String path = type == "RADIO" ? "current_radio/" : "current_tv/";

  log(Uri.parse(baseApiUrl + subProgrammeUrl + path).toString());
  try{
    final response = await http.get(Uri.parse(baseApiUrl + subProgrammeUrl + path));
     if (response.statusCode == 200) {
    final parsed = jsonDecode(utf8.decode(response.bodyBytes));
    // log("body: ${parsed}");

    return SubProgramme.fromJson(parsed);
  } else {
    log("Erreur: ${response.statusCode}");
    log("Erreur: ${response.body}");
    return null;
    //throw ("Impossible de récupérer l'emission en directe");
  }
  }catch(e){
    print(e);
  }
  return null;
}

Future<List<SubProgramme>> getEmission(String type) async {
  try{
    final response = await http.get(
    Uri.parse(baseApiUrl + subProgrammeUrl),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  log("status: ${response.statusCode}");

  if (response.statusCode == 200) {
    final parsed = jsonDecode(utf8.decode(response.bodyBytes))
        .cast<Map<String, dynamic>>();
    List<SubProgramme> listSubProg = parsed
        .map<SubProgramme>((json) => SubProgramme.fromJson(json))
        .toList();
    log("texte lenght: ${listSubProg.length}");
    List<SubProgramme> listFinal = [];
    for (var item in listSubProg) {
      if (type == "RADIO") {
        if (item.programme.type == "RADIO" ||
            item.programme.type == "RADIO / TV") {
          listFinal.add(item);
        }
      } else {
        if (item.programme.type == "TV" ||
            item.programme.type == "RADIO / TV") {
          listFinal.add(item);
        }
      }

      // break;
    }
    log("content of array ${listFinal.toList()}");
    return listFinal;
  } else {
    throw ("Impossible de recupérer la liste des emissions. Erreur: ${response.body}");
  }
  }catch(e){
    print(e);
  }
  return [];
}

Future<List<SubProgramme>> getAlaUne(String type) async {
  try{
    final response = await http.get(
    Uri.parse(baseApiUrl + subProgrammeUrl),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  // log("status: ${response.body}");

  if (response.statusCode == 200) {
    final parsed = jsonDecode(utf8.decode(response.bodyBytes))
        .cast<Map<String, dynamic>>();
    List<SubProgramme> listSubProg = parsed
        .map<SubProgramme>((json) => SubProgramme.fromJson(json))
        .toList();

    List<SubProgramme> listFinal = [];
    for (var item in listSubProg) {
      // log("categorie: ${item.programme.categorie!.title}");
      if (type == "RADIO") {
        if (item.programme.type == "RADIO" &&
            item.programme.categorie!.title!
                .toLowerCase()
                .contains("journal") &&
            listFinal.length <= 19) {
          listFinal.add(item);
        }
      } else if (type == "RADIO / TV" &&
          item.programme.categorie!.title!.toLowerCase().contains("journal") &&
          listFinal.length <= 19) {
        // log("texte: ${listSubProg.first.title}");
        listFinal.add(item);
      } else {
        if (item.programme.type == "TV" &&
            item.programme.categorie!.title!
                .toLowerCase()
                .contains("journal") &&
            listFinal.length <= 19) {
          listFinal.add(item);
        }
      }
    }
    return listFinal;
  } else {
    throw ("Impossible de recupérer la liste des emissions. Erreur: ${response.body}");
  }
  }catch(e){
    print(e);
  }
  return [];
}
