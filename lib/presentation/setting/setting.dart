import 'dart:developer';

import 'package:eden/domaine/user.dart';
import 'package:eden/infrastructure/v1/account.dart';
import 'package:eden/presentation/components/alert_dialog.dart';
import 'package:eden/presentation/home/home.dart';
// import 'package:eden/presentation/home_beta/home_beta.dart';
// import 'package:eden/presentation/setting/politique_confidentialite.dart';
import 'package:eden/presentation/setting/profile_update.dart';
import 'package:eden/utils/authentication.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/custom_launch.dart';
import 'package:eden/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final String version = "1.7.1";

  @override

  // final bool isBeta = true;

  @override
  Widget build(BuildContext context) {
    Authentication auth = Authentication();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;
    // = CurrentUser(
    //     id: "",
    //     uid: "",
    //     firstName: "",
    //     lastName: "",
    //     countryCode: "",
    //     country: "",
    //     providerId: "",
    //     displayName: "",
    //     numero: "",
    //     email: "",
    //     photoURL: "",
    //     fromFacebook: false,
    //     fromGoogle: false,
    //     fromApple: false,
    //     forSave: false,
    //     token: "",
    //     notifyOnProgram: false);
    // if (user != null) {
    //   getConnectedUser(user.uid).then((value) => cUser = value);
    // }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          "Paramètres",
          style: titleTextStyle,
        ),
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileUpdatePage(),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Expanded(
                          child: Text(
                        "Compte et Sécurité",
                        style: settingStyle,
                      )),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14.0,
                      )
                    ],
                  ),
                )),

            user != null
                ? FutureBuilder<CurrentUser?>(
                    future: getConnectedUserStore(),
                    builder: (BuildContext context,
                        AsyncSnapshot<CurrentUser?> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data != null) {
                          CurrentUser? cUser = snapshot.data;
                          log(" value of $cUser");
                          if (cUser!.id != "") {
                            log("setting: ${snapshot.data!.id}");
                            Helpers().putString(idKey, snapshot.data!.id);
                            bool value_ = cUser.notifyOnProgram;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 18.0),
                              child: Row(
                                children: [
                                  const Expanded(
                                      child: Text(
                                    "M'avertir des nouveautés",
                                    style: settingStyle,
                                  )),
                                  GestureDetector(
                                    child: Switch(
                                        value: value_,
                                        onChanged: (value) {
                                          log("switch val: $value");
                                          Helpers()
                                              .putBoolean("NEWSLETTER", value);
                                          setState(() {
                                            value_ = value;
                                            auth
                                                .addToNews(
                                                    !cUser.notifyOnProgram)
                                                .then((value) =>
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SettingPage(),
                                                      ),
                                                    ));
                                          });
                                        }),
                                    onTap: () {
                                      setState(() {});
                                    },
                                  )
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        } else {
                          return const SizedBox.shrink();
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                    })
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.only(bottom: 28.0),
              child: GestureDetector(
                onTap: () async {
                  if (!await customLaunchUrl(urlCGU)) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialogCustom(
                              title: "Attention",
                              message: "Erreur d'ouverture des CGU",
                              type: "warning",
                              backPath: SettingPage());
                        });
                    throw 'Could not launch ' + urlCGU;
                  }

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) =>
                  //           const PolitiqueConfidentialitePage(),
                  //     ));
                },
                child: Row(
                  children: const [
                    Expanded(
                        child: Text(
                      "Politique de confidentialité",
                      style: settingStyle,
                    )),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14.0,
                    )
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 28.0),
                child: GestureDetector(
                  onTap: null,
                  child: Row(
                    children: [
                      const Expanded(
                          child: Text(
                        "A propos",
                        style: settingStyle,
                      )),
                      Row(
                        children: [
                          Text(
                            version,
                            style: const TextStyle(
                                fontSize: 13.0, color: Colors.grey),
                          ),
                          // const Icon(
                          //   Icons.arrow_forward_ios,
                          //   size: 14.0,
                          // )
                        ],
                      )
                    ],
                  ),
                )),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 28.0),
            //   child: GestureDetector(
            //     onTap: null,
            //     child: const Expanded(
            //         child: Text(
            //       "FAQ",
            //       style: settingStyle,
            //     )),
            //   ),
            // ),
            user != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () async {
                        auth.signOut(context);
                      },
                      child: Center(
                        child: GestureDetector(
                          child: Text(
                            "Log out",
                            style: TextStyle(
                                color: Colors.red[500],
                                fontSize: 16.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ))
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

class SwitchButton extends StatefulWidget {
  const SwitchButton({Key? key}) : super(key: key);
  @override
  _SwitchButtonState createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  // bool isSwitched = false;
  Authentication auth = Authentication();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = firebaseAuth.currentUser;
    bool value_ = false;
    return user != null
        ? FutureBuilder<CurrentUser>(
            future: getConnectedUser(user.uid),
            builder:
                (BuildContext context, AsyncSnapshot<CurrentUser> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  CurrentUser? cUser = snapshot.data;
                  log("setting: ${snapshot.data}");
                  value_ = cUser!.notifyOnProgram;
                  return Switch(
                      value: value_,
                      onChanged: (value) {
                        log("switch val: $value");
                        Helpers helpers = Helpers();
                        helpers.putBoolean("NEWSLETTER", value);
                        setState(() {
                          value_ = value;
                          auth.addToNews(!cUser.notifyOnProgram);
                        });
                      });
                } else {
                  return const CircularProgressIndicator();
                }
              } else {
                return const CircularProgressIndicator();
              }
            })
        : const CircularProgressIndicator();
  }
}
