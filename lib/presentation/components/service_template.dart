import 'package:eden/presentation/home/contact_form.dart';
import 'package:eden/utils/constante.dart';
import 'package:flutter/material.dart';

class ServiceTemplate extends StatelessWidget {
  const ServiceTemplate(
      {required this.title,
      required this.description,
      required this.contact,
      Key? key})
      : super(key: key);
  final String? title;
  final String? description;
  final String? contact;

  @override
  Widget build(BuildContext context) {
    double _boxWidth = MediaQuery.of(context).size.width - 32;
    return Container(
      width: _boxWidth,
      height: 147,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: serviceBorderColor, width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "Pour nous contacter notre service client d'EDEN TV",
            style: serviceTitleStyle,
          ),
          Text(
            description ??
                "Appelez le +229 55 14 55 58 au Bénin comme à l’internationale",
            style: serviceDescStyle,
          ),
          const Spacer(),
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactFormPage(
                                  contact: contact ?? "",
                                  serviceTitle: title ?? "",
                                  where: "",
                                )));
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
                          MaterialStateProperty.all(primaryColors))))
        ],
      ),
    );
  }
}
