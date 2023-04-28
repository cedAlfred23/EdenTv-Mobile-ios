import 'package:eden/utils/constante.dart';
import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';

class EdenTvBetaPage extends StatefulWidget {
  const EdenTvBetaPage({Key? key}) : super(key: key);

  @override
  _EdenTvBetaPageState createState() => _EdenTvBetaPageState();
}

class _EdenTvBetaPageState extends State<EdenTvBetaPage> {
  final FijkPlayer player = FijkPlayer();
  final double _height = 320.0;

  @override
  void initState() {
    super.initState();
    player.setDataSource(urlRTMPtv, autoPlay: false, showCover: true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: _height,
              alignment: Alignment.center,
              child: FijkView(
                player: player,
                fit: FijkFit.fill,
              ),
            )),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}
