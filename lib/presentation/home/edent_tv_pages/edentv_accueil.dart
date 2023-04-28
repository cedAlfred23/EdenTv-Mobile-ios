import 'dart:convert';
import 'dart:developer';

import 'package:eden/domaine/espace_pub.dart';
import 'package:eden/infrastructure/v1/espace_pub.dart';
import 'package:eden/main.dart';
import 'package:eden/presentation/components/alert_dialog.dart';
import 'package:eden/presentation/components/alert_dialog2.dart';
import 'package:eden/presentation/components/card_presentation.dart';
import 'package:eden/presentation/components/commentaire_ligne.dart';
import 'package:eden/presentation/login/login.dart';
import 'package:eden/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:eden/utils/constante.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class EdenTvAccueilPage extends StatefulWidget {
  const EdenTvAccueilPage({/*required this.player, */ Key? key})
      : super(key: key);
  // final FijkPlayer player;

  @override
  State<EdenTvAccueilPage> createState() => _EdenTvAccueilPageState();
}

class _EdenTvAccueilPageState extends State<EdenTvAccueilPage>
    with WidgetsBindingObserver {
  final double _height = 210.0;
  final Helpers _helpers = Helpers();
  // FijkPlayer player = FijkPlayer();

  bool showErrorLive = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // widget.player.start();
    player.setDataSource(urlRTMPtv, autoPlay: true, showCover: false);
    if (player.state == FijkState.error) {
      log("Erreur de lecture de la tv");
      // player.stop();
      setState(() {
        showErrorLive = true;
        try {
          // player.reset();
          // player.notifyListeners();
        } catch (e) {
          log("$e");
        }
      });
    } else if (player.state == FijkState.started) {
      radioPlayer.pause();
      setState(() {
        showErrorLive = false;
      });
    } else if (player.state == FijkState.stopped) {
      player.reset();
      setState(() {
        showErrorLive = false;
      });
    }
    player.addListener(() {
      if (player.state == FijkState.error) {
        log("Erreur de lecture de la tv");
        setState(() {
          showErrorLive = true;
        });
      }
    });

    // player.addListener(() {
    //   if (player.state == FijkState.error) {
    //     log("Erreur de lecture de la tv");
    //     // player.dispose();
    //     setState(() {
    //       showErrorLive = true;
    //       try {
    //         // player.reset();
    //         // player.notifyListeners();
    //       } catch (e) {
    //         log("$e");
    //       }
    //     });
    //   } else if (player.state == FijkState.started) {
    //     radioPlayer.pause();
    //     setState(() {
    //       showErrorLive = false;
    //       player.notifyListeners();
    //     });
    //   }
    // });
  }

  final _formKey = GlobalKey<FormState>();
  final _commentaireController = TextEditingController();
  final database = FirebaseDatabase.instance.ref();
  String emissionEnCours = "";

  // @override
  // void dispose() {
  //   super.dispose();
  //   player.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final edentvRef = database.child("edentv/");
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          !showErrorLive
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: _height,
                  alignment: Alignment.center,
                  child: FijkView(
                    player: player,
                    fit: FijkFit.fill,
                  ))
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: _height,
                  alignment: Alignment.center,
                  child: Image.asset(imageErrorLive),
                ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          elevation: 5,
                          builder: (context) {
                            double _height =
                                MediaQuery.of(context).size.height * .60;
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: 15,
                                  left: 15,
                                  right: 15,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                          15),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 18.0,
                                  ),
                                  const Text(
                                    "Commentaires",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        fontFamily: fontFamilly),
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  StreamBuilder(
                                      stream: database
                                          .child("edentv/commentaires")
                                          .limitToLast(30)
                                          .onValue,
                                      builder: (context, snapshot) {
                                        var data = <String, dynamic>{};
                                        log("snapshot ${snapshot.data}");
                                        if (snapshot.connectionState ==
                                            ConnectionState.active) {
                                          if (snapshot.data != null) {
                                            var d =
                                                (snapshot.data as DatabaseEvent)
                                                    .snapshot
                                                    .value;
                                            if (d != null) {
                                              log("data $d");
                                              data = jsonDecode(jsonEncode(d));
                                              log("$data");

                                              // ignore: unnecessary_null_comparison
                                              List r = data.entries.toList();
                                              var finalV = triCom(r);
                                              // log("test value : ${triCom(r)}");
                                              return SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: _height * .60,
                                                  child: ListView.builder(
                                                      itemCount: finalV.length,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return CommentaireLigne(
                                                            username: finalV
                                                                    .elementAt(
                                                                        index)
                                                                    .value[
                                                                "username"],
                                                            message: finalV
                                                                    .elementAt(
                                                                        index)
                                                                    .value[
                                                                "message"],
                                                            date: finalV
                                                                .elementAt(
                                                                    index)
                                                                .value["date"]);
                                                      }));
                                            } else {
                                              return SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: _height * .60,
                                                  child: const Center(
                                                    child: Text(
                                                      "Aucun commentaire...",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontFamilly,
                                                          color: Colors.black,
                                                          fontSize: 13.0,
                                                          fontStyle:
                                                              FontStyle.normal),
                                                    ),
                                                  ));
                                            }
                                          } else {
                                            return SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: _height * .60,
                                                child: const Center(
                                                  child: Text(
                                                    "Aucun commentaire...",
                                                    style: TextStyle(
                                                        fontFamily: fontFamilly,
                                                        color: Colors.black,
                                                        fontSize: 13.0,
                                                        fontStyle:
                                                            FontStyle.normal),
                                                  ),
                                                ));
                                          }
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }),
                                  SingleChildScrollView(
                                    child: Column(children: [
                                      const SizedBox(
                                        width: double.infinity,
                                        height: 35,
                                      ),
                                      Form(
                                        key: _formKey,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.75,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              child: Container(
                                                height: 50,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: TextFormField(
                                                  controller:
                                                      _commentaireController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Remplissez le champ svp";
                                                    }

                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    label: const Text(
                                                        "Commentaire"),
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Colors
                                                                  .black12),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors
                                                            .blue.shade100,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          color: Colors
                                                              .red.shade200),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: IconButton(
                                                icon: const Icon(Icons.send),
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    FirebaseAuth auth =
                                                        FirebaseAuth.instance;
                                                    User? user =
                                                        auth.currentUser;
                                                    if (user == null) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return const AlertDialogCustom(
                                                                title: "Erreur",
                                                                message:
                                                                    "Connectez-vous pour commenter cette émission",
                                                                type: "error",
                                                                backPath:
                                                                    LoginPage());
                                                          });
                                                    } else {
                                                      DateTime t =
                                                          DateTime.now();
                                                      String date_ = t.year
                                                              .toString() +
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
                                                      edentvRef
                                                          .child("commentaires")
                                                          .push()
                                                          .set({
                                                            'useruid': user.uid,
                                                            'username': user
                                                                .displayName,
                                                            'message':
                                                                _commentaireController
                                                                    .text,
                                                            'date': date_,
                                                            'timestemp': DateTime
                                                                    .now()
                                                                .millisecondsSinceEpoch
                                                          })
                                                          .then((value) => {
                                                                _commentaireController
                                                                    .text = ""
                                                              })
                                                          .catchError((error) {
                                                            log(error
                                                                .toString());
                                                          });
                                                    }
                                                  }
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ]),
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, right: 16.0, left: 16.0),
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
                    )),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, right: 16.0, left: 16.0),
                  child: GestureDetector(
                    onTap: () async {
                      await _helpers.share(
                          "Eden TV",
                          "Hey! viens regarder l'emission " +
                              emissionEnCours +
                              " en direct sur EDENTV-DIASPORAFM.",
                          "Partager Eden Tv",
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
                ),
              ]),
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0, left: 16.0),
                child: Text(
                  "Espace pub",
                  style: fakeTabItemStyle,
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                height: 190,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FutureBuilder<List<EspacePub>?>(
                  future: fetchEspacesPub(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<EspacePub>?> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Text("Aucune publicité pour l'instant");
                      } else {
                        List<EspacePub>? espacesPub = snapshot.data;
                        return ListView.builder(
                            itemCount: espacesPub!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // print("test");
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialogPub2(
                                              desc: espacesPub[index]
                                                      .description ??
                                                  "Une descripion totalement incroyable",
                                              title: espacesPub[index].title ??
                                                  "Un titre",
                                              url: espacesPub[index].file ?? "",
                                              couverture: espacesPub[index]
                                                      .couverture ??
                                                  "",
                                            );
                                          });
                                    },
                                    child: CardPresentation(
                                      assetImage:
                                          espacesPub[index].couverture ??
                                              "assets/images/image.jpg",
                                      sousTitre:
                                          espacesPub[index].description ??
                                              "publireportage",
                                      titre: espacesPub[index].title ??
                                          "Prix africain",
                                    ),
                                  ));
                            });
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ]);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      log("lifecycle");
      player.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

    // player.pause();
    // player.stop();
    // player.release();
    // player.pause();
  }
}
