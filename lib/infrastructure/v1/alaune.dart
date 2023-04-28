import 'dart:convert';
import 'dart:developer';

import 'package:eden/domaine/news.dart';
import 'package:eden/utils/constante.dart';
import 'package:http/http.dart' as http;

Future<List<News>> newsList() async {
  try{
    final response = await http.get(
    Uri.parse(baseApiUrl + newsListUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  log(response.body);

  if (response.statusCode == 200) {
    final parsed = json
        .decode(utf8.decode(response.bodyBytes))
        .cast<Map<String, dynamic>>();
    return parsed.map<News>((json) => News.fromJson(json)).toList();
  } else {
    throw Exception(
        "Impossible de retrouver la liste des news. Erreur: ${response.statusCode}");
  }
  }catch(e){
    print(e);
  }
  return [];
}
