// ignore: file_names
import 'package:flutter/material.dart';
import 'package:eden/utils/constante.dart';

const errorBackgroundColor = Colors.redAccent;
const successBackgroundColor = Colors.greenAccent;
const warningBackgroundColor = Colors.orangeAccent;
const infoBackgroundColor = Colors.lightBlueAccent;

class AlertDialogTest extends StatelessWidget {
  const AlertDialogTest(
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
      child: SizedBox(
          height: 225,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: primaryColors,
                  radius: 30,
                  child: Icon(
                    alertIcon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(
                      message,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (type == alertDialogError) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => backPath));
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
            ],
          )),
    );
  }
}
