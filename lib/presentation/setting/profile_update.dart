// import 'package:eden/domaine/user.dart';
import 'package:eden/infrastructure/v1/account.dart';
import 'package:eden/presentation/components/alert_dialog.dart';
import 'package:eden/presentation/components/loading.dart';
import 'package:eden/presentation/setting/default_user_details_page.dart';
import 'package:eden/presentation/setting/setting.dart';
import 'package:eden/utils/authentication.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'online_user_details_page.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({Key? key}) : super(key: key);

  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  late Future<User?>? userOnLine;
  Authentication authentication = Authentication();
  Helpers helpers = Helpers();
  @override
  initState() {
    super.initState();
    Future<void> init() async {
      await Firebase.initializeApp();
      FirebaseAuth.instance.userChanges().listen((user) {
        if (user != null) {
          userOnLine = getUserUid(authentication);
        } else {
          userOnLine = getUserUid(authentication);
        }
      });
    }

    init();
  }

  @override
  Widget build(BuildContext context) {
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
                builder: (context) => const SettingPage(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          padding: const EdgeInsets.only(left: 16.0),
        ),
      ),
      body: FutureBuilder<User?>(
        future: getUserUid(authentication),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            User? user = snapshot.data;
            if (user != null) {
              try {
                getConnectedUserStore().then((value) => {
                      if (value != null)
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OnlineUserDetailsPage(
                                    userDetails: value, user: user)))
                    });
                return const Loading();
              } catch (e) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialogCustom(
                        title: "warning",
                        message: "Une erreur est survenue!",
                        type: alertDialogWarning,
                        backPath: SettingPage(),
                      );
                    });
              }
            }
            return const Loading();
          } else {
            return const DefaultUserDetailsPage();
          }
        },
      ),
    );
  }

  Future<User?> getUserUid(Authentication auth) async {
    Firebase.initializeApp;

    userOnLine = auth.getIsUserOnline();
    return userOnLine;
  }
}
