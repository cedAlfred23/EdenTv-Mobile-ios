import 'package:eden/presentation/home/diaspora_fm_pages/content_menu_fragment.dart';
import 'package:eden/utils/constante.dart';
import 'package:flutter/material.dart';

class MenuSection extends StatefulWidget {
  const MenuSection({Key? key}) : super(key: key);

  @override
  _MenuSectionState createState() => _MenuSectionState();
}

class _MenuSectionState extends State<MenuSection> {
  final int _menuPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SingleChildScrollView(
        //   child: ConstrainedBox(
        //     constraints: const BoxConstraints(
        //       minWidth: 320,
        //     ),
        //     child: Row(
        //       children: [
        //         Padding(
        //             padding:
        //                 const EdgeInsets.only(right: 5.0, left: 9.0, top: 8.0),
        //             child: GestureDetector(
        //               onTap: () {
        //                 setState(() {
        //                   _menuPosition = 0;
        //                 });
        //               },
        //               child: MenuItem(
        //                 title: "Tout",
        //                 assetsPath: "assets/images/activity.png",
        //                 isActive: _menuPosition == 0 ? true : false,
        //               ),
        //             )),
        //         Padding(
        //             padding: const EdgeInsets.only(right: 5.0, top: 8.0),
        //             child: GestureDetector(
        //               onTap: () {
        //                 setState(() {
        //                   _menuPosition = 1;
        //                 });
        //               },
        //               child: MenuItem(
        //                 title: "Music",
        //                 assetsPath: "assets/images/music.png",
        //                 isActive: _menuPosition == 1 ? true : false,
        //               ),
        //             )),
        //         Padding(
        //             padding: const EdgeInsets.only(right: 5.0, top: 8.0),
        //             child: GestureDetector(
        //               onTap: () {
        //                 setState(() {
        //                   _menuPosition = 2;
        //                 });
        //               },
        //               child: MenuItem(
        //                 title: "Sport",
        //                 assetsPath: "assets/images/sport.png",
        //                 isActive: _menuPosition == 2 ? true : false,
        //               ),
        //             )),
        //         Padding(
        //             padding: const EdgeInsets.only(right: 5.0, top: 8.0),
        //             child: GestureDetector(
        //               onTap: () {
        //                 setState(() {
        //                   _menuPosition = 3;
        //                 });
        //               },
        //               child: MenuItem(
        //                 title: "Repas",
        //                 assetsPath: "assets/images/pizza1.png",
        //                 isActive: _menuPosition == 3 ? true : false,
        //               ),
        //             )),
        //         Padding(
        //             padding: const EdgeInsets.only(right: 4.0, top: 8.0),
        //             child: GestureDetector(
        //               onTap: () {
        //                 setState(() {
        //                   _menuPosition = 4;
        //                 });
        //               },
        //               child: MenuItem(
        //                 title: "Info",
        //                 assetsPath: "assets/images/info.png",
        //                 isActive: _menuPosition == 4 ? true : false,
        //               ),
        //             )),
        //       ],
        //     ),
        //   ),
        //   scrollDirection: Axis.horizontal,
        // ),
        ContentMenuFragment(menuIndex: _menuPosition)
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem(
      {required this.isActive,
      required this.assetsPath,
      required this.title,
      Key? key})
      : super(key: key);
  final bool isActive;
  final String assetsPath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 111,
        width: 73,
        decoration: isActive ? activeMenuItem : inActiveMenuItem,
        child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Column(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  child: Image.asset(assetsPath),
                  decoration: const BoxDecoration(
                      color: menuIconBgColor,
                      borderRadius: BorderRadius.all(Radius.circular(100.0))),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: isActive ? Colors.white : Colors.black,
                        fontSize: 14),
                  ),
                )
              ],
            )));
  }
}
