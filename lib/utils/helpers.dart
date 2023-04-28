import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// import 'package:flutter/material.dart';
import 'package:eden/domaine/favoris_obj.dart';
import 'package:eden/domaine/programme.dart';
import 'package:eden/domaine/user.dart';
import 'package:eden/infrastructure/v1/favoris.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';

import 'constante.dart';

class Helpers {
  /// Adding a string value ti sharedPreferrence
  dynamic putString(key, val) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var _res = prefs.setString("$key", val);
    return _res;
  }

  dynamic putBoolean(key, value) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var _res = prefs.setBool("$key", value);
    return _res;
  }

  Future<String?> getString(key) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key);
  }

  dynamic updateUserInfos(firstName, lastName, numero) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var _res = prefs.getString(userConnectKey);
    if (_res == null) return;
    CurrentUser currentUser = CurrentUser.fromJson(jsonDecode(_res));
    currentUser.firstName = firstName;
    currentUser.lastName = lastName;
    currentUser.numero = numero;
    putString(userConnectKey, jsonEncode(currentUser.toJson()));
    return _res;
  }

  Future<bool?> getBoolean(key) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(key);
  }

  Future<Directory> getExternalStorageDirectory() async {
    final Future<Directory> path = getApplicationDocumentsDirectory();

    return path;
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<bool?> saveImage(String url, String fileName) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          log("$directory");
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }

          directory = Directory(newPath);
        } else {
          return null;
        }
      } else {
        if (await requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
          if (Platform.isIOS) {
            File saveFile = File(directory.path + "/$fileName");
            await ImageGallerySaver.saveFile(saveFile.path,
                isReturnPathOfIOS: true);
          }
        } else {
          return null;
        }
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File test = File(url);
        // print("url " + test.path);
        await test.copy(directory.path + "/profile_photo.jpg");

        // test.copy(directory.path + "/");
        // saveFile.copy(url);

        // if (Platform.isIOS) {
        //   await ImageGallerySaver.saveFile(saveFile.path,
        //       isReturnPathOfIOS: true);
        // }
        return true;
      }
    } catch (e) {
      // print(e);
    }
    return null;
  }

  Future<void> share(
      String title, String text, String chooserTitle, String linkUrl) async {
    await FlutterShare.share(
        title: title, text: text, linkUrl: linkUrl, chooserTitle: chooserTitle);
  }

  List<Programme> getDayProg(List<Programme> output, int day) {
    // DateTime d = DateTime.now();
    DateFormat formatter = DateFormat('EEEE');

    // String formated = formatter.format(d);
    String selectedDay = "";
    switch (day) {
      case 0:
        selectedDay = "Monday";
        break;
      case 1:
        selectedDay = "Tuesday";
        break;
      case 2:
        selectedDay = "Wednesday";
        break;
      case 3:
        selectedDay = "Thursday";
        break;
      case 4:
        selectedDay = "Friday";
        break;
      case 5:
        selectedDay = "Saturday";
        break;
      default:
        selectedDay = "Sunday";
        break;
    }
    List<Programme> resultat = [];
    for (var element in output) {
      DateTime elmtDate =
          DateTime.parse(element.subProgramme!.last.releaseDate ?? "");
      // log("elmDate: ${formatter.format(elmtDate)} and selectedDay= $selectedDay");
      // log("${formatter.format(elmtDate) == selectedDay}");
      if (formatter.format(elmtDate) == selectedDay) {
        resultat.add(element);
        log("resultat = ${resultat.first.title}");
        // print(resultat);
      }
    }

    return resultat;
  }
}

List triCom(List commentaires) {
  List rsult = [];
  for (var k = 0; k < (commentaires.length * commentaires.length); k++) {
    for (var i = 0; i < commentaires.length; i++) {
      var tmp = commentaires.elementAt(i).value["timestemp"];
      var tmp1 = commentaires.elementAt(i);
      // test.remove(tmp);

      log("test value in$i : $tmp");
      for (var j = 0; j < commentaires.length; j++) {
        if (tmp >= commentaires.elementAt(j).value["timestemp"] &&
            !rsult.contains(commentaires.elementAt(j))) {
          tmp = commentaires.elementAt(j).value["timestemp"];
          tmp1 = commentaires.elementAt(j);
          // log("test value in2 : $tmp");
        }
      }

      !rsult.contains(commentaires.elementAt(i)) ? rsult.add(tmp1) : null;
    }
    if (rsult.length == commentaires.length) {
      break;
    }
  }

  return rsult;
}

Future<bool> haveFav(user) async {
  Helpers helpers = Helpers();
  String? userId = await helpers.getString(idKey);
  List<Programme> programmesFav = [];
  if (userId != null && user != null) {
    List<FavorisObj> favO = await fetchFavorisList(userId);

    // log(" valueid $userId");
    if (favO.isNotEmpty) {
      for (var item1 in favO) {
        if (item1.programme.type == "TV" ||
            item1.programme.type == "RADIO / TV") {
          programmesFav.add(item1.programme);
          break;
        }
      }
    }
  }
  return programmesFav.isEmpty ? false : true;
}

Future<bool> haveFavRadio(user) async {
  Helpers helpers = Helpers();
  String? userId = await helpers.getString(idKey);
  List<Programme> programmesFav = [];
  if (userId != null && user != null) {
    List<FavorisObj> favO = await fetchFavorisList(userId);

    // log(" valueid $userId");
    if (favO.isNotEmpty) {
      for (var item1 in favO) {
        if (item1.programme.type == "RADIO" ||
            item1.programme.type == "RADIO / TV") {
          programmesFav.add(item1.programme);
          break;
        }
      }
    }
  }
  log("lenght ${programmesFav.length}");
  return programmesFav.isEmpty ? false : true;
}
