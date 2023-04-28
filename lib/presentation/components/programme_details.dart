import 'package:eden/utils/constante.dart';
import 'package:flutter/material.dart';

class ProgrammeDetails extends StatelessWidget {
  const ProgrammeDetails(
      {required this.title,
      required this.date,
      required this.categorie,
      required this.couverture,
      Key? key})
      : super(key: key);
  final String title;
  final String date;
  final String couverture;
  final String categorie;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
            padding: const EdgeInsets.all(16.0),
            width: 270,
            height: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 20,
                    child: const Text(
                      "Informations",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 160,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: NetworkImage(couverture),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Column(
                    children: [
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 4.0, top: 6.0, right: 4.0),
                          child: SizedBox(
                            // width: MediaQuery.of(context).size.width * .65,
                            height: 35,
                            child: Text(
                              title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.justify,
                              softWrap: false,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ]),
                      // Padding(
                      //     padding: const EdgeInsets.symmetric(vertical: 4.0),
                      //     child: Row(children: [
                      //       const Text(
                      //         "Date :",
                      //         style: serviceTitleStyle,
                      //       ),
                      //       Padding(
                      //         padding:
                      //             const EdgeInsets.only(left: 4.0, top: 6.0),
                      //         child: SizedBox(
                      //           width: 145,
                      //           height: 20,
                      //           child: Text(
                      //             date,
                      //             maxLines: 2,
                      //             overflow: TextOverflow.ellipsis,
                      //             softWrap: false,
                      //             style: const TextStyle(
                      //                 color: Colors.black,
                      //                 fontSize: 11,
                      //                 fontFamily: 'Montserrat',
                      //                 fontWeight: FontWeight.normal),
                      //           ),
                      //         ),
                      //       ),
                      //     ])),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: Row(
                            children: [
                              const Text(
                                "Catégorie :",
                                style: serviceTitleStyle,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 4.0, top: 10.0),
                                child: SizedBox(
                                  width: 145,
                                  height: 25,
                                  child: Text(
                                    categorie,
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
                              )
                            ],
                          )),
                      Center(
                          child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(primaryColors)),
                        child: const Text(
                          "Fermer",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: fontFamilly,
                              color: Colors.white),
                        ),
                      ))
                    ],
                  ),
                )
              ],
            )));
  }
}
