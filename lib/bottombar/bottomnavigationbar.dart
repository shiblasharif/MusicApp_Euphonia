import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/controller.dart';
import 'package:music_player/pages/library.dart';
import 'package:music_player/pages/search.dart';
import '../gridsong.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// ignore: must_be_immutable
class BottomBar extends StatelessWidget {
  List<Audio> allsong;
  BottomBar({Key? key, required this.allsong}) : super(key: key);

  int _selectedIndex = 0;
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      Gridsong(
        audiosongs: allsong,
      ),
      SearchScreen(
        audiosongs: allsong,
      ),
      Library(),
    ];
    return GetBuilder<Controller>(builder: (_controller) {
      return Scaffold(
        backgroundColor: const Color(0xFF091B46),
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: CurvedNavigationBar(
          key: bottomNavigationKey,
          backgroundColor: const Color(0xFF091B46),
          height: 50,
          buttonBackgroundColor: Colors.grey,
          color: Colors.grey,
          items: <Widget>[
            Icon(
              Icons.home,
              size: 30,
            ),
            Icon(Icons.search, size: 30),
            Icon(Icons.library_music, size: 30),
          ],
          onTap: (value) {
            _selectedIndex = value;
            _controller.update();
          },
        ),
      );
    });
  }
}
