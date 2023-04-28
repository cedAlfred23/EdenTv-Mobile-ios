import 'package:eden/utils/constante.dart';
import 'package:flutter/material.dart';

class AlertDialogPlayer extends StatefulWidget {
  const AlertDialogPlayer({required this.title, required this.url, Key? key})
      : super(key: key);
  final String title;
  final String url;

  @override
  State<AlertDialogPlayer> createState() => _AlertDialogPlayerState();
}

class _AlertDialogPlayerState extends State<AlertDialogPlayer> {
  bool playerEnCours = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.white),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontFamily: fontFamilly, fontSize: 15),
            maxLines: 3,
          ),
          const LinearProgressIndicator(
            color: primaryColors,
          ),
          Center(
            child: IconButton(
                onPressed: null,
                icon: Icon(playerEnCours
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded)),
          )
        ],
      ),
    );
  }
}
