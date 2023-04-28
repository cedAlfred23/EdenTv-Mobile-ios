import 'dart:ui';

import 'package:eden/domaine/favoris.dart';
import 'package:eden/domaine/favoris_obj.dart';
import 'package:eden/domaine/sub_programme.dart';
import 'package:eden/domaine/user.dart';
import 'package:eden/infrastructure/v1/account.dart';
import 'package:eden/infrastructure/v1/favoris.dart';
import 'package:eden/infrastructure/v1/sub_programme.dart';
import 'package:eden/presentation/components/alert_dialog.dart';
import 'package:eden/presentation/home/home.dart';
import 'package:eden/presentation/login/login.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RadioDetailsPage extends StatefulWidget {
  const RadioDetailsPage(
      {Key? key,
      required this.startDate,
      required this.endDate,
      required this.description,
      required this.title})
      : super(key: key);
  final String startDate;
  final String endDate;
  final String description;
  final String title;

  @override
  State<RadioDetailsPage> createState() => _RadioDetailsPageState();
}

class _RadioDetailsPageState extends State<RadioDetailsPage> {
  String image =
      "https://img.freepik.com/photos-gratuite/organisation-journee-education-table-espace-copie_23-2148721266.jpg?t=st=1647114016~exp=1647114616~hmac=7b5e57a5e15bb7f2ee59819d7238e32443a272523bd0fc327ab25b5c57f9f283&w=1060";
  bool _extendArea = false;
  double _height = 64.0;
  final Helpers _helpers = Helpers();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "En cours",
          style: titleTextStyle,
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  selectedIndexForBottomNavigation: 0,
                  selectedIndexForTabBar: 0,
                ),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          padding: const EdgeInsets.only(left: 16.0),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 320,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.comment,
                        color: Color.fromRGBO(130, 130, 130, 1),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0, bottom: 16.0),
                        child: Text(
                          "Discuter",
                          style: discuterStyle,
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await _helpers.share(
                        "Diaspora FM",
                        "Hey! viens écouter en direct la radio Diaspora FM.",
                        "Partager Diaspora FM",
                        "https://play.google.com/store/apps/details?id=com.gits.edentv&hl=fr&gl=US");
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.share,
                        color: Color.fromRGBO(130, 130, 130, 1),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0, bottom: 18.0),
                        child: Text(
                          "Partager",
                          style: discuterStyle,
                        ),
                      )
                    ],
                  ),
                ),
                FutureBuilder<SubProgramme?>(
                  future: getCurrentEmission("RADIO"),
                  builder: (BuildContext context,
                      AsyncSnapshot<SubProgramme?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasData) {
                        SubProgramme? subProgramme = snapshot.data;
                        return Column(
                          children: [
                            Center(
                                child: Stack(
                              children: [
                                Container(
                                  width: 235,
                                  height: 255,
                                  margin: const EdgeInsets.only(bottom: 38.0),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30.0)),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(subProgramme!
                                                  .programme.couverture ??
                                              ""))),
                                ),
                                Positioned(
                                  top: 224,
                                  left: 90,
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: const BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromRGBO(
                                                130, 130, 130, 1),
                                            blurRadius: 8.0,
                                          )
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0))),
                                    child: IconButton(
                                        onPressed: () async {
                                          String idFav = await isFavoris(
                                              subProgramme.programme.id ?? "");
                                          if (idFav == "") {
                                            await addToFavoris(
                                                subProgramme.programme.id ?? "",
                                                context);
                                          } else {
                                            delFavoris(
                                                subProgramme.programme.id ?? "",
                                                context,
                                                idFav);
                                          }
                                        },
                                        icon: FutureBuilder<Widget?>(
                                          future: getFavoris(
                                              subProgramme.programme.id ?? ""),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<Widget?> snapshot) {
                                            if (snapshot.hasData) {
                                              return snapshot.data ??
                                                  const Icon(
                                                      Icons.favorite_border);
                                            } else {
                                              return const Icon(
                                                  Icons.favorite_border);
                                            }
                                          },
                                        )),
                                  ),
                                )
                              ],
                            )),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Center(
                                child: Text(
                                  subProgramme.title ?? "titre",
                                  style: politiqueConfidentialiteTitleStyle,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                subProgramme.programme.title ?? "",
                                style: typeRadioStyle,
                              ),
                            ),
                            Center(
                              child: Container(
                                  margin: const EdgeInsets.only(top: 8.0),
                                  width: 64,
                                  height: 64,
                                  decoration: const BoxDecoration(
                                      color: primaryColorsMinus,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0))),
                                  child: const Icon(
                                    Icons.multitrack_audio_outlined,
                                    size: 33,
                                  )),
                            )
                          ],
                        );
                      } else {
                        return const Center(
                          child: Text("Aucun programme en cours"),
                        );
                      }
                    } else {
                      return const Center(
                        child: Text("Aucun programme en cours"),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        scrollDirection: Axis.vertical,
      ),
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        height: _height,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(230, 230, 230, 0.37),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline_rounded),
                          const Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Text(
                              "Information",
                              style: politiqueConfidentialiteTitleStyle,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _extendArea = !_extendArea;
                                if (_extendArea == true) {
                                  _height = 194;
                                } else {
                                  _height = 64;
                                }
                              });
                            },
                            child: Container(
                                margin: const EdgeInsets.only(top: 8.0),
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(50.0))),
                                child: _extendArea == false
                                    ? const Icon(
                                        Icons.keyboard_arrow_up_rounded,
                                        size: 24,
                                      )
                                    : const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 24,
                                      )),
                          )
                        ],
                      ),
                      _extendArea
                          ? Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12.0, right: 4.0),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            'Titre:',
                                            style: fakeTabItemStyle,
                                          ),
                                        ),
                                        Text(
                                          widget.title,
                                          style: typeRadioStyle,
                                        )
                                      ],
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12.0, right: 4.0),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            'Description:',
                                            style: fakeTabItemStyle,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            widget.description,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: typeRadioStyle,
                                          ),
                                        )
                                      ],
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12.0, right: 4.0),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            'Durée:',
                                            style: fakeTabItemStyle,
                                          ),
                                        ),
                                        Text(
                                          "${widget.startDate} - ${widget.endDate}",
                                          style: typeRadioStyle,
                                        )
                                      ],
                                    )),
                              ],
                            )
                          : Container(),
                    ],
                  )),
            )),
      ),
    );
  }
}
