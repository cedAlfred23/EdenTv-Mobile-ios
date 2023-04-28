import 'package:eden/utils/constante.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  // initState() {
  //   Future<void> init() async {
  //     await Firebase.initializeApp();
  //     // FirebaseAuth.instance.userChanges().listen((user) {
  //     //   if (user != null) {
  //     //     userOnLine = getUserUid(authentication);
  //     //   } else {
  //     //     userOnLine = getUserUid(authentication);
  //     //   }
  //     // });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: const Center(
            child: CircularProgressIndicator(
          color: primaryColors,
          strokeWidth: 3.0,
        )));
  }
}
