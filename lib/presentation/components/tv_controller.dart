import 'dart:developer';

import 'package:eden/domaine/favoris.dart';
import 'package:eden/domaine/favoris_obj.dart';
import 'package:eden/domaine/sub_programme.dart';
import 'package:eden/domaine/user.dart';
import 'package:eden/infrastructure/v1/account.dart';
import 'package:eden/infrastructure/v1/favoris.dart';
import 'package:eden/infrastructure/v1/sub_programme.dart';
import 'package:eden/presentation/components/alert_dialog.dart';

import 'package:eden/presentation/login/login.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

class TvController extends StatefulWidget {
  const TvController({/*required this.player, */ Key? key}) : super(key: key);
  // final FijkPlayer player;

  @override
  State<TvController> createState() => _TvControllerState();
}

class _TvControllerState extends State<TvController> {
  final double _height = 110.0;

  @override
  void initState() {
    super.initState();
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
    return Container(
      height: _height,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        boxShadow: [
          BoxShadow(
              color: Colors.grey, //New
              blurRadius: 12.0,
              offset: Offset(0, -2))
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      ),
      child: FutureBuilder<SubProgramme?>(
        future: getCurrentEmission("TV"),
        builder: (BuildContext context, AsyncSnapshot<SubProgramme?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              SubProgramme? subProgramme = snapshot.data;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsets.all(4.0),
                      child:
                          IconButton(onPressed: null, icon: Icon(Icons.close))),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: SizedBox(
                            width: 200,
                            child: Text(
                              subProgramme!.title ?? "",
                              style: valueTextStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          )),
                      SizedBox(
                        width: 150,
                        child: Text(
                          subProgramme.animateur ?? "",
                          style: serviceDescStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () async {
                        log("subprog id : ${subProgramme.programme.id}");
                        String idFav =
                            await isFavoris(subProgramme.programme.id ?? "");
                        if (idFav == "") {
                          await addToFavoris(
                              subProgramme.programme.id ?? "", context);
                        } else {
                          delFavoris(
                              subProgramme.programme.id ?? "", context, idFav);
                        }
                      },
                      icon: FutureBuilder<Widget?>(
                        future: getFavoris(subProgramme.programme.id ?? ""),
                        builder: (BuildContext context,
                            AsyncSnapshot<Widget?> snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data ??
                                const Icon(Icons.favorite_border);
                          } else {
                            return const Icon(Icons.favorite_border);
                          }
                        },
                      )),
                  // Padding(
                  //     padding: const EdgeInsets.only(left: 4.0),
                  //     child: GestureDetector(
                  //       child: /* widget.player.state == FijkState.started
                  //           ? */
                  //           Image.asset(
                  //         imagePause,
                  //         width: 24,
                  //         height: 24,
                  //       ),
                  //       // : Image.asset(
                  //       //     imagePlay,
                  //       //     width: 24,
                  //       //     height: 24,
                  //       //   ),
                  //       onTap: () async {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => HomePage(
                  //               selectedIndexForBottomNavigation: 0,
                  //               selectedIndexForTabBar: 1,
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     )),
                ],
              );
            } else {
              return const Center(
                child: Text("Aucun programme en cours"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
