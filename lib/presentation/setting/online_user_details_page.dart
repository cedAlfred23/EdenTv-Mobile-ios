// ignore: file_names
import 'dart:developer';
import 'dart:io' as io;

import 'package:eden/domaine/user.dart';
import 'package:eden/presentation/components/alert_dialog_remove.dart';
import 'package:eden/presentation/setting/setting.dart';
import 'package:eden/presentation/setting/update_user_page.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class OnlineUserDetailsPage extends StatefulWidget {
  const OnlineUserDetailsPage(
      {required this.userDetails, required this.user, Key? key})
      : super(key: key);
  final CurrentUser userDetails;
  final User? user;
  @override
  State<OnlineUserDetailsPage> createState() => _OnlineUserDetailsPageState();
}

class _OnlineUserDetailsPageState extends State<OnlineUserDetailsPage> {
  @override
  initState() {
    super.initState();
  }

  Helpers helpers = Helpers();
  late XFile imagePicked;
  final ImagePicker _imagePicker = ImagePicker();
  late io.File imagePhoto;
  @override
  Widget build(BuildContext context) {
    // print(widget.userDetails);

    String email = widget.user!.email.toString();

    String nom = widget.user!.displayName.toString();

    // String pseudo = widget.userDetails.pseudo ?? "unsaved";

    String telephone = widget.userDetails.numero ?? "unsaved";
    String? photoUrl = widget.user!.photoURL;
    try {
      imagePhoto = io.File(photoUrl.toString());
      helpers.putString(photoKey, imagePhoto.path);
    } catch (e) {
      log("$e");
    }
    log("photo url : $photoUrl");
    var fileExist = io.File(photoUrl.toString()).exists();

    // helpers.putString(pseudoKey, pseudo);
    helpers.putString(telKey, telephone);
    helpers.putString(emailKey, email);
    helpers.putString(nomKey, widget.userDetails.firstName);
    helpers.putString(prenomKey, widget.userDetails.lastName);
    helpers.putString(idKey, widget.userDetails.id);
    helpers.putString(uidKey, widget.user!.uid);
    helpers.putBoolean("NEWSLETTER", widget.userDetails.notifyOnProgram);
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingPage(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          padding: const EdgeInsets.only(left: 16.0),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UpdateUserPage(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Image.asset(
                      editIcon,
                      width: 14,
                      height: 14,
                      color: primaryColors,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 4.0, right: 16.0),
                      child: Text("Modifier", style: linkTextStyle),
                    )
                  ],
                ),
              )
            ],
          ),
          Center(
            child: Stack(
              children: [
                Container(
                  child: SizedBox(
                    width: 96,
                    height: 96,
                    child: ClipOval(
                        child: FutureBuilder<bool>(
                            future: fileExist,
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                var r = snapshot.data;
                                log("value photo $r");
                                if (r == false) {
                                  return Image.asset(imagetempo);
                                } else {
                                  return Image.file(imagePhoto);
                                }
                              } else {
                                return Image.asset(imagetempo);
                              }
                            })),
                  ),
                  padding: const EdgeInsets.only(top: 18.0, bottom: 9.0),
                ),
                Positioned(
                  child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: IconButton(
                          onPressed: null,
                          icon: Image.asset("assets/images/camera.png"),
                          color: Colors.white,
                        ),
                      )),
                  top: 84,
                  left: 64,
                )
              ],
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //   content: Text("Pas encore développé"),
                // ));
              },
              child: const Text(
                "Changer la photo de profile",
                style: linkTextStyle,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 48.0, bottom: 13.0),
            child: Divider(
              color: Color.fromRGBO(158, 158, 158, 1),
              height: 0.5,
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 26.0, right: 64.0),
                child: Text(
                  "Email",
                  style: normalTextStyle,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 165,
                    child: Text(
                      email,
                      style: valueTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  )
                ],
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 13.0, bottom: 18.0),
            child: Divider(
              color: Color.fromRGBO(158, 158, 158, 1),
              height: 0.5,
              thickness: 0.5, // thickness of the line
              indent: 129, // empty space to the leading edge of divider.
              endIndent: 0,
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 26.0, right: 68.0),
                child: Text(
                  "Nom",
                  style: normalTextStyle,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    nom,
                    style: valueTextStyle,
                  ),
                ],
              )
            ],
          ),
          // const Padding(
          //   padding: EdgeInsets.only(top: 13.0, bottom: 18.0),
          //   child: Divider(
          //     color: Color.fromRGBO(158, 158, 158, 1),
          //     height: 0.5,
          //     thickness: 0.5, // thickness of the line
          //     indent: 129, // empty space to the leading edge of divider.
          //     endIndent: 0,
          //   ),
          // ),
          // Row(
          //   children: [
          //     const Padding(
          //       padding: EdgeInsets.only(left: 26.0, right: 52.0),
          //       child: Text(
          //         "Pseudo",
          //         style: normalTextStyle,
          //       ),
          //     ),
          //     Column(
          //       mainAxisSize: MainAxisSize.max,
          //       children: [
          //         Text(
          //           pseudo,
          //           style: valueTextStyle,
          //         ),
          //       ],
          //     )
          //   ],
          // ),
          const Padding(
            padding: EdgeInsets.only(top: 13.0, bottom: 18.0),
            child: Divider(
              color: Color.fromRGBO(158, 158, 158, 1),
              height: 0.5,
              thickness: 0.5, // thickness of the line
              indent: 129, // empty space to the leading edge of divider.
              endIndent: 0,
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 26.0, right: 32.0),
                child: Text(
                  "Téléphone",
                  style: normalTextStyle,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    telephone,
                    style: valueTextStyle,
                  ),
                ],
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 13.0, bottom: 18.0),
            child: Divider(
              color: Color.fromRGBO(158, 158, 158, 1),
              height: 0.5,
              thickness: 0.5, // thickness of the line
              indent: 129, // empty space to the leading edge of divider.
              endIndent: 0,
            ),
          ),
          Center(
            child: Container(
                width: 300,
                height: 150.0,
                padding: const EdgeInsets.only(top: 64.0),
                child: TextButton.icon(
                    onPressed: () async {
                      String? userIdVal = await helpers.getString(idKey);
                      log("user idVal = $userIdVal");
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialogCustomRemove(
                                title: "Suppression",
                                message:
                                    "Votre compte sera définitivement supprimer. Voulez-vous continuer?",
                                type: "success",
                                userId: userIdVal);
                          });
                    },
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                    label: const Text(
                      "Supprimer votre compte",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500),
                    ))),
          ),
        ],
      ),
    );
  }

  _imgFromCamera() async {
    XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      imagePhoto = io.File(XFile(image!.path).path);
      widget.user!.updatePhotoURL(image.path);
      helpers.saveImage(image.path, image.name);
      Navigator.pop(context);
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => OnlineUserDetailsPage(
              user: widget.user, userDetails: widget.userDetails),
        ),
      );
    });
  }

  _imgFromGallery() async {
    XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      imagePhoto = io.File(XFile(image!.path).path);
      widget.user!.updatePhotoURL(image.path);
      helpers.saveImage(image.path, image.name);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => OnlineUserDetailsPage(
              user: widget.user, userDetails: widget.userDetails),
        ),
      );
    });
  }

  void _showPicker(context) async {
    await helpers.requestPermission(Permission.storage);
    await helpers.requestPermission(Permission.camera);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallerie'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
  // void getUserData() async {
  //   await Firebase.initializeApp();
  //   SharedPreferences pref = await SharedPreferences.getInstance();

  //   String errorMsg;
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     email = user.email!;
  //     nom = user.displayName!;
  //     telephone = pref.getString(telKey)!;
  //     imagePhoto = File(user.photoURL!);
  //     print(user.photoURL!);
  //   }
  // }
}
