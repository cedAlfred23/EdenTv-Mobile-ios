import 'package:eden/presentation/login/login.dart';
import 'package:eden/presentation/signup/inscription.dart';
import 'package:eden/utils/constante.dart';
import 'package:flutter/material.dart';

class DefaultUserDetailsPage extends StatelessWidget {
  const DefaultUserDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ),
                  );
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColors)),
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.0, vertical: 4.0),
                  child: Text(
                    "Inscription",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColors)),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 4.0),
                child: Text(
                  "Connexion",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
