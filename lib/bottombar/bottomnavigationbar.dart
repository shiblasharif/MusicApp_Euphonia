import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/pages/library.dart';
import 'package:music_player/pages/search.dart';
import '../gridsong.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  List<Audio> allsong;
  BottomBar({Key? key, required this.allsong}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      Gridsong(
        audiosongs: widget.allsong,
      ),
      SearchScreen(
        audiosongs: widget.allsong,
      ),
      Library(),
    ];
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
          setState(() {
            _selectedIndex = value;
          });
        },

        // type: BottomNavigationBarType.fixed,
        // currentIndex: _selectedIndex,
        // selectedItemColor: Colors.white,
        // unselectedItemColor: Colors.grey[600],
        // showSelectedLabels: true,
        // showUnselectedLabels: false,
        // unselectedFontSize: 14,
        // backgroundColor: const Color(0xFF091B46),
        // items: const <BottomNavigationBarItem>[
        //   BottomNavigationBarItem(
        //     icon: Icon(
        //       Icons.home,
        //       // color: Colors.white70,
        //     ),
        //     label: 'Home',
        //   ),
        //   BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.search,
        //         // color: Colors.white70,
        //       ),
        //       label: 'Search'),
        //   BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.library_music,
        //         // color: Colors.white70,
        //       ),
        //       label: 'Library'),
        // ],
      ),
    );
  }
}
