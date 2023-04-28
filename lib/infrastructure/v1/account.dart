import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eden/domaine/user.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

//Method to save user data on API into loginSocial
Future<CurrentUser> createUser(CurrentUser user) async {
  final response = await http.post(
    Uri.parse(baseApiUrl + postCreateLoginSocialUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'uid': user.uid,
      'name': user.lastName,
      'first_name': user.firstName,
      'last_name': user.lastName,
      'email': user.email,
      'phone': user.numero!.isEmpty ? user.email : user.numero,
      'notify_on_program': user.notifyOnProgram,
      'displayName': user.displayName,
      'providerId': user.providerId,
      'countryCode': user.countryCode,
      'country': user.country,
      'fromFacebook': user.fromFacebook,
      'fromApple': user.fromApple,
      'fromGoogle': user.fromGoogle,
      'forSave': user.forSave
    }),
  );
  // log(response.statusCode);
  // print("ucrrentUsr");
  // print(user);
  // print("response body");
  log(response.body);
  if (response.statusCode == 200) {
    CurrentUser currentUser =
        CurrentUser.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    Helpers helpers = Helpers();
    helpers.putString(idKey, currentUser.id);
    helpers.putString(userToken, currentUser.token);
    log(currentUser.token);

    return currentUser;
  } else {
    throw Exception(
        'Erreur de creation de votre compte. Erreur : ${response.body}');
  }
}

//method to update user
Future<CurrentUser> updateUser(
    CurrentUser user, String id, User? firebaseUser) async {
  String firstN = user.firstName ?? "";
  String lastN = user.lastName ?? "";
  Helpers helpers = Helpers();
  log("id = $id");
  bool notifyNews = await helpers.getBoolean("NEWSLETTER") ?? false;
  final response = await http.patch(
    Uri.parse(baseApiUrl + putAccountUrl + "/$id/"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'username': firstN + " " + lastN,
      'first_name': user.firstName,
      'last_name': user.lastName,
      'email': user.email,
      'phone': user.numero,
      'countryCode': user.countryCode,
      'country': user.country,
      'notify_on_program': notifyNews
    }),
  );
  // print("update???");
  // print(response.statusCode);
  // print(response.reasonPhrase);
  // print(response.body);
  if (response.statusCode == 200) {
    Helpers().putString(userConnectKey,
        jsonEncode({"user": jsonDecode(utf8.decode(response.bodyBytes))}));
    return CurrentUser.fromJson2(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception(
        'Erreur de update de votre compte. Erreur : ${response.body}');
  }
}

Future<CurrentUser?> getConnectedUserStore() async {
  String? dt = await Helpers().getString(userConnectKey);
  if (dt != null) {
    return CurrentUser.fromJson(jsonDecode(dt));
  }
  return null;
}

//get conenced user details
Future<CurrentUser> getConnectedUser(String uid) async {
  // var param = {"uid": uid};
  final response = await http.get(
    Uri.parse(baseApiUrl + getLoginSocialUrl + "?uid=$uid"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  log("voila ${response.body}");
  if (response.statusCode == 200) {
    // final parsed = jsonDecode(response.body);
    CurrentUser c =
        CurrentUser.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    Helpers().putString(userToken, c.token);
    Helpers().putString(prenomKey, c.lastName);
    Helpers().putString(nomKey, c.firstName);
    Helpers().putString(telKey, c.numero);
    Helpers().putString(idKey, c.id);
    Helpers().putString(userConnectKey, jsonEncode(c.toJson()));
    return c;
  } else {
    var c = CurrentUser(
        id: "",
        uid: "",
        firstName: "",
        lastName: "",
        countryCode: "",
        country: "",
        providerId: "",
        displayName: "",
        numero: "",
        email: "",
        photoURL: "",
        fromFacebook: false,
        fromGoogle: false,
        fromApple: false,
        forSave: false,
        notifyOnProgram: false,
        token: "");
    return c;
  }
}

Future<bool> setDeviceFcm(String fcmtoken) async {
  Helpers helpers = Helpers();
  String? token = await helpers.getString(userToken);

  final response = await http.post(
    Uri.parse(baseApiUrl + "/fcmDevices/"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Token $token'
    },
    body: jsonEncode(
        <String, dynamic>{"registration_id": fcmtoken, "type": "android"}),
  );
  log("statu addNews : ${response.statusCode}");
  log("body addNews : ${response.body}");
  if (response.statusCode == 200 || response.statusCode == 201) {
    await Helpers().putString(userToken, token);
    return true;
  } else {
    return false;
  }
}

Future<bool> deleteUserAccount(String? userId) async {
  final response = await http.delete(
    Uri.parse(baseApiUrl + putAccountUrl + "/$userId/"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200 || response.statusCode == 204) {
    log("User account deleted succesfully");
    return true;
  } else {
    log('Erreur de delete de votre compte. Erreur :${response.statusCode} && ${response.body}');
    return false;
  }
}
