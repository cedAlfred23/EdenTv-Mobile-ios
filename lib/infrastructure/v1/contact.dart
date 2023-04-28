import 'dart:convert';
import 'dart:io';

import 'package:eden/domaine/contact.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/helpers.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

Future<Contact> sendContact(Contact contact) async {
  Helpers helpers = Helpers();
  String? token = await helpers.getString(userToken);
  log("contact send token : $token");

  final response = await http.post(Uri.parse(baseApiUrl + postContact),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Token $token'
      },
      body: jsonEncode(<String, dynamic>{
        "user": contact.user,
        "object": contact.object,
        "content": contact.content,
        "service": contact.service,
      }));

  // log("contact send user: ${contact.user}");
  // log("contact send object: ${contact.object}");
  // log("contact send content: ${contact.content}");
  // log("contact send service: ${contact.service}");
  // log(response.body);
  // print(response.headers);
  if (response.statusCode == 200 || response.statusCode == 201) {
    return Contact.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    log(response.body);
    // print(response.body);
    throw Exception(
        "Impossible d'envoyer un message. Erreur: ${response.statusCode}");
  }
}
