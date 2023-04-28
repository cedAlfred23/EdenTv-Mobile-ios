import 'package:eden/presentation/home/home.dart';
import 'package:eden/utils/constante.dart';
import 'package:flutter/material.dart';

class FavorisPage extends StatefulWidget {
  const FavorisPage(
      {Key? key,
      required this.title,
      required this.image,
      required this.content,
      required this.createdAt})
      : super(key: key);
  final String title;
  final String? image;
  final String content;
  final String createdAt;

  @override
  State<FavorisPage> createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {
  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              selectedIndexForBottomNavigation: 0,
              selectedIndexForTabBar: 0,
            ),
          ));
      return Future.value(false);
    }

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: const Text(
              "Article",
              style: titleTextStyle,
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      selectedIndexForBottomNavigation: 0,
                      selectedIndexForTabBar: 0,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.black,
              padding: const EdgeInsets.only(left: 16.0),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 320,
                minHeight: 480,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Center(
                    child: Text(
                      widget.title,
                      style: politiqueConfidentialiteTitleStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Center(
                    child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        placeholder: imagetempo,
                        image: widget.image ?? ""),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Center(
                      child: Text(
                    widget.content,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: fontFamilly,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[800]),
                  )),
                ],
              ),
            ),
            scrollDirection: Axis.vertical,
          ),
          backgroundColor: Colors.white,
        ));
  }
}
