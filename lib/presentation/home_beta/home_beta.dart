import 'package:eden/presentation/home_beta/diaspora_fm_beta.dart';
import 'package:eden/presentation/home_beta/eden_tv_beta.dart';
import 'package:eden/presentation/setting/setting.dart';
import 'package:eden/utils/constante.dart';
import 'package:flutter/material.dart';

class HomeBetaPage extends StatefulWidget {
  const HomeBetaPage({Key? key}) : super(key: key);

  @override
  _HomeBetaPageState createState() => _HomeBetaPageState();
}

class _HomeBetaPageState extends State<HomeBetaPage> {
  int _selectedIndexForTabBar = 0;

  void _onItemTappedForTabBar(int index) {
    setState(() {
      _selectedIndexForTabBar = index;
      // _selectedIndexForBottomNavigation =
    });
  }

  Widget _getRightContentView(int tabIndex) {
    if (tabIndex == 0) {
      return const DiasporaFmBetaPage();
    } else if (tabIndex == 1) {
      return const EdenTvBetaPage();
    } else {
      return const SettingPage();
    }
  }

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
    return MaterialApp(
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              toolbarHeight: 4.0,
              bottom: tabBar,
            ),
            backgroundColor: Colors.white,
            body: _getRightContentView(_selectedIndexForTabBar),
          )),
    );
  }
}
