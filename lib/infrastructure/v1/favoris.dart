import 'dart:developer';
import 'dart:io';

import 'package:eden/domaine/favoris.dart';
import 'package:eden/domaine/favoris_obj.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/helpers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Favoris> postFavoris(Favoris favoris) async {
  Helpers helpers = Helpers();
  String? token = await helpers.getString(userToken);
  log("userToken = ${await helpers.getString(userToken)}");

  final response = await http.post(Uri.parse(baseApiUrl + favorisUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Token $token'
      },
      body: jsonEncode(<String, dynamic>{
        "user": favoris.user,
        "programme": favoris.programme,
      }));
  log("Response favoris : $token");
  if (response.statusCode == 200 || response.statusCode == 201) {
    return Favoris.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception(
        "Impossible d'ajouter en favoris. Erreur: ${response.body}");
  }
}

Future<bool> deleteFavoris(Favoris favoris) async {
  Helpers helpers = Helpers();
  String? token = await helpers.getString(userToken);
  final response = await http.delete(
    Uri.parse(baseApiUrl + favorisUrl + favoris.id + "/"),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Token $token'
    },
  );

  log("User token : $token");

  log("response : ${response.statusCode}");
  if (response.statusCode == 200 || response.statusCode == 204) {
    return true;
  } else {
    return false;
  }
}

Future<List<FavorisObj>> fetchFavorisList(String userId) async {
  if (userId != "") {
    final response =
        await http.get(Uri.parse(baseApiUrl + favorisUrl + "?user=$userId"));
    // log("Get Fav : ${utf8.decode(response.bodyBytes)}");

    if (response.statusCode == 200) {
      final parsed = jsonDecode(utf8.decode(response.bodyBytes))
          .cast<Map<String, dynamic>>();
      List<FavorisObj> r =
          parsed.map<FavorisObj>((json) => FavorisObj.fromJson(json)).toList();
      log("Get Fav : $r");

      return parsed
          .map<FavorisObj>((json) => FavorisObj.fromJson(json))
          .toList();
    } else {
      throw Exception(
          "Impossible de récupérer les favoris de cet utilisateur.");
    }
  } else {
    return List.empty();
  }
}
