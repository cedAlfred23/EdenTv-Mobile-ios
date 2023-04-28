import 'package:eden/domaine/contact.dart';
import 'package:eden/infrastructure/v1/contact.dart';
import 'package:eden/presentation/components/alert_dialog.dart';
import 'package:eden/presentation/login/login.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/custom_launch.dart';
import 'package:eden/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'home.dart';

class ContactFormPage extends StatefulWidget {
  const ContactFormPage(
      {required this.contact,
      required this.serviceTitle,
      required this.where,
      Key? key})
      : super(key: key);
  final String contact;
  final String serviceTitle;
  final String where;

  @override
  State<ContactFormPage> createState() => _ContactFormPageState();
}

class _ContactFormPageState extends State<ContactFormPage> {
  final emailController = TextEditingController();
  final objetController = TextEditingController();
  final messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Helpers helpers = Helpers();
  String? id = "";

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    // log("contact: $contact");
    // log("serviceTitle: $serviceTitle");

    User? user = auth.currentUser;
    if (user != null) {
      setState(() {
        emailController.text = user.email ?? "";
      });
    }
    Future<bool> _onBackPressed() {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              selectedIndexForBottomNavigation: 4,
              selectedIndexForTabBar: widget.where == "diaspora_fm" ? 0 : 1,
            ),
          ));
      return Future.value(false);
    }

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: const Text(
                "Contact",
                style: titleTextStyle,
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        selectedIndexForBottomNavigation: 4,
                        selectedIndexForTabBar:
                            widget.where == "eden_tv" ? 1 : 0,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_back_ios),
                color: Colors.black,
                padding: const EdgeInsets.only(left: 16.0),
              ),
            ),
            body: Center(
              child: Form(
                  key: _formKey,
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: (MediaQuery.of(context).size.width - 32),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Nous contacter",
                              style: politiqueConfidentialiteTitleStyle),
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Remplissez le champ svp";
                                } else if (!value.contains("@") ||
                                    !value.contains(".")) {
                                  return "Email invalide";
                                } else {
                                  return null;
                                }
                              },
                              controller: emailController,
                              decoration: InputDecoration(
                                label: const Text(
                                  "Entrez votre email",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: fontFamilly,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
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
                                      width: 2, color: Colors.red.shade200),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: TextFormField(
                              controller: objetController,
                              validator: (value) {
                                if (value == null || value.length <= 1) {
                                  return "Message trop court";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "L'objet de votre message",
                                label: const Text(
                                  "Objet de votre message",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: fontFamilly,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
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
                                      width: 2, color: Colors.red.shade200),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: TextFormField(
                              maxLines: 5,
                              controller: messageController,
                              validator: (value) {
                                if (value == null || value.length <= 1) {
                                  return "Message trop court";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText:
                                    "Pourrai-je avoir plus d'informations sur vos services?",
                                hintStyle: const TextStyle(
                                    fontFamily: fontFamilly,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                                label: const Text(
                                  "Laisser un message",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: fontFamilly,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
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
                                      width: 2, color: Colors.red.shade200),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    id = await helpers.getString(idKey) ?? "";
                                    log("id = $id");

                                    if (user == null) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const AlertDialogCustom(
                                                title: "Echec d'envoi",
                                                message:
                                                    "Veuillez créer un compte ou connectez-vous",
                                                type: "error",
                                                backPath: LoginPage());
                                          });
                                    } else {
                                      try {
                                        // log("id: $id");
                                        id = await helpers.getString(idKey);
                                        sendContact(Contact(
                                                id: "",
                                                user: id,
                                                object: objetController.text,
                                                content: messageController.text,
                                                service: widget.serviceTitle))
                                            .whenComplete(() => {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialogCustom(
                                                            title: "Succès",
                                                            message:
                                                                "Message bien envoyé, nous vous recontacterons bientôt",
                                                            type: "success",
                                                            backPath: HomePage(
                                                              selectedIndexForBottomNavigation:
                                                                  4,
                                                              selectedIndexForTabBar:
                                                                  widget.where ==
                                                                          "diaspora_fm"
                                                                      ? 0
                                                                      : 1,
                                                            ));
                                                      })
                                                });
                                      } catch (e) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialogCustom(
                                                  title: "Echec d'envoi",
                                                  message:
                                                      "Message non envoyé, veuillez reessayer svp!",
                                                  type: "error",
                                                  backPath: HomePage(
                                                    selectedIndexForBottomNavigation:
                                                        4,
                                                    selectedIndexForTabBar:
                                                        widget.where ==
                                                                "diaspora_fm"
                                                            ? 0
                                                            : 1,
                                                  ));
                                            });
                                      }
                                    }
                                  }
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        primaryColors)),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 32.0, vertical: 4.0),
                                  child: Text(
                                    "Envoyer",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                )),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                            child: Center(
                                child: Text(
                              "Nos réseaux sociaux",
                              style: coloredText,
                            )),
                          ),
                          Container(
                            height: 64,
                            width: (MediaQuery.of(context).size.width - 32),
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (!await customLaunchUrl(
                                            widget.where == "diaspora_fm"
                                                ? urlYoutubeDiaspora
                                                : urlYoutubeEden)) {
                                          throw 'Could not launch ' +
                                                      widget.where ==
                                                  "diaspora_fm"
                                              ? urlYoutubeDiaspora
                                              : urlYoutubeEden;
                                        }
                                      },
                                      child: Image.asset(
                                        youtubeImage,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (!await customLaunchUrl(
                                            widget.where == "diaspora_fm"
                                                ? urlFacebookDiaspora
                                                : urlFacebookEden)) {
                                          throw 'Could not launch ' +
                                                      widget.where ==
                                                  "diaspora_fm"
                                              ? urlFacebookDiaspora
                                              : urlFacebookEden;
                                        }
                                      },
                                      child: Image.asset(
                                        facebookImage,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (!await customLaunchUrl(
                                            widget.where == "diaspora_fm"
                                                ? urlTwitterDiaspora
                                                : urlTwitterEden)) {
                                          throw 'Could not launch ' +
                                                      widget.where ==
                                                  "diaspora_fm"
                                              ? urlTwitterDiaspora
                                              : urlTwitterEden;
                                        }
                                      },
                                      child: Image.asset(
                                        twitterImage,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ))),
            )));
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    objetController.dispose();
    messageController.dispose();
  }
}
