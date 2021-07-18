import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/config/routes.dart';
import 'package:lune_vpn_agent/dialog/logout_dialog.dart';
import 'package:lune_vpn_agent/main.dart';
import 'package:lune_vpn_agent/ui/card_order.dart';

class VpnPage extends StatelessWidget {
  final _user = FirebaseAuth.instance.currentUser;
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Agent')
            .doc(_user?.uid)
            .collection('Order')
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

          return CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      children: snapshot.data!.docs.map((doc) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 12),
                          child: CardOrder(
                              userName: doc['Username'],
                              status: doc['Status'],
                              isPending: doc['isPending'],
                              serverLocation: doc['serverLocation'],
                              harga: doc['Harga'],
                              duration: doc['Duration'],
                              remarks: doc['Remarks']),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab',
        tooltip: 'Request VPN',
        onPressed: () {
          messengerKey.currentState!.removeCurrentSnackBar();
          Navigator.pushNamed(context, MyRoutes.add);
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
