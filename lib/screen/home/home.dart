import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lune_vpn_agent/config/routes.dart';
import 'package:lune_vpn_agent/dialog/topup_diaolog.dart';
import 'package:lune_vpn_agent/provider/auth_services.dart';
import 'package:lune_vpn_agent/provider/current_user.dart';
import 'package:lune_vpn_agent/provider/firestore_services.dart';
import 'package:lune_vpn_agent/screen/home/page/file_page.dart';
import 'package:lune_vpn_agent/screen/home/page/news_page.dart';
import 'package:lune_vpn_agent/screen/home/page/profile_page.dart';
import 'package:lune_vpn_agent/screen/home/page/vpn_page.dart';
import 'package:lune_vpn_agent/snackbar/error_snackbar.dart';
import 'package:lune_vpn_agent/snackbar/notif_snackbar.dart';
import 'package:lune_vpn_agent/snackbar/success_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
  User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    if (kIsWeb == false) {
      FirebaseMessaging.instance.subscribeToTopic('agentVPN');
    }
    _checkUser().then((value) => _getToken());

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];

        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });

    ///foreground work
    FirebaseMessaging.onMessage.listen((message) {
      print(message.data);

      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
        showNotifSnackBar(message.notification!.body.toString(), 2);
        if (kIsWeb == false) {
          final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: id,
              channelKey: 'agentVPN',
              title: message.notification!.title,
              body: message.notification!.body,
            ),
          );
        }
      }
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];

      Navigator.of(context).pushNamed(routeFromMessage);
    });
  }

  Future<void> _checkUser() async {
    await FirebaseFirestore.instance
        .collection('Agent')
        .doc(_user!.uid)
        .get()
        .then((snap) async {
      if (!snap.exists) {
        messengerKey.currentState!.clearSnackBars();
        await context.read<AuthenticationServices>().signOut();
        showErrorSnackBar('Sorry admin user cannot access this apps', 2);
      } else {
        showSuccessSnackBar('Login Success', 2);
      }
    });
  }

  void _getToken() async {
    //check user first

    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();

    await context.read<FirebaseFirestoreAPI>().saveTokenToDatabase(token);
    print(token);
    FirebaseMessaging.instance.onTokenRefresh.listen((event) async {
      await context.read<FirebaseFirestoreAPI>().saveTokenToDatabase(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    String? uid = Provider.of<CurrentUser>(context).uid;
    int? _money = context.watch<CurrentUser>().myMoney;
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
          if (page >= 2) {
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
            label: 'Buy Credit',
            child: Icon(Icons.account_balance_wallet),
            onTap: () {
              topupDialog(context, _money, false);
            },
          ),
        ],
      ),
    );
  }
}
