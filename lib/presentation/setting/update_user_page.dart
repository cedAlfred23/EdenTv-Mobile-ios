// import 'dart:developer';
import 'dart:developer';
import 'dart:io';

import 'package:eden/presentation/components/alert_dialog.dart';
import 'package:eden/presentation/home/home.dart';
import 'package:eden/presentation/setting/setting.dart';
import 'package:eden/utils/authentication.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateUserPage extends StatefulWidget {
  const UpdateUserPage({Key? key}) : super(key: key);

  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const Text(
            "Modifier",
            style: politiqueConfidentialiteTitleStyle,
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
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 320,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                          padding: EdgeInsets.only(top: 18.0, bottom: 16.0),
                          child: Text("Modifier votre profile",
                              style: titleTextStyle)),
                      Center(child: FormCustom()),
                    ],
                  ),
                ))),
        backgroundColor: Colors.white);
  }
}

class FormCustom extends StatefulWidget {
  const FormCustom({Key? key}) : super(key: key);

  @override
  _FormCustomState createState() => _FormCustomState();
}

class _FormCustomState extends State<FormCustom> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  String initialCountry = 'BJ';
  PhoneNumber userNumber = PhoneNumber(isoCode: 'BJ');
  String? numero = "";
  final TextEditingController controller =
      TextEditingController(); //todo recuperer le code pays dans pour les numeros
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  // final pseudoController = TextEditingController();
  final emailController = TextEditingController();
  late XFile imagePicked;
  Helpers helpers = Helpers();

  void setupForm() async {
    log("value numero = ${await helpers.getString(telKey)}");
    // userNumber =
    //     PhoneNumber(phoneNumber: );

    controller.text = await helpers.getString(telKey) ?? "";
    prenomController.text = await helpers.getString(prenomKey) ?? "";
    nomController.text = await helpers.getString(nomKey) ?? "";
  }

  @override
  void initState() {
    super.initState();
    setupForm();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      helpers.getString(nomKey).then((value) => {nomController.text = value!});
      helpers
          .getString(prenomKey)
          .then((value) => {prenomController.text = value!});
      // helpers
      //     .getString(pseudoKey)
      //     .then((value) => {pseudoController.text = value!});

      helpers
          .getString(telKey)
          .then((value) => {userNumber = PhoneNumber(phoneNumber: value)});
      helpers.getString(photoKey).then((value) =>
          {imagePicked = value != null ? XFile(value) : XFile(avataImg)});
      helpers
          .getString(emailKey)
          .then((value) => {emailController.text = value!});
    });
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 96,
                  height: 96,
                  child: ClipOval(
                    child: FutureBuilder<String?>(
                        future: helpers.getString(photoKey),
                        builder: (BuildContext context,
                            AsyncSnapshot<String?> snapshot) {
                          log("$snapshot");
                          if (snapshot.hasData) {
                            return Image.file(File(snapshot.data.toString()));
                          }
                          return const CircularProgressIndicator();
                        }),
                  ),
                ),
                Positioned(
                  child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                          color: primaryColors,
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: IconButton(
                          onPressed: null,
                          icon: Image.asset(cameraIcon),
                          color: primaryColors,
                        ),
                      )),
                  top: 64,
                  left: 64,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Remplissez le champ svp";
                  } else {
                    return null;
                  }
                },
                controller: nomController,
                decoration: InputDecoration(
                  label: const Text("Nom"),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12),
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
                    borderSide:
                        BorderSide(width: 2, color: Colors.red.shade200),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Remplissez le champ svp";
                  } else {
                    return null;
                  }
                },
                controller: prenomController,
                decoration: InputDecoration(
                  label: const Text("Prénom(s)"),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12),
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
                    borderSide:
                        BorderSide(width: 2, color: Colors.red.shade200),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 16.0),
            //   child: TextFormField(
            //     validator: (value) {
            //       if (value == null || value.isEmpty) {
            //         return "Remplissez le champ svp";
            //       }
            //     },
            //     controller: pseudoController,
            //     decoration: InputDecoration(
            //       label: const Text("pseudo"),
            //       border: OutlineInputBorder(
            //         borderSide: const BorderSide(color: Colors.black12),
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderSide: BorderSide(
            //           color: Colors.blue.shade100,
            //         ),
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       focusedErrorBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(4),
            //         borderSide:
            //             BorderSide(width: 2, color: Colors.red.shade200),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Remplissez le champ svp";
                  } else if (!value.contains("@")) {
                    return "Email invalide";
                  } else {
                    return null;
                  }
                },
                controller: emailController,
                decoration: InputDecoration(
                  label: const Text(
                    "Adresse Email",
                    style: TextStyle(fontFamily: 'Montserrat'),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12),
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
                    borderSide:
                        BorderSide(width: 2, color: Colors.red.shade200),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  numero = number.phoneNumber;
                  userNumber = number;
                },
                onInputValidated: (bool value) {
                  // print(value);
                },
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: const TextStyle(color: Colors.black26),
                initialValue: userNumber,
                textFieldController: controller,
                formatInput: false,
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputBorder: const OutlineInputBorder(),
                onSaved: (PhoneNumber number) {
                  // numero = number.phoneNumber.;
                },
                inputDecoration: InputDecoration(
                  label: const Text("Numéro"),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12),
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
                    borderSide:
                        BorderSide(width: 2, color: Colors.red.shade200),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (imagePicked.path == avataImg) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialogCustom(
                                title: "Warning",
                                message: "Veuillez choisir une photo",
                                type: alertDialogWarning,
                                backPath: "",
                              );
                            });
                      } else {
                        updateUser();
                      }
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(primaryColors)),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 54.0, vertical: 4.0),
                    child: Text(
                      "Mettre à jour",
                      style: TextStyle(fontSize: 14),
                    ),
                  )),
            ),
          ],
        ));
  }

  void updateUser() async {
    Authentication auth = Authentication();

    // print(UserNumber);
    bool r = await auth.signUpUserOnFireStore(
        true,
        nomController.text + " " + prenomController.text,
        nomController.text,
        prenomController.text,
        // pseudoController.text,
        userNumber.parseNumber(),
        imagePicked,
        userNumber.dialCode ?? "",
        userNumber.isoCode ?? "",
        false);
    if (r) {
      helpers.putString(nomKey, nomController.text);
      helpers.putString(prenomKey, prenomController.text);
      helpers.putString(telKey, userNumber.parseNumber());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            selectedIndexForBottomNavigation: 0,
            selectedIndexForTabBar: 0,
          ),
        ),
      );
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialogCustom(
                title: "Echec",
                message: "Echec de la mise à jour ",
                type: alertDialogError,
                backPath: SettingPage());
          });
    }
  }

  _imgFromCamera() async {
    XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      imagePicked = XFile(image!.path);
    });
  }

  _imgFromGallery() async {
    XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      imagePicked = XFile(image!.path);
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
}
