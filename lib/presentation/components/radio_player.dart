import 'dart:developer';
// import 'dart:ui';

import 'package:eden/domaine/favoris.dart';
import 'package:eden/domaine/favoris_obj.dart';
import 'package:eden/domaine/sub_programme.dart';
import 'package:eden/domaine/user.dart';
import 'package:eden/infrastructure/v1/account.dart';
import 'package:eden/infrastructure/v1/favoris.dart';
import 'package:eden/infrastructure/v1/sub_programme.dart';
import 'package:eden/main.dart';
import 'package:eden/presentation/components/alert_dialog.dart';
import 'package:eden/presentation/login/login.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/helpers.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../home/diaspora_fm_pages/radio_details_2.dart';

class RadioPlayerComponent extends StatefulWidget {
  const RadioPlayerComponent({Key? key}) : super(key: key);

  // final FijkPlayer playerTv;

  @override
  RadioPlayerComponentState createState() => RadioPlayerComponentState();
}

class RadioPlayerComponentState extends State<RadioPlayerComponent> {
  // RadioPlayerComponent r = RadioPlayerComponent(playerTv: widget.playerTv,);
  bool isplaying = true;
  late List<String?> metadata;
  final double _height = 110.0;

  @override
  void initState() {
    super.initState();
    initRadioService();
    // widget.playerTv.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    radioPlayer.stop();
  }

  Future<void> initRadioService() async {
    try {
      RadioPlayerComponent r = const RadioPlayerComponent();
      r.createElement();
      radioPlayer.stateStream.listen((event) {
        if (player.state == FijkState.started) {
          player.pause();
        }
        if (mounted) {
          setState(() {
            isplaying = event;
          });
        }
        log("event stream = $event");
      });
    } on PlatformException {
      log("Exception occured while trying to register the service");
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
    return Container(
        height: _height,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<SubProgramme?>(
              future: getCurrentEmission("RADIO"),
              builder: (BuildContext context,
                  AsyncSnapshot<SubProgramme?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    SubProgramme? subProgramme = snapshot.data;
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RadioDetails2(
                                          description: subProgramme!
                                                  .programme.description ??
                                              "desc",
                                          endDate: subProgramme.endTime ?? "-",
                                          startDate:
                                              subProgramme.startTime ?? "-",
                                          title: subProgramme.title ?? "")));
                            },
                            icon: const Icon(Icons.arrow_drop_up),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: IconButton(
                                    onPressed: () async {
                                      String idFav = await isFavoris(
                                          subProgramme!.programme.id ?? "");
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
                                          subProgramme!.programme.id ?? ""),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<Widget?> snapshot) {
                                        if (snapshot.hasData) {
                                          return snapshot.data ??
                                              const Icon(Icons.favorite_border);
                                        } else {
                                          return const Icon(
                                              Icons.favorite_border);
                                        }
                                      },
                                    )),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: SizedBox(
                                        width: 150,
                                        child: Text(
                                          subProgramme.title ?? "Inconnu",
                                          style: valueTextStyle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      )),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      subProgramme.programme.title ?? "desc",
                                      style: serviceDescStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ]);
                  } else {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const RadioDetails2(
                                          description:
                                              "Emission radio en direct",
                                          endDate: "-",
                                          startDate: "-",
                                          title: "Emission")));
                            },
                            icon: const Icon(Icons.arrow_drop_up),
                          ),
                          const Text(
                            "Emission",
                            style: valueTextStyle,
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  return Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RadioDetails2(
                                      description: "Emission radio en direct",
                                      endDate: "-",
                                      startDate: "-",
                                      title: "Emission")));
                        },
                        icon: const Icon(Icons.arrow_drop_up),
                      ),
                      const Text(
                        "Emission",
                        style: valueTextStyle,
                      ),
                    ],
                  ));
                }
              },
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 2.0),
                  child: Icon(Icons.radio_button_on_outlined,
                      color: Colors.redAccent),
                ),
                const Text(
                  "En Direct",
                  style: serviceDescStyle,
                ),
                const Spacer(),
                Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: GestureDetector(
                      child: isplaying
                          ? Image.asset(
                              imagePause,
                              width: 24,
                              height: 24,
                            )
                          : Image.asset(
                              imagePlay,
                              width: 24,
                              height: 24,
                            ),
                      onTap: () async {
                        // print("snapshot");

                        // radioPlayer.metadataStream
                        //     .elementAt(4)
                        //     .then((value) => {print(value)});
                        setState(() {
                          isplaying ? radioPlayer.pause() : radioPlayer.play();
                          isplaying = !isplaying;
                        });
                      },
                    )),
              ],
            ),
          ],
        ));
  }
}
