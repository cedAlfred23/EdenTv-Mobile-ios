import 'dart:ui';

import 'package:eden/utils/constante.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:radio_player/radio_player.dart';

class DiasporaFmBetaPage extends StatefulWidget {
  const DiasporaFmBetaPage({Key? key}) : super(key: key);
  // final playerState = FlutterRadioPlayer.flutter_radio_paused;

  @override
  _DiasporaFmBetaPageState createState() => _DiasporaFmBetaPageState();
}

class _DiasporaFmBetaPageState extends State<DiasporaFmBetaPage> {
  final RadioPlayer _radioPlayer = RadioPlayer();
  bool isplaying = false;
  late List<String?> metadata;

  @override
  void initState() {
    super.initState();
    initRadioService();
  }

  Future<void> initRadioService() async {
    try {
      await _radioPlayer.setChannel(
          title: "Diaspora FM", url: urlRadio, imagePath: imageBetaFM);
      _radioPlayer.stateStream.listen((event) {
        setState(() {
          isplaying = event;
        });
      });
      _radioPlayer.metadataStream.listen((event) {
        setState(() {
          metadata = event;
        });
      });
    } on PlatformException {
      // print("Exception occured while trying to register the service");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        children: [
          Positioned(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 1),
              child: Image.asset(
                imageBetaFM,
                height: 250,
              ),
            ),
            top: 0,
          ),
          Positioned(
            child: Row(children: const [
              Padding(
                padding: EdgeInsets.only(right: 4.0),
                child: Icon(Icons.radio_button_on_outlined,
                    color: Colors.redAccent),
              ),
              Text("En direct",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      backgroundColor: Colors.black87,
                      fontSize: 14.0)),
            ]),
            top: 20,
            right: 20,
          ),
          Positioned(
            child: FutureBuilder(
              future: _radioPlayer.getArtworkImage(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // Image artwork;
                // if (snapshot.hasData) {
                //   artwork = snapshot.data;
                //   // print(_radioPlayer.metadataStream);
                // } else {
                //   artwork = Image.asset(imageBetaFM);
                // }
                // String? returnData = snapshot.data;
                // print("Object " + returnData.toString());
                return GestureDetector(
                    onTap: () async {
                      isplaying
                          ? await _radioPlayer.pause()
                          : await _radioPlayer.play();
                    },
                    child: isplaying
                        ? Image.asset(imagePauseBtn)
                        : Image.asset(imagePlayBtn));
              },
            ),
            top: 150,
            left: 0,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
