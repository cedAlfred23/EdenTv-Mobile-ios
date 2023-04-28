import 'dart:developer';

import 'package:eden/domaine/favoris.dart';
import 'package:eden/domaine/favoris_obj.dart';
import 'package:eden/domaine/programme.dart';
import 'package:eden/domaine/user.dart';
import 'package:eden/infrastructure/v1/account.dart';
import 'package:eden/infrastructure/v1/favoris.dart';
import 'package:eden/presentation/components/alert_dialog.dart';
import 'package:eden/presentation/components/programme_details.dart';
import 'package:eden/presentation/login/login.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Liste extends StatefulWidget {
  const Liste({required this.programme, Key? key}) : super(key: key);
  final Programme programme;
  @override
  State<Liste> createState() => _ListeState();
}

class _ListeState extends State<Liste> {
  bool isFavoriteP = false;
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
      log("favoris: ${favoris.favorisList()}");

      try {
        const snackBar = SnackBar(content: Text("Programme ajouté en favoris"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // setState(() {});
      } catch (e) {
        const snackBar =
            SnackBar(content: Text("Impossible d'ajouter en favoris !"));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }

      // try {
      //   favoris.insertFavoris(favoris);
      // } catch (e) {
      //   const snackBar = SnackBar(
      //       content: Text("Impossible d'ajouter en favoris a la base locale!"));
      //   if (this.mounted) {
      //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //   }
      // }
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
        // if (this.mounted) {
        //   setState(() {
        //     isFavoriteP = r;
        //   });
        // }
        // log("favoris: ${favoris.favorisList()}");

        const snackBar =
            SnackBar(content: Text("Programme supprimer de vos favoris"));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        // setState(() {});
      } catch (e) {
        const snackBar =
            SnackBar(content: Text("Impossible de supprimer le favoris !"));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }

      // try {
      //   f.deleteFavoris(f.id);
      // } catch (e) {
      //   const snackBar =
      //       SnackBar(content: Text("Impossible de supprimer le favoris!"));
      //   if (this.mounted) {
      //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //   }
      // }
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
    Helpers helpers = Helpers();
    String? userId = await helpers.getString(idKey);
    List<FavorisObj> listOnlineFav = await fetchFavorisList(userId ?? "");
    // List<Favoris> favorisList = await f.favorisList();
    log("userId $userId");

    for (var item in listOnlineFav) {
      if (progId == item.programme.id) {
        log("fav_id ${item.id}");
        log("progId $progId");
        log("item prog id = ${item.programme.id}");
        if (mounted) {
          setState(() {
            log("is faav $isFavoriteP");
            isFavoriteP = true;
          });
        }
        return item.id;
      } else {
        continue;
      }
    }
    return "";
  }

  @override
  void initState() {
    super.initState();
    isFavoris(widget.programme.id ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              width: 102,
              height: 98,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  image: DecorationImage(
                    image: NetworkImage(widget.programme.couverture ?? ""),
                  )),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: SizedBox(
                      width: 140,
                      child: Text(
                        widget.programme.title ?? "",
                        style: serviceTitleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: SizedBox(
                        width: 140,
                        child: Text(
                          widget.programme.categorie!.title ?? "",
                          style: serviceTitleStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: SizedBox(
                        width: 140,
                        child: Text(
                          widget.programme.subProgramme!.last.startTime ?? "",
                          style: serviceTitleStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      )),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ProgrammeDetails(
                                title: widget.programme.title ?? "",
                                date: "",
                                categorie:
                                    widget.programme.categorie!.title ?? "",
                                couverture: widget.programme.couverture ?? "");
                          });
                    },
                    child: const Text("En savoir plus",
                        style: TextStyle(
                            color: primaryColors,
                            fontSize: 11,
                            fontFamily: fontFamilly,
                            decoration: TextDecoration.underline)),
                  )
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                    onPressed: () async {
                      String idFav = await isFavoris(widget.programme.id ?? "");
                      log("idavvv $idFav");
                      if (mounted) {
                        setState(() {
                          isFavoriteP = !isFavoriteP;
                        });
                      }

                      if (idFav == "") {
                        await addToFavoris(widget.programme.id ?? "", context);
                      } else {
                        delFavoris(widget.programme.id ?? "", context, idFav);
                        // setState(() {
                        //   isFavoriteP = false;
                        // });
                      }
                    },
                    icon: Icon(
                      isFavoriteP
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: isFavoriteP ? Colors.red : null,
                    )),
              ],
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
          child: Divider(
            color: Color.fromRGBO(158, 158, 158, 1),
            height: 0.5,
            thickness: 0.5, // thickness of the line
            // empty space to the leading edge of divider.
            endIndent: 0,
          ),
        ),
      ],
    );
  }
}
