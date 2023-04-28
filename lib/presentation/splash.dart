import 'dart:developer';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:eden/presentation/home/home.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../utils/authentication.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class LinearProgressIndicatorClass extends StatefulWidget {
  const LinearProgressIndicatorClass({Key? key}) : super(key: key);

  @override
  _LinearProgressIndicatorClassState createState() =>
      _LinearProgressIndicatorClassState();
}

class _LinearProgressIndicatorClassState
    extends State<LinearProgressIndicatorClass> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 64.0),
        child: SizedBox(
          width: 210,
          child: Column(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white30,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 3,
                ),
              ),
              Text(
                "Chargement en cours",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontFamily: 'Montserrat'),
              ),
            ],
          ),
        ));
  }
}

class _SplashState extends State<Splash> {
  @override
  initState() {
    super.initState();
    _navigateToHome();
  }

  final ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;
  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 3500), () {});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  selectedIndexForBottomNavigation: 0,
                  selectedIndexForTabBar: 0,
                )));
  }

  Future<void> initPlugin() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      _navigateToHome();
    } else if (status == TrackingStatus.authorized) {}
    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    log("UUID: $uuid");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/edentv_blanc1.png'),
                  const SizedBox(
                    width: 186,
                    child: Divider(
                      color: Colors.white,
                      height: 6,
                    ),
                  ),
                  Image.asset('assets/images/diaspora_blanc_1.png')
                ],
              ),
            ),
          ),
          const Align(
              alignment: Alignment.bottomCenter,
              child: LinearProgressIndicatorClass())
        ],
      ),
      backgroundColor: const Color.fromRGBO(42, 82, 190, 1),
    );
  }
}
