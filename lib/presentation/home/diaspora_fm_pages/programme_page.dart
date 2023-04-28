// import 'dart:developer';

import 'dart:developer';

import 'package:eden/domaine/favoris.dart';
import 'package:eden/domaine/favoris_obj.dart';
import 'package:eden/domaine/programme.dart';
import 'package:eden/domaine/user.dart';
import 'package:eden/infrastructure/v1/favoris.dart';
import 'package:eden/infrastructure/v1/programme.dart';
import 'package:eden/infrastructure/v1/account.dart';
import 'package:eden/presentation/components/alert_dialog.dart';
import 'package:eden/presentation/components/liste_elmnt.dart';

import 'package:eden/presentation/login/login.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/helpers.dart';
// import 'package:eden/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProgrammePage extends StatefulWidget {
  const ProgrammePage({Key? key}) : super(key: key);

  @override
  State<ProgrammePage> createState() => _ProgrammePageState();
}

class _ProgrammePageState extends State<ProgrammePage> {
  final List<String> _days = [];
  final List<DateTime> _daysCopy = [];
  final Map<String, String> frDay = {
    "Monday": "Lundi",
    "Tuesday": "Mardi",
    "Wednesday": "Mercredi",
    "Thursday": "Jeudi",
    "Friday": "Vendredi",
    "Saturday": "Samedi",
    "Sunday": "Dimanche"
  };
  DateTime _selectedIndex = DateTime.now();
  // int _default = 0;
  bool favoris = false;

  DateTime d = DateTime.now();
  DateFormat formatter = DateFormat('EEEE');
  String formated1 = "";

  @override
  void initState() {
    super.initState();
    // String formated = formatter.format(d);
    formated1 = formatter.format(DateTime.now());
    DateTime lastDate = d.subtract(const Duration(days: 1));
    _days.add(frDay[formatter.format(lastDate)]!.substring(0, 2));
    _daysCopy.add(lastDate);
    _days.add(frDay[formatter.format(d)]!.substring(0, 2));
    _daysCopy.add(d);
    for (var i = 0; i < 5; i++) {
      d = d.add(const Duration(days: 1));
      _days.add(frDay[formatter.format(d)]!.substring(0, 2));
      _daysCopy.add(d);
    }
  }

  Future<Widget> getFavoris(String progId) async {
    Favoris f = const Favoris(id: "", programme: "", user: "");
    List<Favoris> favorisList = await f.favorisList();
    if (favorisList.isEmpty) {
      Helpers helpers = Helpers();
      String? userId = await helpers.getString(idKey);
      List<FavorisObj> listOnlineFav = await fetchFavorisList(userId ?? "");
      for (var item in listOnlineFav) {
        if (progId == item.programme.id) {
          return const Icon(
            Icons.favorite,
            color: Colors.red,
          );
        } else {
          continue;
        }
      }
    } else {
      for (var item in favorisList) {
        if (progId == item.programme) {
          return const Icon(
            Icons.favorite,
            color: Colors.red,
          );
        } else {
          continue;
        }
      }
    }

    return const Icon(Icons.favorite_border);
  }

  Future<void> addToFavoris(String progId, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      CurrentUser currentUser = await getConnectedUser(user.uid);
      Favoris favoris = await postFavoris(
          Favoris(id: "", programme: progId, user: currentUser.id ?? ""));
      // log("favoris: ${favoris.favorisList()}");

      try {
        const snackBar = SnackBar(content: Text("Programme ajouté en favoris"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {});
      } catch (e) {
        const snackBar =
            SnackBar(content: Text("Impossible d'ajouter en favoris !"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      try {
        favoris.insertFavoris(favoris);
      } catch (e) {
        const snackBar = SnackBar(
            content: Text("Impossible d'ajouter en favoris a la base locale!"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialogCustom(
                title: "Attention",
                message:
                    "Connectez-vous pour ajouter le programme aux favoris ",
                type: "warning",
                backPath: LoginPage());
          });
    }
  }

  Future<void> delFavoris(
      String progId, BuildContext context, String idFav) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      CurrentUser currentUser = await getConnectedUser(user.uid);
      Favoris f =
          Favoris(id: idFav, programme: progId, user: currentUser.id ?? "");
      try {
        await deleteFavoris(f);
        // log("favoris: ${favoris.favorisList()}");

        const snackBar =
            SnackBar(content: Text("Programme supprimer de vos favoris"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {});
      } catch (e) {
        const snackBar =
            SnackBar(content: Text("Impossible de supprimer le favoris !"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      try {
        f.deleteFavoris(f.id);
      } catch (e) {
        const snackBar =
            SnackBar(content: Text("Impossible de supprimer le favoris!"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialogCustom(
                title: "Attention",
                message:
                    "Connectez-vous pour supprimer le programme de vos favoris ",
                type: "warning",
                backPath: LoginPage());
          });
    }
  }

  Future<String> isFavoris(String progId) async {
    Favoris f = const Favoris(id: "", programme: "", user: "");
    List<Favoris> favorisList = await f.favorisList();
    for (var item in favorisList) {
      if (progId == item.programme) {
        return item.id;
      } else {
        continue;
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Programmes",
            style: politiqueConfidentialiteTitleStyle,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          width: MediaQuery.of(context).size.width,
          height: 65,
          child: ListView.builder(
              itemCount: 7,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                // index = _selectedIndex;

                return GestureDetector(
                    onTap: () {
                      setState(() {
                        // CircularProgressIndicator();
                        formated1 = formatter.format(_daysCopy[index]);
                        _selectedIndex = _daysCopy[index];
                      });
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: 45,
                          decoration: BoxDecoration(
                              border: const Border(
                                  bottom: BorderSide(
                                      color: Color.fromRGBO(137, 137, 137, 1),
                                      width: 0.5),
                                  top: BorderSide(
                                      color: Color.fromRGBO(137, 137, 137, 1),
                                      width: 0.5),
                                  left: BorderSide(
                                      color: Color.fromRGBO(137, 137, 137, 1),
                                      width: 0.5),
                                  right: BorderSide(
                                      color: Color.fromRGBO(137, 137, 137, 1),
                                      width: 0.5)),
                              color: frDay[formated1]!.substring(0, 2) ==
                                      _days[index]
                                  ? primaryColors
                                  : Colors.white,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(50.0))),
                          child: Center(
                            child: Text(
                              _days[index],
                              style: frDay[formated1]!.substring(0, 2) ==
                                      _days[index]
                                  ? dayDesignSelected
                                  : dayDesignDefault,
                            ),
                          ),
                        )));
              }),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .54,
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<Programme>>(
              future: getProgrammes("RADIO", _selectedIndex),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Programme>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    log("programme: ${snapshot.data}");
                    if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("Aucun programme disponible"),
                      );
                    } else {
                      List<Programme>? programmes = snapshot.data;
                      return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 117),
                          itemCount: programmes!.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return Liste(programme: programmes[index]);
                          });
                    }
                  } else {
                    return const Text("Aucun programme disponible");
                  }
                } else {
                  return const Text("Aucun programme disponible");
                }
              },
            ))
      ],
    );
  }
}
