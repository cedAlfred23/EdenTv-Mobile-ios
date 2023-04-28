import 'package:eden/utils/authentication.dart';
import 'package:eden/utils/constante.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
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
                child: Text("Reset password", style: titleTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 51.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Bienvenue, ", style: coloredText),
                    Text(
                      "Saisissez votre adresse mail",
                      style: styleSmallText,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: FormCustom(),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class FormCustom extends StatefulWidget {
  const FormCustom({Key? key}) : super(key: key);

  @override
  _FormCustomState createState() => _FormCustomState();
}

class _FormCustomState extends State<FormCustom> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Authentication auth = Authentication();

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
              padding: const EdgeInsets.only(top: 28.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      auth.sendResetPassword(emailController.text);
                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(primaryColors)),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 54.0, vertical: 4.0),
                    child: Text(
                      "Envoyer le mail",
                      style: TextStyle(fontSize: 14),
                    ),
                  )),
            ),
          ],
        ));
  }
}
