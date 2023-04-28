import 'package:eden/main.dart';
import 'package:eden/presentation/home/diaspora_fm_pages/contact_page.dart';
import 'package:eden/presentation/home/diaspora_fm_pages/diaspora_fm_accueil.dart';
import 'package:eden/presentation/home/diaspora_fm_pages/emission_page.dart';
import 'package:eden/presentation/home/diaspora_fm_pages/programme_page.dart';
import 'package:eden/presentation/home/diaspora_fm_pages/a_la_une_page.dart';
import 'package:eden/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class DiasporaFmPage extends StatefulWidget {
  const DiasporaFmPage({required this.bottomNavigationBarIndex, Key? key})
      : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final bottomNavigationBarIndex;
  @override
  _DiasporaFmPageState createState() => _DiasporaFmPageState();
}

class _DiasporaFmPageState extends State<DiasporaFmPage> {
  @override
  void initState() {
    super.initState();
    radioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    var user = auth.currentUser;
    log("$user");
    Widget _getDiasporaView(int bottomVavigationBarIndex) {
      switch (bottomVavigationBarIndex) {
        case 0:
          return const AccueilDiasporaFmPage();
        case 1:
          return const ProgrammePage();
        case 2:
          return EmissionPage(
            userLoggin: user != null ? true : false,
            haveFav: haveFavRadio(user),
          );
        case 3:
          return const ALaUnePage();
        case 4:
          return const ContactPage(
            showContactForm: false,
          );

        default:
          return const CircularProgressIndicator();
      }
    }

    return _getDiasporaView(widget.bottomNavigationBarIndex);
  }
}
