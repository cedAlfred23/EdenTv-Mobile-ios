import 'dart:developer';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

class AlertDialogPub extends StatefulWidget {
  const AlertDialogPub(
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
  State<AlertDialogPub> createState() => _AlertDialogPubState();
}

class _AlertDialogPubState extends State<AlertDialogPub> {
  final FijkPlayer player = FijkPlayer();
  bool showImg = false;

  @override
  void initState() {
    super.initState();
    // player.setDataSource(widget.url, autoPlay: true, showCover: true);
    player.addListener(() {
      // if (player.state == FijkState.error) {
      //   setState(() {
      //     showImg = true;
      //   });
      // } else {
      //   setState(() {
      //     showImg = false;
      //   });
      // }
      // if (player.isPlayable()) {
      //   setState(() {
      //     showImg = true;
      //   });
      // } else {
      //   setState(() {
      //     showImg = false;
      //   });
      // }
    });
    log("url: ${widget.url}");
    // try {
    //   player.start();
    // } catch (e) {
    //   log("url: test");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        height: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: SizedBox(
                    width: 200,
                    height: 30,
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      player.release();
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: SizedBox(
                width: 200,
                height: 30,
                child: Text(
                  widget.desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 300,
                height: 175,
                child: widget.url != ""
                    ? FijkView(
                        player: player,
                        fit: FijkFit.fill,
                      )
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30.0)),
                            image: DecorationImage(
                                image: NetworkImage(widget.couverture),
                                fit: BoxFit.cover),
                            color: Colors.grey[400]),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}
