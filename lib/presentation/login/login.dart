import 'dart:developer';

import 'package:eden/presentation/components/alert_dialog.dart';
import 'package:eden/presentation/home/home.dart';
import 'package:eden/presentation/home_beta/home_beta.dart';
import 'package:eden/presentation/login/reset_password.dart';
import 'package:eden/presentation/signup/inscription.dart';
import 'package:eden/utils/authentication.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';

import 'package:the_apple_sign_in/the_apple_sign_in.dart' as applsign;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class FormCustom extends StatefulWidget {
  const FormCustom({required this.haveRememberPwd, Key? key}) : super(key: key);

  final bool haveRememberPwd;

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<FormCustom> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  final ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  Helpers helpers = Helpers();

  bool _rememberPwd = false;
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

  @override
  Widget build(BuildContext context) {
    helpers.getBoolean(isPwdSaved).then((isPwdSaved) {
      if (isPwdSaved != null && isPwdSaved) {
        helpers
            .getString(pwdKey)
            .then((value) => {pwdController.text = value!});
        setState(() {
          _rememberPwd = isPwdSaved;
        });
      }
    }).then((isPwdSaved) => {
          if (isPwdSaved != null && isPwdSaved == true)
            {
              helpers
                  .getString(emailKey)
                  .then((value) => {emailController.text = value!})
            }
        });
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 28.0, right: 28.0, bottom: 22.0),
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Remplissez le champ svp";
                  } else if (!value.contains("@")) {
                    //validation de l'input mail
                    return "Email invalide";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  label: const Text("Adresse Email"),
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
                passwordConstraint: r'.',
                color: primaryColors,
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
                errorMessage: "Ce champ est obligatoire",
              ),
            ),
            if (widget.haveRememberPwd)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Row(
                  children: [
                    Checkbox(
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: _rememberPwd,
                        onChanged: (bool? value) {
                          setState(() {
                            _rememberPwd = value!;
                            helpers.putBoolean(isPwdSaved, _rememberPwd);

                            // print(r.toString());
                          });
                        }),
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Text(
                        "Se souvenir du mot de passe",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      //todo sauvegarder le mot de passe du client s'il coche la case
                    ),
                  ],
                ),
              ),
            if (widget.haveRememberPwd)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResetPasswordPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Mot de passe oublié?",
                        style: coloredText,
                      ),
                    )
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      loginUser(_loginState);
                      //todo mettre une animatioon sur le btn lorsqu'on clique dessus loading animation
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Processing Data')),
                      // );
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(primaryColors)),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 54.0, vertical: 4.0),
                    child: Text(
                      "Connexion",
                      style: TextStyle(fontSize: 14),
                    ),
                  )),
            ),
          ],
        ));
  }

  void loginUser(_loginState) async {
    await Firebase.initializeApp();
    String errorMsg;
    Authentication authentication = Authentication();
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      _rememberPwd ? helpers.putString(pwdKey, pwdController.text) : null;
      _rememberPwd ? helpers.putString(emailKey, emailController.text) : null;
      var r = await auth
          .signInWithEmailAndPassword(
              email: emailController.text, password: pwdController.text)
          .then((value) => {
                authentication.signInUserWithEmailAndPasswordP(
                    emailController.text, pwdController.text, value)
              })
          .whenComplete(() => {
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
                )
              });
      log("erreur: $r");
    } on FirebaseAuthException catch (e) {
      log("erreur: ${e.code}");
      if (e.code == 'user-not-found') {
        errorMsg = "Utilisateur introuvable";
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialogCustom(
                  title: "Erreur",
                  message: errorMsg,
                  type: alertDialogError,
                  backPath: const LoginPage());
            });
        // print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        errorMsg = "Mot de passe erroné";
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialogCustom(
                  title: "Erreur",
                  message: errorMsg,
                  type: alertDialogError,
                  backPath: const LoginPage());
            });
        // print('Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        errorMsg = "Mot de passe erroné";
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialogCustom(
                  title: "Erreur",
                  message: errorMsg,
                  type: alertDialogError,
                  backPath: const LoginPage());
            });
        // print('Wrong password provided for that user.');
      } else {
        errorMsg = "Mot de passe erroné";
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialogCustom(
                  title: "Erreur",
                  message: errorMsg,
                  type: alertDialogError,
                  backPath: const LoginPage());
            });
      }
    }
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  Authentication auth = Authentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          //todo utilise une scroll view pour la connexion page
          child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 320,
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 26.0, bottom: 13.0),
                child: Text("Connexion", style: titleTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 51.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Bienvenue, ", style: coloredText),
                    Text(
                      "nous sommes ravi de vous revoir.",
                      style: styleSmallText,
                    ),
                  ],
                ),
              ),
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
                  //todo utiliser ici des gestureDetector ou iconBtn
                  //todo implementer connexion avec google et facebook
                  GestureDetector(
                    onTap: () {
                      auth.signInWithFacebook(true).whenComplete(() {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                      selectedIndexForBottomNavigation: 0,
                                      selectedIndexForTabBar: 0,
                                    )));
                      });
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
                      auth.signInWithGoogle(true).whenComplete(() {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                      selectedIndexForBottomNavigation: 0,
                                      selectedIndexForTabBar: 0,
                                    )));
                      });
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
                    const Text("Pas de compte?"),
                    Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "S'inscrire",
                            style: coloredText,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
