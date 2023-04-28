import 'package:eden/main.dart';
import 'package:eden/presentation/home/edent_tv_pages/a_la_une_page.dart';
import 'package:eden/presentation/home/edent_tv_pages/contact_page.dart';
import 'package:eden/presentation/home/edent_tv_pages/edentv_accueil.dart';
import 'package:eden/presentation/home/edent_tv_pages/emission_page.dart';
import 'package:eden/presentation/home/edent_tv_pages/programme_page.dart';
import 'package:eden/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EdentTvPage extends StatefulWidget {
  const EdentTvPage(
      {required this.bottomNavigationBarIndex,
      /*, required this.player,*/ Key? key})
      : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final bottomNavigationBarIndex;
  // final FijkPlayer player;
  @override
  _EdentTvPageState createState() => _EdentTvPageState();
}

class _EdentTvPageState extends State<EdentTvPage> {
  @override
  void initState() {
    super.initState();
    super.initState();
    radioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    var user = auth.currentUser;

    Widget _getDiasporaView(int bottomVavigationBarIndex) {
      switch (bottomVavigationBarIndex) {
        case 0:
          return const EdenTvAccueilPage();
        case 1:
          return const ProgrammePage();
        case 2:
          return EmissionPage(
            userLoggin: user != null ? true : false,
            haveFav: haveFav(user),
          );
        case 3:
          return const ALaUnePage();
        case 4:
          return const ContactPage();
        default:
          return const CircularProgressIndicator();
      }
    }

    return _getDiasporaView(widget.bottomNavigationBarIndex);
  }
}
