import 'dart:convert';

import 'package:eden/domaine/espace_pub.dart';
import 'package:eden/utils/constante.dart';
import 'package:http/http.dart' as http;

Future<List<EspacePub>> fetchEspacesPub() async {
  try{
    final response = await http.get(Uri.parse(baseApiUrl + getEspacePubUrl));
  // print(response.statusCode);
  if (response.statusCode == 200) {
    final parsed = json
        .decode(utf8.decode(response.bodyBytes))
        .cast<Map<String, dynamic>>();
    // print(parsed);
    return parsed.map<EspacePub>((json) => EspacePub.fromJson(json)).toList();
  } else {
    throw Exception('Impossible de récupérer les EspacePubs');
  }
  }catch(e){
    print(e);
  }
  //  throw Exception('Impossible de récupérer les EspacePubs');
  return [];
}
