import 'dart:developer';

import 'package:eden/domaine/favoris_obj.dart';
import 'package:eden/domaine/programme.dart';
import 'package:eden/domaine/sub_programme.dart';
import 'package:eden/infrastructure/v1/favoris.dart';
import 'package:eden/infrastructure/v1/sub_programme.dart';
import 'package:eden/presentation/components/alert_dialog.dart';
import 'package:eden/presentation/components/alert_dialog_pod.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/helpers.dart';
import 'package:flutter/material.dart';

class EmissionPage extends StatefulWidget {
  const EmissionPage(
      {required this.userLoggin, required this.haveFav, Key? key})
      : super(key: key);
  final bool userLoggin;
  final Future<bool> haveFav;
  @override
  State<EmissionPage> createState() => _EmissionPageState();
}

class _EmissionPageState extends State<EmissionPage> {
  bool haveFav = true;
  Future<List<Programme>> favorisList() async {
    Helpers helpers = Helpers();
    String? userId = await helpers.getString(idKey);
    List<Programme> programmesFav = [];
    if (userId != null) {
      List<FavorisObj> favO = await fetchFavorisList(userId);

      // log(" valueid $userId");
      if (favO.isNotEmpty) {
        for (var item1 in favO) {
          if (item1.programme.type == "RADIO" ||
              item1.programme.type == "RADIO / TV") {
            programmesFav.add(item1.programme);
          }
        }
      }
    }
    return programmesFav;
  }

  List<Programme> favL = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      setState(() {
        widget.haveFav.then((value) {
          haveFav = value;
          log("fav value = $value");
        });
      });
    }

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 320,
          minHeight: 480,
        ),
        child: Container(
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              FutureBuilder<bool>(
                future: widget.haveFav,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  bool? resulta = snapshot.data;
                  if (resulta ?? false) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            "Programme(s) Favoris",
                            style: politiqueConfidentialiteTitleStyle,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .18,
                          child: FutureBuilder<List<Programme>>(
                              future: favorisList(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Programme>> snapshot) {
                                log("valuuuuu $haveFav");
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  // log("snapshot: $snapshot");
                                  if (snapshot.hasData) {
                                    List<Programme>? programmes = snapshot.data;

                                    return ListView.builder(
                                      itemCount: programmes!.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 77,
                                                height: 74,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                4.0)),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            programmes[index]
                                                                    .couverture ??
                                                                ""),
                                                        fit: BoxFit.cover),
                                                    color: Colors.grey),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 8.0),
                                                width: 77,
                                                child: Text(
                                                  programmes[index].title ??
                                                      "inconnu",
                                                  style: descStyle,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return const Center(
                                        child:
                                            Text("Aucun programme en favoris"));
                                  }
                                } else {
                                  return const Center(
                                      child:
                                          Text("Aucun programme en favoris"));
                                }
                              }),
                        )
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0, top: 16.0),
                child: Text(
                  "Podcast",
                  style: politiqueConfidentialiteTitleStyle,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .54,
                child: FutureBuilder<List<SubProgramme>>(
                  future: getEmission("RADIO"),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<SubProgramme>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      // log("snapshot: $snapshot");
                      if (snapshot.hasData) {
                        List<SubProgramme>? subProgrammes = snapshot.data;

                        return ListView.builder(
                          itemCount: subProgrammes!.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 77,
                                    height: 74,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4.0)),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                subProgrammes[index]
                                                        .programme
                                                        .couverture ??
                                                    ""),
                                            fit: BoxFit.cover),
                                        color: Colors.grey),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 195,
                                            child: Text(
                                              subProgrammes[index].title ??
                                                  "inconnu",
                                              style: animateurDesign,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 4.0,
                                            ),
                                            child: SizedBox(
                                              width: 195,
                                              child: Text(
                                                subProgrammes[index]
                                                        .programme
                                                        .description ??
                                                    "inconnu",
                                                style: styleSmallText,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 4.0,
                                              ),
                                              child: SizedBox(
                                                width: 195,
                                                child: Text(
                                                  subProgrammes[index]
                                                          .animateur ??
                                                      "inconnu",
                                                  style: descStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  subProgrammes[index].file != null
                                      ? Container(
                                          width: 38,
                                          height: 38,
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
                                          decoration: const BoxDecoration(
                                              color: primaryColors,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30.0))),
                                          child: IconButton(
                                            onPressed: () {
                                              log("file : ${subProgrammes[index].file}");
                                              if (subProgrammes[index].file ==
                                                  null) {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialogCustom(
                                                          title: "Info",
                                                          message:
                                                              "Fichier pas encore disponible",
                                                          type: alertDialogInfo,
                                                          backPath: EmissionPage(
                                                              userLoggin: widget
                                                                  .userLoggin,
                                                              haveFav: widget
                                                                  .haveFav));
                                                    });
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialogPod(
                                                        url:
                                                            subProgrammes[index]
                                                                    .file ??
                                                                "",
                                                        title:
                                                            subProgrammes[index]
                                                                    .title ??
                                                                "",
                                                        desc: subProgrammes[
                                                                    index]
                                                                .programme
                                                                .description ??
                                                            "",
                                                        couverture:
                                                            subProgrammes[index]
                                                                    .programme
                                                                    .couverture ??
                                                                "",
                                                      );
                                                    });
                                              }
                                            },
                                            icon: const Icon(Icons.play_arrow),
                                            color: Colors.white,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text("Aucune émission"));
                      }
                    } else {
                      return const Center(child: Text("Aucune émission"));
                    }
                  },
                ),
              )
            ])),
      ),
      scrollDirection: Axis.vertical,
    );
  }
}
