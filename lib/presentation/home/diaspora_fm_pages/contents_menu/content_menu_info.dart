import 'package:eden/presentation/components/card_presentation.dart';
import 'package:eden/utils/constante.dart';
import 'package:flutter/material.dart';

import '../animateur_profile_page.dart';

class ContenuMenuInfoFragment extends StatelessWidget {
  const ContenuMenuInfoFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<List<String>>? nouveautes;
    Future<List<String>>? choisiPourVous;
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
                  "Nouveautés",
                  style: fakeTabItemStyle,
                  textAlign: TextAlign.start,
                ),
                Container(
                  height: 190,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: FutureBuilder<List<String>>(
                    future: nouveautes,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<String>> snapshot) {
                      if (!snapshot.hasData) {
                        List<String>? v = snapshot.data ??
                            <String>['cc', 'hdj', 'hdj', 'hdj'];
                        return ListView.builder(
                            itemCount: v.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: null,
                                    child: const CardPresentation(
                                      assetImage: "assets/images/image.jpg",
                                      sousTitre: "publireportage",
                                      titre: "Prix africain",
                                    ),
                                  ));
                            });
                      } else {
                        return const Text(
                            "Aucune pub disponible pour l'instant");
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
                "Choisi pour vous",
                style: fakeTabItemStyle,
                textAlign: TextAlign.start,
              ),
              Container(
                height: 200,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: FutureBuilder<List<String>>(
                  future: choisiPourVous,
                  builder: (BuildContext futurecontext,
                      AsyncSnapshot<List<String>> snapshot) {
                    if (!snapshot.hasData) {
                      List<String>? v =
                          snapshot.data ?? <String>['cc', 'hdj', 'hdj', 'hdj'];
                      return ListView.builder(
                          itemCount: v.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AnimateurProfilePage(id: ""),
                                      ),
                                    );
                                  },
                                  child: const CardPresentation(
                                    assetImage: "assets/images/image.jpg",
                                    sousTitre: "publireportage",
                                    titre: "Prix africain",
                                  ),
                                ));
                          });
                    } else {
                      return const Text("Aucun animateur pour l'instant");
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
