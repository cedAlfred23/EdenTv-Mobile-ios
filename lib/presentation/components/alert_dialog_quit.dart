// ignore: file_names
import 'package:eden/presentation/home/home.dart';
import 'package:flutter/material.dart';
import 'package:eden/utils/constante.dart';
import 'package:flutter/services.dart';

const errorBackgroundColor = Colors.redAccent;
const successBackgroundColor = Colors.greenAccent;
const warningBackgroundColor = Colors.orangeAccent;
const infoBackgroundColor = Colors.lightBlueAccent;

class AlertDialogCustomQuit extends StatelessWidget {
  const AlertDialogCustomQuit(
      {required this.title,
      required this.message,
      required this.type,
      Key? key})
      : super(key: key);
  final String title;
  final String message;
  final String type;

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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey)),
                            child: const Text(
                              'Non',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (type == "success") {
                                SystemNavigator.pop();
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(
                                        selectedIndexForBottomNavigation: 0,
                                        selectedIndexForTabBar: 0,
                                      ),
                                    ));
                              }
                              // Navigator.of(context).pop(false);
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(primaryColors)),
                            child: const Text(
                              'Oui',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ])
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
