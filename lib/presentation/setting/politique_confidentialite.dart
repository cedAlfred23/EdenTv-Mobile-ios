import 'package:eden/presentation/setting/setting.dart';
import 'package:eden/utils/constante.dart';
import 'package:flutter/material.dart';

class PolitiqueConfidentialitePage extends StatelessWidget {
  const PolitiqueConfidentialitePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String cgu =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Porta id quisque risus, quam donec varius sem pharetra ut. Tellus integer nulla sit pharetra. Posuere vel arcu dolor faucibus. Faucibus eu, sed magna mauris eu. A, vel fermentum, nec a odio volutpat, ut lorem neque. Etiam id enim pharetra pellentesque ac sit tortor arcu scelerisque. Nunc odio lobortis porta nisl vitae neque enim, pulvinar tortor. Ipsum diam sit a duis nunc vulputate sapien auctor nunc. Lectus mattis quam mauris vitae at velit ullamcorper. Ipsum, dictum id cum et vulputate. Erat mi quisque amet, volutpat integer id nunc morbi diam. At diam scelerisque mattis scelerisque laoreet pellentesque. Tincidunt facilisis malesuada bibendum tempor adipiscing. Malesuada blandit mattis feugiat viverra id.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Porta id quisque risus, quam donec varius sem pharetra ut. Tellus integer nulla sit pharetra. Posuere vel arcu dolor faucibus. Faucibus eu, sed magna mauris eu. A, vel fermentum, nec a odio volutpat, ut lorem . Lectus mattis quam mauris vitae at velit ullamcorper. Ipsum, dictum id cum et vulputate. Erat mi quisque amet, volutpat integer id nunc morbi diam. At diam scelerisque mattis scelerisque laoreet pellentesque. Tincidunt facilisis malesuada bibendum tempor adipiscing. Malesuada blandit mattis feugiat viverra id.";

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: const Text(
            "Politique de confidentialité",
            style: politiqueConfidentialiteTitleStyle,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingPage(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black54,
            padding: const EdgeInsets.only(left: 16.0),
          ),
        ),
        body: SingleChildScrollView(
            child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 320,
          ),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 23.0),
            child: Text(
              cgu,
              style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12),
            ),
          ),
        )));
  }
}
