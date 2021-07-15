import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/config/routes.dart';
import 'package:lune_vpn_agent/dialog/logout_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lune VPN'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: Icon(Icons.logout),
            onPressed: () async {
              await showLogoutDialog(context).then((logout) {
                if (logout == true) {
                  Navigator.pushReplacementNamed(context, MyRoutes.login);
                }
                print(logout);
              });
            },
          ),
        ],
      ),
      body: Container(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Agent')
                  .doc(_user?.uid)
                  .collection('Order')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text('Loading'),
                      ],
                    ),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.browser_not_supported,
                            size: 90,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'You can request VPN by pressing on + icon',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              })),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab',
        tooltip: 'Request VPN',
        onPressed: () {
          Navigator.pushNamed(context, MyRoutes.add);
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
