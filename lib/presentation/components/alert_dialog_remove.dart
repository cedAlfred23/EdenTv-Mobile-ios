// ignore: file_names
import 'package:eden/presentation/components/alert_dialog.dart';
import 'package:eden/presentation/setting/setting.dart';
import 'package:eden/utils/authentication.dart';
import 'package:flutter/material.dart';
import 'package:eden/utils/constante.dart';

const errorBackgroundColor = Colors.redAccent;
const successBackgroundColor = Colors.greenAccent;
const warningBackgroundColor = Colors.orangeAccent;
const infoBackgroundColor = Colors.lightBlueAccent;

class AlertDialogCustomRemove extends StatelessWidget {
  const AlertDialogCustomRemove(
      {required this.title,
      required this.message,
      required this.type,
      required this.userId,
      Key? key})
      : super(key: key);
  final String title;
  final String message;
  final String type;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    IconData alertIcon = Icons.delete_forever_rounded;

    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 8),
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
                      height: 16,
                    ),
                    Text(
                      message,
                      maxLines: 3,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          fontSize: 14,
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
                            onPressed: () async {
                              Authentication authentication = Authentication();
                              bool res =
                                  await authentication.deleteUser(userId);
                              if (res == true) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AlertDialogCustom(
                                          title: "Info",
                                          message:
                                              "Suppression du compte réussie",
                                          type: "success",
                                          backPath: SettingPage());
                                    });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AlertDialogCustom(
                                          title: "Info",
                                          message:
                                              "Suppression du compte échouée",
                                          type: "success",
                                          backPath: SettingPage());
                                    });
                              }
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
