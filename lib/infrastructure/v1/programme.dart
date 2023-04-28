// import 'dart:developer';

import 'dart:developer';

import 'package:eden/domaine/programme.dart';
import 'package:eden/utils/constante.dart';
import 'package:http/http.dart' as http;
// import 'dart:developer';
import 'dart:convert';
import 'package:intl/intl.dart';

Future<List<Programme>> getProgrammes(String type, DateTime day) async {
  try{
    final response = await http.get(
    Uri.parse(baseApiUrl + programmeUrl + "?type=$type"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  // log("response prog: ${response.body}");
  if (response.statusCode == 200) {
    final parsed = jsonDecode(utf8.decode(response.bodyBytes))
        .cast<Map<String, dynamic>>();

    List<Programme> output =
        parsed.map<Programme>((json) => Programme.fromJson(json)).toList();

    // log("response prog: ${output}");
    // DateTime d = DateTime.now();
    DateFormat formatter = DateFormat('EEEE');

    var resultat = <Programme>[];
    // var i = 0;
    for (var element in output) {
      if (element.subProgramme != null) {
        // log("response prog: ${element.subProgramme}");
        if (element.subProgramme!.isNotEmpty) {
          // log("not emmpty");
          DateTime elmtDate =
              DateTime.parse(element.subProgramme!.last.releaseDate ?? "");
          // log("elmDate: ${element.subProgramme!.last.releaseDate}");
          // log("${formatter.format(elmtDate) == formatter.format(day)}");
          if (formatter.format(elmtDate) == formatter.format(day)) {
            resultat.add(element);
            // log("id prog : ${element.id}");
          }
        }
      }
    }

    return resultat;
  } else {
    // log("response: $response.body");
    throw Exception("Impossible de récupérer les programme");
  }
  }catch(e){
    print(e);
  }
  return [];
}

Future<Programme> getProgramme(String id) async {
  try{
    final response = await http.get(
    Uri.parse(baseApiUrl + programmeUrl + id),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    final parsed = jsonDecode(utf8.decode(response.bodyBytes))
        .cast<Map<String, dynamic>>();

    Programme output = Programme.fromJson(parsed);
    log("resppnse get prg : $output");

    return output;
  } else {
    // log("response: $response.body");
    throw Exception("Impossible de récupérer le programme");
  }
  }catch(e){
    print(e);
  }
  return Programme(id: id, description: '', couverture: '', title: '', type: '');
}
