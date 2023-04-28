/*
Name: Akshath Jain
Date: 3/18/2019 - 4/26/2021
Purpose: Example app that implements the package: sliding_up_panel
Copyright: © 2021, Akshath Jain. All rights reserved.
Licensing: More information can be found here: https://github.com/akshathjain/sliding_up_panel/blob/master/LICENSE
*/

import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:eden/domaine/favoris.dart';
import 'package:eden/domaine/favoris_obj.dart';
import 'package:eden/domaine/sub_programme.dart';
import 'package:eden/domaine/user.dart';
import 'package:eden/infrastructure/v1/account.dart';
import 'package:eden/infrastructure/v1/favoris.dart';
import 'package:eden/infrastructure/v1/sub_programme.dart';
import 'package:eden/presentation/components/alert_dialog.dart';
import 'package:eden/presentation/components/commentaire_ligne.dart';
import 'package:eden/presentation/login/login.dart';
import 'package:eden/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:eden/utils/constante.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong/latlong.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class RadioDetails2 extends StatefulWidget {
  const RadioDetails2(
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
  _RadioDetails2State createState() => _RadioDetails2State();
}

class _RadioDetails2State extends State<RadioDetails2> {
  final double _initFabHeight = 120.0;
  double fabHeight = 0;
  double _panelHeightOpen = 0;
  final double _panelHeightClosed = 95.0;
  bool commentairePanelVisible = false;

  @override
  void initState() {
    super.initState();
    fabHeight = _initFabHeight;
    _activateListeners();
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
      log("${currentUser.id}");
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

  final _formKey = GlobalKey<FormState>();
  final _commentaireController = TextEditingController();
  final database = FirebaseDatabase.instance.ref();

  void _activateListeners() {
    // database.child("diasporafm/commentaires").onValue.listen((event) {
    //   final String description = event.snapshot.value as String;
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = commentairePanelVisible
        ? MediaQuery.of(context).size.height * .80
        : MediaQuery.of(context).size.height * .30;
    final diasporafmRef = database.child("diasporafm/");
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: commentairePanelVisible
                ? MediaQuery.of(context).size.height * .80
                : _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: _body(),
            panelBuilder: (sc) => _panel(sc),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {
              fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
            }),
          ),

          Positioned(
              top: 0,
              child: ClipRRect(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).padding.top,
                        color: Colors.transparent,
                      )))),

          //the SlidingUpPanel Title
        ],
      ),
      bottomSheet: commentairePanelVisible
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Form(
                key: _formKey,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFormField(
                          controller: _commentaireController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Remplissez le champ svp";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            label: const Text("Commentaire"),
                            border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue.shade100,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.red.shade200),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            FirebaseAuth auth = FirebaseAuth.instance;
                            User? user = auth.currentUser;
                            if (user == null) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AlertDialogCustom(
                                        title: "Erreur",
                                        message:
                                            "Connectez-vous pour commenter cette émission",
                                        type: "error",
                                        backPath: LoginPage());
                                  });
                            } else {
                              DateTime t = DateTime.now();
                              String date_ = t.year.toString() +
                                  "-" +
                                  t.month.toString() +
                                  "-" +
                                  t.day.toString() +
                                  " " +
                                  t.hour.toString() +
                                  ":" +
                                  t.minute.toString() +
                                  ":" +
                                  t.second.toString();
                              diasporafmRef
                                  .child("commentaires")
                                  .push()
                                  .set({
                                    'useruid': user.uid,
                                    'username': user.displayName,
                                    'message': _commentaireController.text,
                                    'date': date_,
                                    'timestemp':
                                        DateTime.now().millisecondsSinceEpoch
                                  })
                                  .then((value) =>
                                      {_commentaireController.text = ""})
                                  .catchError((error) {
                                    log("$error");
                                    return error;
                                  });
                            }
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          : const SizedBox(
              height: 0,
              width: 0,
            ),
    );
  }

  Widget _panel(ScrollController sc) {
    return ListView(
      controller: sc,
      children: <Widget>[
        const SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.all(Radius.circular(12.0))),
            ),
          ],
        ),
        const SizedBox(
          height: 18.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              commentairePanelVisible ? "Commentaires" : "Informations",
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0,
                  fontFamily: fontFamilly),
            ),
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: commentairePanelVisible
              ? [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    width: MediaQuery.of(context).size.width,
                    height: _panelHeightOpen * .70,
                    child: StreamBuilder(
                        stream: database
                            .child("diasporafm/commentaires")
                            .limitToLast(30)
                            .onValue,
                        builder: (context, snapshot) {
                          var data = <String, dynamic>{};
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            log("$snapshot");
                            if (snapshot.data != null) {
                              var d = (snapshot.data as DatabaseEvent)
                                  .snapshot
                                  .value;
                              if (d != null) {
                                log("data $d");

                                data = jsonDecode(jsonEncode(d));

                                // log("data 2 ${data}");

                                // ignore: unnecessary_null_comparison

                                List r = data.entries.toList();

                                var finalV = triCom(r);
                                // log("test value : ${triCom(r)}");

                                return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: _panelHeightOpen * .70,
                                    child: ListView.builder(
                                        itemCount: finalV.length,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return CommentaireLigne(
                                              username: finalV
                                                  .elementAt(index)
                                                  .value["username"],
                                              message: finalV
                                                  .elementAt(index)
                                                  .value["message"],
                                              date: finalV
                                                  .elementAt(index)
                                                  .value["date"]);
                                        }));
                              } else {
                                return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: _panelHeightOpen * .70,
                                    child: const Center(
                                      child: Text(
                                        "Aucun commentaire...",
                                        style: TextStyle(
                                            fontFamily: fontFamilly,
                                            color: Colors.black,
                                            fontSize: 13.0,
                                            fontStyle: FontStyle.normal),
                                      ),
                                    ));
                              }
                            } else {
                              return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: _panelHeightOpen * .70,
                                  child: const Center(
                                    child: Text(
                                      "Aucun commentaire...",
                                      style: TextStyle(
                                          fontFamily: fontFamilly,
                                          color: Colors.black,
                                          fontSize: 13.0,
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ));
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                ]
              : [
                  Padding(
                      padding: const EdgeInsets.only(right: 4.0, left: 16.0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Titre:',
                              style: fakeTabItemStyle,
                            ),
                          ),
                          SizedBox(
                              width: 150,
                              child: Text(
                                widget.title,
                                style: valueRadioTextStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ))
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 12.0, right: 4.0, left: 16.0),
                      child: Row(
                        children: [
                          const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: SizedBox(
                                width: 100,
                                child: Text(
                                  'Description:',
                                  style: fakeTabItemStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                              )),
                          SizedBox(
                            width: 200,
                            child: Text(
                              widget.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: valueRadioTextStyle,
                            ),
                          )
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 12.0, right: 4.0, left: 16.0),
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
                            style: valueRadioTextStyle,
                          )
                        ],
                      )),
                ],
        )
      ],
    );
  }

  Widget _body() {
    Helpers _helpers = Helpers();
    String emissionTitle = "";
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 320,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 64.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    commentairePanelVisible = !commentairePanelVisible;
                  });
                },
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
                      "Hey! viens écouter l'émission " +
                          emissionTitle +
                          " en direct de la radio sur EDENTV-DIASPORAFM.",
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
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      SubProgramme? subProgramme = snapshot.data;
                      emissionTitle =
                          subProgramme != null ? subProgramme.title ?? "" : "";
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
                                          color:
                                              Color.fromRGBO(130, 130, 130, 1),
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
                                child: SizedBox(
                              width: 200,
                              child: Text(
                                subProgramme.title ?? "titre",
                                style: politiqueConfidentialiteTitleStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            )),
                          ),
                          Center(
                            child: SizedBox(
                                width: 200,
                                child: Text(
                                  subProgramme.programme.title ?? "",
                                  style: typeRadioStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                )),
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
                      return Center(
                        child: Column(
                          children: [
                            Center(
                                child: Stack(
                              children: [
                                Container(
                                  width: 235,
                                  height: 255,
                                  margin: const EdgeInsets.only(bottom: 38.0),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(imageBetaFM))),
                                ),
                              ],
                            )),
                            const Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Center(
                                  child: SizedBox(
                                width: 200,
                                child: Text(
                                  "Emission Radio",
                                  style: politiqueConfidentialiteTitleStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                              )),
                            ),
                            const Center(
                              child: SizedBox(
                                  width: 200,
                                  child: Text(
                                    "Emission",
                                    style: typeRadioStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  )),
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
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: Column(
                        children: [
                          Center(
                              child: Stack(
                            children: [
                              Container(
                                width: 235,
                                height: 255,
                                margin: const EdgeInsets.only(bottom: 16.0),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(imageBetaFM))),
                              ),
                            ],
                          )),
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Center(
                                child: SizedBox(
                              width: 200,
                              child: Text(
                                "Emission Radio",
                                style: politiqueConfidentialiteTitleStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            )),
                          ),
                          const Center(
                            child: SizedBox(
                                width: 200,
                                child: Text(
                                  "Emission",
                                  style: typeRadioStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                )),
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
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      scrollDirection: Axis.vertical,
    );
  }
}
