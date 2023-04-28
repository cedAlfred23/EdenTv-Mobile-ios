// ignore: file_names
import 'dart:ui';
import 'package:flutter/material.dart';

class CardPresentation extends StatelessWidget {
  const CardPresentation(
      {required this.assetImage,
      required this.titre,
      required this.sousTitre,
      Key? key})
      : super(key: key);
  final String assetImage;
  final String titre;
  final String sousTitre;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 149,
          height: 145,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              image: DecorationImage(
                  image: NetworkImage(assetImage), fit: BoxFit.cover),
              color: Colors.grey[400]),
        ),
        Positioned(
          child: Container(
            width: 133,
            height: 52,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(230, 230, 230, 0.37),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 11.0, top: 10.0),
                        child: SizedBox(
                          width: 145,
                          child: Text(
                            titre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 11.0, top: 4.0),
                        child: SizedBox(
                          width: 145,
                          child: Text(
                            sousTitre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
          top: 93,
          left: 9,
        ),
      ],
    );
  }
}
