import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/config/constant.dart';
import 'package:lune_vpn_agent/provider/current_user.dart';
import 'package:lune_vpn_agent/provider/vpn_filter_list.dart';
import 'package:lune_vpn_agent/ui/card_order.dart';
import 'package:lune_vpn_agent/ui/menu/vpn_sort.dart';
import 'package:provider/provider.dart';

class VpnPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? _uid = Provider.of<CurrentUser>(context).uid;
    bool _isAscending = Provider.of<VpnFilterList>(context).isAscending;
    return Scaffold(
        body: CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          title: Text('Vpn User'),
          floating: true,
          actions: [
            PopupMenuButton<IconMenu>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              icon: Icon(
                Icons.view_list,
                color: Colors.white,
              ),
              onSelected: (value) {},
              itemBuilder: (context) => MenuVpnSort.items
                  .map(
                    (i) => PopupMenuItem<IconMenu>(
                      value: i,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          i.icon,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(i.text),
                      ),
                    ),
                  )
                  .toList(),
            ),
            PopupMenuButton<IconMenu>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              icon: Icon(
                Icons.filter_list,
                color: Colors.white,
              ),
              onSelected: (value) {
                switch (value) {
                  case MenuVpnAscending.ascending:
                    print('Running');
                    Provider.of<VpnFilterList>(context, listen: false)
                        .setAscending(true);
                    break;
                  case MenuVpnAscending.descending:
                    Provider.of<VpnFilterList>(context, listen: false)
                        .setAscending(false);
                    break;
                }
              },
              itemBuilder: (context) => MenuVpnAscending.items
                  .map(
                    (i) => PopupMenuItem<IconMenu>(
                      value: i,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          i.icon,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(i.text),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Agent')
                    .doc(_uid)
                    .collection('Order')
                    .orderBy('timeStamp', descending: _isAscending)
                    // .where('Status', isEqualTo: 'Expired')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      height: MediaQuery.of(context).size.height / 1.5,
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
                      child: Container(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.browser_not_supported,
                              size: kIconNotFound,
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
                  return Column(
                      children: snapshot.data!.docs.map((doc) {
                    return Padding(
                      padding: kPadding,
                      child: CardOrder(
                          userName: doc['Username'],
                          status: doc['Status'],
                          isPending: doc['isPending'],
                          serverLocation: doc['serverLocation'],
                          harga: doc['Harga'],
                          duration: doc['Duration'],
                          remarks: doc['Remarks']),
                    );
                  }).toList());
                })
          ]),
        ),
      ],
    ));
  }

  void _handleClick(String? value, BuildContext context) {
    switch (value) {
      case 'Ascending':
        Provider.of<VpnFilterList>(context, listen: false).setAscending(true);
        break;
      case 'Descending':
        Provider.of<VpnFilterList>(context, listen: false).setAscending(false);
        break;
    }
  }
}
