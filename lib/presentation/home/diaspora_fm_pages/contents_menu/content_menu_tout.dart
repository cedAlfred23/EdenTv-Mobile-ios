import 'package:eden/domaine/animateur.dart';
import 'package:eden/domaine/espace_pub.dart';
import 'package:eden/infrastructure/v1/animateur_api.dart';
import 'package:eden/infrastructure/v1/espace_pub.dart';
import 'package:eden/presentation/components/alert_dialog2.dart';
import 'package:eden/presentation/components/card_presentation.dart';
import 'package:eden/presentation/home/diaspora_fm_pages/animateur_profile_page.dart';
import 'package:eden/utils/constante.dart';
import 'package:flutter/material.dart';

class ContentMenuToutFragmant extends StatelessWidget {
  const ContentMenuToutFragmant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Espace pub",
                  style: fakeTabItemStyle,
                  textAlign: TextAlign.start,
                ),
                Container(
                  height: 190,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: FutureBuilder<List<EspacePub>?>(
                    future: fetchEspacesPub(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<EspacePub>?> snapshot) {
                      // print(snapshot);
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
                                                title:
                                                    espacesPub[index].title ??
                                                        "Un titre",
                                                url: espacesPub[index].file ??
                                                    "",
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
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Animateurs",
                style: fakeTabItemStyle,
                textAlign: TextAlign.start,
              ),
              Container(
                height: 200,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: FutureBuilder<List<Animateur>?>(
                  future: fetchAimateurs(),
                  builder: (BuildContext futureContext,
                      AsyncSnapshot<List<Animateur>?> snapshot) {
                    // print(snapshot.data!.length);
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Text("Aucun animateur pour l'instant");
                      } else {
                        List<Animateur>? animateurs = snapshot.data;
                        return ListView.builder(
                            itemCount: animateurs!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              String aNom = animateurs[index].nom ?? "";
                              String aPrenom = animateurs[index].prenom ?? "";
                              return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // log("item: ${animateurs[index].id}");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AnimateurProfilePage(
                                                  id: animateurs[index].id ??
                                                      ""),
                                        ),
                                      );
                                    },
                                    child: CardPresentation(
                                      assetImage:
                                          animateurs[index].photo ?? avataImg,
                                      sousTitre: aNom + " " + aPrenom,
                                      titre: animateurs[index].type ?? "",
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
              )
            ],
          )
        ],
      ),
    );
  }
}
