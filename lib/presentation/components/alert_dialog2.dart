import 'package:eden/main.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

class AlertDialogPub2 extends StatefulWidget {
  const AlertDialogPub2(
      {required this.url,
      required this.title,
      required this.desc,
      required this.couverture,
      Key? key})
      : super(key: key);

  final String url;
  final String title;
  final String desc;
  final String couverture;

  @override
  State<AlertDialogPub2> createState() => _AlertDialogPub2State();
}

class _AlertDialogPub2State extends State<AlertDialogPub2> {
  final FijkPlayer pubPlayer = FijkPlayer();

  @override
  void initState() {
    super.initState();
    pubPlayer.setDataSource(widget.url, autoPlay: true, showCover: true);
    radioPlayer.pause();
  }

  bool playerError = false;

  @override
  Widget build(BuildContext context) {
    pubPlayer.addListener(() {
      if (player.state == FijkState.started) {
        player.pause();
      }
      radioPlayer.stateStream.listen((event) {
        if (pubPlayer.state == FijkState.started) {
          radioPlayer.pause();
        }
      });

      if (pubPlayer.state == FijkState.error) {
        setState(() {
          playerError = true;
        });
      } else {
        setState(() {
          playerError = false;
        });
      }
    });
    return Material(
        type: MaterialType.card,
        color: const Color.fromRGBO(0, 0, 0, 0.2),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0)),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 0.0, left: 8.0),
                                child: SizedBox(
                                  width: 200,
                                  height: 30,
                                  child: Text(
                                    widget.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    pubPlayer.release();
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            child: SizedBox(
                              width: 200,
                              height: 30,
                              child: Text(
                                widget.desc,
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Center(
                    child: widget.url != "" && playerError == false
                        ? Container(
                            width: MediaQuery.of(context).size.width * 70,
                            height: 210,
                            child: FijkView(
                              width: MediaQuery.of(context).size.width * 70,
                              height: 210,
                              player: pubPlayer,
                              fit: FijkFit.fill,
                              cover: NetworkImage(widget.couverture),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0)),
                                image: DecorationImage(
                                    image: NetworkImage(widget.couverture),
                                    fit: BoxFit.cover),
                                color: Colors.black),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * .4,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0)),
                                image: DecorationImage(
                                    image: NetworkImage(widget.couverture),
                                    fit: BoxFit.contain),
                                color: Colors.black),
                          ),
                  ),
                ])));
  }

  @override
  void dispose() {
    super.dispose();
    pubPlayer.stop();
    pubPlayer.release();
    pubPlayer.dispose();
  }
}
