import 'dart:io';
import 'package:eden/presentation/components/alert_dialog.dart';
import 'package:eden/presentation/home/home.dart';
import 'package:eden/utils/authentication.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/helpers.dart';

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SignUpNextPage extends StatefulWidget {
  const SignUpNextPage({Key? key}) : super(key: key);

  @override
  _SignUpNextPageState createState() => _SignUpNextPageState();
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
  XFile imagePicked = XFile(avataImg);
  Helpers helpers = Helpers();

  @override
  Widget build(BuildContext context) {
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
                    child: imagePicked.path == avataImg
                        ? Image.asset(avataImg)
                        : Image.file(File(imagePicked.path)),
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
              child: InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  // print(number.phoneNumber);
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
                  // print('On Saved: $number');
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
              padding: const EdgeInsets.only(top: 28.0),
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
                        signUp2();
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
                      "Inscription",
                      style: TextStyle(fontSize: 14),
                    ),
                  )),
            ),
          ],
        ));
  }

  void signUp2() async {
    Authentication auth = Authentication();

    // print(UserNumber);
    bool success = await auth.signUpUserOnFireStore(
        false,
        nomController.text + " " + prenomController.text,
        nomController.text,
        prenomController.text,
        userNumber.parseNumber(),
        imagePicked,
        userNumber.dialCode ?? "",
        userNumber.isoCode ?? "",
        true);
    if (success) {
      helpers.putString(nomKey, nomController.text);
      helpers.putString(prenomKey, prenomController.text);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialogCustom(
                title: "Succès",
                message: "Inscription réussie",
                type: alertDialogSuccess,
                backPath: HomePage(
                  selectedIndexForBottomNavigation: 0,
                  selectedIndexForTabBar: 0,
                ));
          });
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => HomePage(
      //       selectedIndexForBottomNavigation: 0,
      //       selectedIndexForTabBar: 0,
      //     ),
      //   ),
      // );
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialogCustom(
                title: "Echec",
                message: "Echec de l'inscription ",
                type: alertDialogError,
                backPath: SignUpNextPage());
          });
    }
    // .then((value) => {helpers.putString(nomKey, nomController.text)})
    // .then((value) => {helpers.putString(prenomKey, prenomController.text)})
    // .then((value) => {
    //       if (value != null)
    //         {

    //         }
    //     })
    // .whenComplete(() => {

    //     });
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

class _SignUpNextPageState extends State<SignUpNextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 320,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 38.0, vertical: 38.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                          padding: EdgeInsets.only(top: 26.0, bottom: 13.0),
                          child: Text("Informations\nSupplémentaires",
                              style: titleTextStyle)),
                      Padding(
                        padding: EdgeInsets.only(bottom: 13.0),
                        child: Text(
                          "Complétez votre profil en renseignant vos\ninformtions personnelles",
                          style: styleSmallText,
                        ),
                      ),
                      Center(child: FormCustom()),
                    ],
                  ),
                ))));
  }
}
