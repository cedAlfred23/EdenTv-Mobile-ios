import 'dart:convert';

import 'package:eden/domaine/service.dart';
import 'package:eden/utils/constante.dart';
import 'package:http/http.dart' as http;

Future<List<Service>> fetchService() async {
  try{
    final response = await http.get(Uri.parse(baseApiUrl + getServiceUrl));
  // print(response.statusCode);
  if (response.statusCode == 200) {
    final parsed = json
        .decode(utf8.decode(response.bodyBytes))
        .cast<Map<String, dynamic>>();
    // print(parsed);
    return parsed.map<Service>((json) => Service.fromJson(json)).toList();
  } else {
    throw Exception('Impossible de récupérer les services');
  }
  }catch(e){
    print(e);
  }
  return [];
}
