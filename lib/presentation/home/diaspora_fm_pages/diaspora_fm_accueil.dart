import 'package:flutter/material.dart';

import 'menu.dart';

class AccueilDiasporaFmPage extends StatefulWidget {
  const AccueilDiasporaFmPage({Key? key}) : super(key: key);

  @override
  _AccueilDiasporaFmPageState createState() => _AccueilDiasporaFmPageState();
}

class _AccueilDiasporaFmPageState extends State<AccueilDiasporaFmPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
            child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 320,
          ),
          child: Column(
            children: const [
              MenuSection(),
            ],
          ),
        )),
      ],
    );
  }
}
