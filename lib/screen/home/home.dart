import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lune_vpn_agent/config/routes.dart';
import 'package:lune_vpn_agent/provider/current_user.dart';
import 'package:lune_vpn_agent/screen/home/page/file_page.dart';
import 'package:lune_vpn_agent/screen/home/page/news_page.dart';
import 'package:lune_vpn_agent/screen/home/page/profile_page.dart';
import 'package:lune_vpn_agent/screen/home/page/vpn_page.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPages = 0;
  String? _totalUser = '--';
  String? _pending = '--';
  String? _active = '--';
  String? _expired = '--';
  String? _canceled = '--';
  bool _visibleFAB = true;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String? uid = Provider.of<CurrentUser>(context).uid;
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Agent')
              .doc(uid)
              .collection('Order')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              _totalUser = '--';
              _pending = '--';
              _active = '--';
              _expired = '--';
              _canceled = '--';
            } else {
              _totalUser = snapshot.data!.size.toString();
              _pending = snapshot.data!.docs
                  .where((doc) => doc['Status'] == 'Pending')
                  .length
                  .toString();
              _active = snapshot.data!.docs
                  .where((doc) => doc['Status'] == 'Active')
                  .length
                  .toString();
              _expired = snapshot.data!.docs
                  .where((doc) => doc['Status'] == 'Expired')
                  .length
                  .toString();
              _canceled = snapshot.data!.docs
                  .where((doc) => doc['Status'] == 'Canceled')
                  .length
                  .toString();
            }

            return IndexedStack(
              index: _currentPages,
              children: [
                HomeNewsPage(
                  totalUser: _totalUser,
                  pending: _pending,
                  active: _active,
                  expired: _expired,
                  canceled: _canceled,
                ),
                VpnPage(),
                FilePage(
                  uid: uid,
                ),
                ProfilePage(),
              ],
            );
          }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPages,
        onTap: (page) {
          setState(() {
            _currentPages = page;
          });
          if (page == 2) {
            _visibleFAB = false;
          } else {
            _visibleFAB = true;
          }
        },
        items: [
          BottomNavigationBarItem(
            tooltip: 'Your Dashboard',
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            tooltip: 'Vpn User',
            icon: Icon(Icons.vpn_key),
            label: 'VPN',
          ),
          BottomNavigationBarItem(
            tooltip: 'Vpn Files',
            icon: Icon(Icons.download),
            label: 'File',
          ),
          BottomNavigationBarItem(
            tooltip: 'Managed your profile',
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        visible: _visibleFAB,
        spaceBetweenChildren: 10,
        tooltip: 'Menu',
        heroTag: 'fab',
        buttonSize: 53,
        backgroundColor: Theme.of(context).primaryColor,
        activeBackgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.add,
        activeIcon: Icons.close,
        children: [
          SpeedDialChild(
            label: 'Request VPN',
            child: Icon(Icons.vpn_key),
            onTap: () {
              messengerKey.currentState!.removeCurrentSnackBar();
              Navigator.pushNamed(context, MyRoutes.add);
            },
          ),
          SpeedDialChild(
            label: 'Topup Account',
            child: Icon(Icons.account_balance_wallet),
            onTap: () {},
          ),
          SpeedDialChild(
            backgroundColor:
                isDarkMode ? Theme.of(context).primaryColor : Colors.white,
            label: isDarkMode ? 'Light Mode' : 'Dark Mode',
            child: Icon(
              isDarkMode ? Icons.lightbulb : Icons.dark_mode,
            ),
            onTap: () {
              isDarkMode
                  ? AdaptiveTheme.of(context).setLight()
                  : AdaptiveTheme.of(context).setDark();
            },
          ),
        ],
      ),
    );
  }
}
