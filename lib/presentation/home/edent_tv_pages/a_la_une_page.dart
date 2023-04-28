import 'dart:developer';

import 'package:eden/domaine/news.dart';
import 'package:eden/infrastructure/v1/alaune.dart';

import 'package:eden/utils/constante.dart';
import 'package:eden/utils/custom_launch.dart';
import 'package:flutter/material.dart';

class ALaUnePage extends StatefulWidget {
  const ALaUnePage({Key? key}) : super(key: key);

  @override
  State<ALaUnePage> createState() => _ALaUnePageState();
}

class _ALaUnePageState extends State<ALaUnePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0, top: 16.0),
              child: Text(
                "A la une",
                style: politiqueConfidentialiteTitleStyle,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .6,
              child: FutureBuilder<List<News>>(
                future: newsList(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<News>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    log("snapshot: ${snapshot.data}");
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      List<News>? news = snapshot.data;

                      return ListView.builder(
                        itemCount: news!.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          DateTime d = DateTime.parse(news[index].createdAt);
                          String creationDate =
                              "${d.year}-${d.month}-${d.day} ${d.hour}:${d.minute}";
                          return GestureDetector(
                            onTap: () async {
                              if (!await customLaunchUrl(news[index].content)) {
                                throw 'Could not launch ';
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(
                                        width: 77,
                                        height: 74,
                                        child: FadeInImage.assetNetwork(
                                            fit: BoxFit.cover,
                                            placeholder: imagetempo,
                                            image: news[index].image ?? ""),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 195,
                                                child: Text(
                                                  news[index].title,
                                                  style: alaunetitleDesign,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    bottom: 4.0,
                                                  ),
                                                  child: SizedBox(
                                                    width: 195,
                                                    child: Text(
                                                      creationDate,
                                                      style: descStyle,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: false,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 1,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                          child: Text("Aucun article pour le moment"));
                    }
                  } else {
                    return const Center(
                        child: Text("Aucun article pour le moment"));
                  }
                },
              ),
            )
          ],
        ));
  }
}
