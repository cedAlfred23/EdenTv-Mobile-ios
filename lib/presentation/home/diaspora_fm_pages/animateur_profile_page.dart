// import 'dart:developer';
import 'package:eden/domaine/animateur.dart';
import 'package:eden/infrastructure/v1/animateur_api.dart';
import 'package:eden/presentation/home/home.dart';
import 'package:eden/presentation/home_beta/home_beta.dart';
import 'package:eden/utils/constante.dart';
import 'package:flutter/material.dart';

class AnimateurProfilePage extends StatelessWidget {
  const AnimateurProfilePage({required this.id, Key? key}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    // String email = "johndoe@test.com";
    // String nom = 'Rick Joe';
    // String telephone = '+229 96 79 73 24';
    // log("id anmateur: $id");

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: const Text(
            "Profil Animateur",
            style: titleTextStyle,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => isBeta
                      ? const HomeBetaPage()
                      : HomePage(
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
        body: FutureBuilder<Animateur?>(
          future: fetchAnimateur(id),
          builder: (BuildContext context, AsyncSnapshot<Animateur?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasData) {
                Animateur? animateur = snapshot.data;
                String anom = animateur!.nom ?? "";
                String aprenm = animateur.prenom ?? "";
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          child: SizedBox(
                            width: 106,
                            height: 106,
                            child: ClipOval(
                              child: Image(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      animateur.photo ?? avataImg)),
                            ),
                          ),
                          padding:
                              const EdgeInsets.only(top: 18.0, bottom: 16.0),
                        ),
                      ),
                      const Text(
                        'Informations personnelles',
                        style: politiqueConfidentialiteTitleStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //   padding: EdgeInsets.only(bottom: 8.0),
                            //   child: Row(
                            //     children: [
                            //       Padding(
                            //         padding: EdgeInsets.only(right: 8.0),
                            //         child: Text('Email:'),
                            //       ),
                            //       Text(
                            //         animateur!.contact ?? email,
                            //         style: fakeTabItemStyle,
                            //       )
                            //     ],
                            //   ),
                            // ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Text('Nom :'),
                                  ),
                                  Text(
                                    anom + " " + aprenm,
                                    style: fakeTabItemStyle,
                                  )
                                ],
                              ),
                            ),
                            // Container(
                            //   padding: const EdgeInsets.only(bottom: 8.0),
                            //   child: Row(
                            //     children: [
                            //       const Padding(
                            //         padding: EdgeInsets.only(right: 8.0),
                            //         child: Text('Contact :'),
                            //       ),
                            //       Text(
                            //         animateur.contact ?? telephone,
                            //         style: fakeTabItemStyle,
                            //       )
                            //     ],
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color.fromRGBO(158, 158, 158, 1),
                        height: 0.5,
                        thickness: 0.5, // thickness of the line
                        endIndent: 0,
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text("Animateur introuvable"),
                );
              }
            }
          },
        ));
  }
}
