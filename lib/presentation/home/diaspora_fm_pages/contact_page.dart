import 'dart:developer';

import 'package:eden/domaine/service.dart';
import 'package:eden/infrastructure/v1/service.dart';
import 'package:eden/presentation/home/contact_form.dart';
import 'package:eden/utils/constante.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({required this.showContactForm, Key? key})
      : super(key: key);
  final bool showContactForm;
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    // defaultC = DefaultContactView();
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: const DefaultContactView());
  }
}

class DefaultContactView extends StatefulWidget {
  const DefaultContactView({Key? key}) : super(key: key);

  @override
  State<DefaultContactView> createState() => _DefaultContactViewState();
}

class _DefaultContactViewState extends State<DefaultContactView> {
  String? serviceTitle = "";
  String? contact = "";
  @override
  Widget build(BuildContext context) {
    double _boxWidth = MediaQuery.of(context).size.width - 32;
    return Column(
      children: [
        Row(
          children: const [
            Text(
              "Nous contacter",
              style: politiqueConfidentialiteTitleStyle,
            ),
            Spacer(),
            Icon(
              Icons.mail,
              color: iconColor,
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.only(top: 16.0),
          height: (MediaQuery.of(context).size.height),
          child: FutureBuilder<List<Service>?>(
            future: fetchService(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Service>?> snapshot) {
              if (snapshot.hasData) {
                log("${snapshot.data}");
                if (snapshot.data!.isEmpty) {
                  return const Text("Aucun service disponible pour l'instant");
                } else {
                  List<Service>? services = snapshot.data;
                  return ListView.builder(
                      itemCount: services!.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, bottom: 16.0),
                            child: Container(
                              width: _boxWidth,
                              height: 147,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
                                  border: Border.all(
                                      color: serviceBorderColor, width: 0.5)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    services[index].name ?? "",
                                    style: serviceTitleStyle,
                                  ),
                                  Text(
                                    services[index].description ?? "",
                                    style: serviceDescStyle,
                                  ),
                                  const Spacer(),
                                  Center(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        ContactFormPage(
                                                          contact:
                                                              contact ?? "",
                                                          serviceTitle:
                                                              serviceTitle ??
                                                                  "",
                                                          where: "diaspora_fm",
                                                        ))));
                                            // setState(() {
                                            //   _showContactForme =
                                            //       !_showContactForme;
                                            //   serviceTitle =
                                            //       services[index].id;
                                            //   contact =
                                            //       services[index].contact;
                                            // });
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             ContactFormPage(
                                            //               contact: services[
                                            //                           index]
                                            //                       .contact ??
                                            //                   "",
                                            //               serviceTitle:
                                            //                   services[index]
                                            //                           .name ??
                                            //                       "",
                                            //             )));
                                          },
                                          child: const Text(
                                            "Nous contacter",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: fontFamilly,
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      primaryColors))))
                                ],
                              ),
                            ));
                      });
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
