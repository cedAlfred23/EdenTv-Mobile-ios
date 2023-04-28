import 'package:eden/presentation/components/alert_dialog_quit.dart';
import 'package:eden/presentation/components/radio_player.dart';
import 'package:eden/presentation/components/tv_controller.dart';
import 'package:eden/presentation/home/diaspora_fm_pages/diaspora_fm.dart';
import 'package:eden/presentation/home/edent_tv_pages/edentv_page.dart';
import 'package:eden/presentation/setting/setting.dart';
import 'package:eden/utils/constante.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage(
      {Key? key,
      required this.selectedIndexForBottomNavigation,
      required this.selectedIndexForTabBar})
      : super(key: key);

  int selectedIndexForBottomNavigation;
  int selectedIndexForTabBar;

  @override
  _HomePageState createState() => _HomePageState();
}

// const fakeTabItemStyle =
//     TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87);

class _HomePageState extends State<HomePage> {
  int position = 0;

  // final FijkPlayer player = FijkPlayer();

  @override
  void initState() {
    super.initState();
    // player.setDataSource(urlRTMPtv, autoPlay: false, showCover: false);
  }

  void _onItemTappedForBottomNavigationBar(int index) {
    setState(() {
      widget.selectedIndexForBottomNavigation = index;
    });
  }

  void _onItemTappedForTabBar(int index) {
    setState(() {
      widget.selectedIndexForTabBar = index;
      if (index == 2) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingPage(),
            ));
      }
    });
  }

  Widget _getRightContentView(int tabIndex, int bottomNavigationBar) {
    if (tabIndex == 0) {
      return DiasporaFmPage(bottomNavigationBarIndex: bottomNavigationBar);
    } else if (tabIndex == 1) {
      return EdentTvPage(
          bottomNavigationBarIndex:
              bottomNavigationBar /*,
        player: player,*/
          );
    } else {
      return const SettingPage();
    }
  }

  Future<bool> _onBackPressed() {
    const title = "Attention";
    showDialog(
      context: context,
      builder: (context) => const AlertDialogCustomQuit(
        title: title,
        message: 'Voulez-vous sortir de l\'application',
        type: alertDialogSuccess,
      ),
    );
    return Future.value(false);
  }

  late DefaultTabController tabController;
  @override
  Widget build(BuildContext context) {
    final tabBar = TabBar(
      onTap: _onItemTappedForTabBar,
      tabs: [
        const Tab(
          child: Text(
            "Diaspora FM",
            style: fakeTabItemStyle,
          ),
        ),
        const Tab(
          child: Text(
            "EDEN TV",
            style: fakeTabItemStyle,
          ),
        ),
        Tab(
          child: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingPage(),
                  ));
            },
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Colors.black87,
            ),
          ),
        )
      ],
    );

    return DefaultTabController(
        length: 3,
        child: WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
              appBar: AppBar(
                bottom: tabBar,
                elevation: 0.0,
                backgroundColor: Colors.white,
                toolbarHeight: 4.0,
              ),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 320,
                    minHeight: 480,
                  ),
                  child: _getRightContentView(widget.selectedIndexForTabBar,
                      widget.selectedIndexForBottomNavigation),
                ),
                scrollDirection: Axis.vertical,
              ),
              bottomSheet: widget.selectedIndexForTabBar == 0
                  ? const RadioPlayerComponent()
                  : const TvController(),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.white,
                onTap: _onItemTappedForBottomNavigationBar,
                currentIndex: widget.selectedIndexForBottomNavigation,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  const BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage(homeIcon),
                        size: 24.0,
                      ),
                      label: 'Accueil'),
                  const BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage(programeIcon),
                        size: 24.0,
                      ),
                      label: 'Programme'),
                  widget.selectedIndexForTabBar == 0
                      ? const BottomNavigationBarItem(
                          icon: Icon(Icons.podcasts), label: 'Podcast')
                      : const BottomNavigationBarItem(
                          icon: Icon(Icons.ondemand_video_outlined),
                          label: 'Emission'),
                  const BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage(alauneIcon),
                        size: 24.0,
                      ),
                      label: 'A la une'),
                  const BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage(contactIcon),
                        size: 24.0,
                      ),
                      label: 'Contact'),
                ],
              )),
        ));
  }
}
