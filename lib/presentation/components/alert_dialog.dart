// ignore: file_names
import 'package:flutter/material.dart';
import 'package:eden/utils/constante.dart';

const errorBackgroundColor = Colors.redAccent;
const successBackgroundColor = Colors.greenAccent;
const warningBackgroundColor = Colors.orangeAccent;
const infoBackgroundColor = Colors.lightBlueAccent;

class AlertDialogCustom extends StatelessWidget {
  const AlertDialogCustom(
      {required this.title,
      required this.message,
      required this.type,
      required this.backPath,
      Key? key})
      : super(key: key);
  final String title;
  final String message;
  final String type;
  final dynamic backPath;

  @override
  Widget build(BuildContext context) {
    IconData alertIcon = Icons.error_outline;

    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 185,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 40, 8, 8),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: fontFamilly,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      message,
                      maxLines: 3,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          fontSize: 15,
                          fontFamily: fontFamilly,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (type == alertDialogError ||
                            type == alertDialogSuccess) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => backPath));
                        } else {
                          Navigator.of(context).pop();
                        } //todo en cas d'erreur rediriger vers l'arriere avec une variable prev\link
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColors)),
                      child: const Text(
                        'Ok',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: -30,
                child: CircleAvatar(
                  backgroundColor: primaryColors,
                  radius: 30,
                  child: Icon(
                    alertIcon,
                    color: Colors.white,
                    size: 24,
                  ),
                )),
          ],
        ));
  }
}
