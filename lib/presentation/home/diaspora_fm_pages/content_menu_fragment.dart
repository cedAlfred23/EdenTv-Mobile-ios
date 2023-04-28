import 'package:eden/presentation/home/diaspora_fm_pages/contents_menu/content_menu_music.dart';
import 'package:eden/presentation/home/diaspora_fm_pages/contents_menu/content_menu_repas.dart';
import 'package:eden/presentation/home/diaspora_fm_pages/contents_menu/content_menu_sport.dart';
import 'package:eden/presentation/home/diaspora_fm_pages/contents_menu/content_menu_tout.dart';
import 'package:flutter/material.dart';

import 'contents_menu/content_menu_info.dart';

class ContentMenuFragment extends StatefulWidget {
  const ContentMenuFragment({required this.menuIndex, Key? key})
      : super(key: key);
  final int menuIndex;

  @override
  _ContentMenuFragmentState createState() => _ContentMenuFragmentState();
}

class _ContentMenuFragmentState extends State<ContentMenuFragment> {
  Widget _getContent() {
    switch (widget.menuIndex) {
      case 0:
        return const ContentMenuToutFragmant();
      case 1:
        return const ContenuMenuMusicFragment();
      case 2:
        return const ContenuMenuSportFragment();
      case 3:
        return const ContenuMenuRepasFragment();
      case 4:
        return const ContenuMenuInfoFragment();
      default:
        return const CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: _getContent(),
    );
  }
}
