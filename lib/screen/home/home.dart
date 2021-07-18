import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/config/routes.dart';
import 'package:lune_vpn_agent/dialog/logout_dialog.dart';
import 'package:lune_vpn_agent/main.dart';
import 'package:lune_vpn_agent/screen/home/page/file_page.dart';
import 'package:lune_vpn_agent/screen/home/page/news_page.dart';
import 'package:lune_vpn_agent/screen/home/page/profile_page.dart';
import 'package:lune_vpn_agent/screen/home/page/vpn_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPages = 0;
  final scrollController = ScrollController();
  final _page = [
    HomeNewsPage(),
    VpnPage(),
    FilePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentPages,
        children: _page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPages,
        onTap: (page) {
          setState(() {
            _currentPages = page;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.vpn_key),
            label: 'VPN',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: 'File',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
