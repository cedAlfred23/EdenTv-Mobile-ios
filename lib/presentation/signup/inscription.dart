import 'dart:developer';

import 'package:eden/presentation/components/alert_dialog.dart';
import 'package:eden/presentation/home/home.dart';
import 'package:eden/presentation/login/login.dart';
import 'package:eden/presentation/signup/inscription_2.dart';
import 'package:eden/utils/authentication.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as applsign;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class FormCustom extends StatefulWidget {
  const FormCustom({required this.haveRememberPwd, Key? key}) : super(key: key);

  final bool haveRememberPwd;

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<FormCustom> {
  final _formKey = GlobalKey<FormState>();
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.black12;
    }
    return Colors.blue;
  }

  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  Helpers helpers = Helpers();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 28.0, right: 28.0, bottom: 22.0),
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
              padding:
                  const EdgeInsets.only(left: 28.0, right: 28.0, bottom: 18.0),
              child: PasswordField(
                controller: pwdController,
                color: primaryColors,
                passwordConstraint: r'.*[@$#.*].*',
                hintText: "Mot de passe",
                inputDecoration: PasswordDecoration(),
                border: PasswordBorder(
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
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(width: 2, color: Colors.red.shade200),
                  ),
                ),
                errorMessage: "Doit contenir au moins [@\$#.*]",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      signUp1();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpNextPage(),
                        ),
                      );
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
                      style: TextStyle(fontSize: 14, fontFamily: 'Montserrat'),
                    ),
                  )),
            ),
          ],
        ));
  }

  void signUp1() async {
    await Firebase.initializeApp();

    String errorMsg;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: pwdController.text)
          .then((userCredential) => {
                if (userCredential.user != null &&
                    !userCredential.user!.emailVerified)
                  {
                    // print(userCredential.user);
                    userCredential.user?.sendEmailVerification()
                  }
              });
      // .whenComplete(
      //     () => Navigator.of(context).pushReplacementNamed('/signup_next'));
      helpers.putString(signUpModeKey, signUpEmailPwdVal);
    } on FirebaseAuthException catch (e) {
      log("erreur signup: ${e.code}");
      if (e.code == 'weak-password') {
        errorMsg = "Le mot de passe est trop faible";
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialogCustom(
                title: "Erreur",
                message: errorMsg,
                type: alertDialogError,
                backPath: const SignUpPage(),
              );
            });
        // print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        errorMsg = "Cette adresse a déjà un compte";
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialogCustom(
                  title: "Erreur",
                  message: errorMsg,
                  type: alertDialogError,
                  backPath: const SignUpPage());
            });
        // print('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        errorMsg = "Cette adresse a déjà un compte";
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialogCustom(
                  title: "Erreur",
                  message: errorMsg,
                  type: alertDialogError,
                  backPath: const SignUpPage());
            });
        // print('The account already exists for that email.');
      } else {
        errorMsg = "Vérifier votre connexion internet";
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialogCustom(
                  title: "warning",
                  message: errorMsg,
                  type: alertDialogError,
                  backPath: const SignUpPage());
            });
        log("erreur: ${e.code}");
      }
    }
  }
}

class _SignUpPageState extends State<SignUpPage> {
  Authentication auth = Authentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 320,
            ),
            child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.only(top: 26.0, bottom: 13.0),
                    child: Text("S'inscrire", style: titleTextStyle)),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 4.0, left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "En vous inscrivant, vous acceptez nos ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        right: 16.0, bottom: 32.0, left: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        //todo Ajouter politiques de confidentialités screen et contenu
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Pas encore disponible')),
                        );
                      },
                      child: const Text(
                          "Termes et politiques de confidentialité. ",
                          style: coloredText),
                    )),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: FormCustom(haveRememberPwd: true),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Divider(
                        color: Colors.black,
                        height: 7,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "ou",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        height: 7,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        auth.signInWithFacebook(false);
                        log("credential");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpNextPage(),
                          ),
                        );
                      },
                      child: Image.asset(logoFacebook),
                    ),
                    GestureDetector(
                        onTap: (() {
                          auth.signInWithApple(scopes: [
                            applsign.Scope.email,
                            applsign.Scope.fullName
                          ]).then((value) {
                            if (value == null) return;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage(
                                          selectedIndexForBottomNavigation: 0,
                                          selectedIndexForTabBar: 0,
                                        )));
                          });
                        }),
                        child: Image.asset(logoAppel)),
                    GestureDetector(
                      onTap: () {
                        try {
                          auth.signInWithGoogle(false);
                          // print(credential);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpNextPage(),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialogCustom(
                                    title: "Erreur",
                                    message: "Une erreur est survenue",
                                    type: "error",
                                    backPath: SignUpPage());
                              });
                          log("erreur Google: $e");
                        }
                      },
                      child: Image.asset(logoGooglePlus),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Déjà un compte? "),
                      Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Se connecter",
                              style: coloredText,
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
