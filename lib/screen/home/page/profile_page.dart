import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/dialog/logout_dialog.dart';
import 'package:lune_vpn_agent/provider/current_user.dart';
import 'package:lune_vpn_agent/ui/profile_ui.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isMobile = true;
  String? _name = '--';
  int? _money = 0;
  String? _phone = '--';
  String? _devices = '--';
  @override
  void initState() {
    super.initState();
    _checkDevice();
  }

  Future<void> _checkDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      _devices = '${webBrowserInfo.platform} | ${webBrowserInfo.product}';
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _devices = '${androidInfo.brand} | ${androidInfo.model}';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String? _uid = context.watch<CurrentUser>().uid;
    String? _email = context.watch<CurrentUser>().email;
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Agent')
                .doc(_uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                _name = '--';
                _money = 0;
                _phone = '--';
              } else {
                _name = snapshot.data!['Name'];
                _money = snapshot.data!['Money'];
                _phone = snapshot.data!['Phone'];
                context.read<CurrentUser>().setMoney(snapshot.data!['Money']);
              }
              return LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  _isMobile = false;
                } else {
                  _isMobile = true;
                }
                return Container(
                  width: constraints.maxWidth,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 25),
                      child: Column(
                        crossAxisAlignment: _isMobile == false
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          header(context, _name),
                          SizedBox(height: 45),
                          userCard(context, _money),
                          SizedBox(height: 30),
                          Text(
                            'My Account',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          myAccountCard(Icons.person, 'Name', '$_name', 14),
                          myAccountCard(
                              Icons.phone, 'Phone Number', '$_phone', 14),
                          myAccountCard(Icons.mail, 'Email', '$_email', 14),
                          myAccountCard(Icons.badge, 'UID', '$_uid', 13),
                          SizedBox(height: 10),
                          Container(
                            width: 450,
                            child: Divider(thickness: 1),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 450,
                            child: Card(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _isDarkMode
                                        ? AdaptiveTheme.of(context).setLight()
                                        : AdaptiveTheme.of(context).setDark();
                                  });
                                },
                                child: ListTile(
                                  leading: Icon(Icons.dark_mode),
                                  title: Text('Dark Mode'),
                                  trailing: Switch(
                                    onChanged: (bool value) {
                                      setState(() {
                                        _isDarkMode
                                            ? AdaptiveTheme.of(context)
                                                .setLight()
                                            : AdaptiveTheme.of(context)
                                                .setDark();
                                      });
                                    },
                                    value: _isDarkMode,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: 450,
                            height: 50,
                            child: ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.red.shade400,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                splashFactory: InkSplash.splashFactory,
                              ),
                              onPressed: () async {
                                await showLogoutDialog(context).then((logout) {
                                  if (logout == true) {
                                    Provider.of<CurrentUser>(context,
                                            listen: false)
                                        .checkLogin(false);
                                    print('logging out..');
                                  }
                                  print(logout);
                                });
                              },
                              icon: Icon(Icons.logout),
                              label: Text('Sign Out'),
                            ),
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: Text(
                              'Lune VPN 0.18\nRunning on $_devices',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
            }),
      ),
    );
  }
}
