import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/config/constant.dart';
import 'package:lune_vpn_agent/main.dart';
import 'package:lune_vpn_agent/provider/current_user.dart';
import 'package:lune_vpn_agent/provider/vpn_filter_list.dart';
import 'package:lune_vpn_agent/screen/overview/user_vpn_overview.dart';
import 'package:lune_vpn_agent/ui/card_order.dart';
import 'package:lune_vpn_agent/ui/menu/vpn_sort.dart';
import 'package:provider/provider.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:intl/intl.dart';

class VpnPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? _uid = Provider.of<CurrentUser>(context).uid;
    bool _isAscending = Provider.of<VpnFilterList>(context).isAscending;
    bool _isAll = Provider.of<VpnFilterList>(context).isAll;
    String _status = Provider.of<VpnFilterList>(context).status;
    return Scaffold(
        body: CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          title: Text('Vpn User'),
          floating: true,
          actions: [
            PopupMenuButton<IconMenu>(
              tooltip: 'Filter',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              icon: Icon(
                Icons.view_list,
                color: Colors.white,
              ),
              onSelected: (value) {
                switch (value) {
                  case MenuVpnSort.all:
                    context.read<VpnFilterList>().setAllFilter(true);
                    context.read<VpnFilterList>().setStatus('All');
                    break;
                  case MenuVpnSort.pending:
                    context.read<VpnFilterList>().setAllFilter(false);
                    context.read<VpnFilterList>().setStatus('Pending');
                    break;
                  case MenuVpnSort.active:
                    context.read<VpnFilterList>().setAllFilter(false);
                    context.read<VpnFilterList>().setStatus('Active');
                    break;
                  case MenuVpnSort.expired:
                    context.read<VpnFilterList>().setAllFilter(false);
                    context.read<VpnFilterList>().setStatus('Expired');
                    break;
                  case MenuVpnSort.canceled:
                    context.read<VpnFilterList>().setAllFilter(false);
                    context.read<VpnFilterList>().setStatus('Canceled');
                    break;
                }
              },
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
              tooltip: 'Order by',
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
            SizedBox(height: 30),
            Center(
              child: Container(
                width: 220,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Filtering vpn list in ',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '$_status',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      TextSpan(text: ' type with a '),
                      TextSpan(
                        text: _isAscending == true ? 'Ascending' : 'Descending',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      TextSpan(text: ' order!'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            StreamBuilder(
                stream: _isAll == true
                    ? FirebaseFirestore.instance
                        .collection('Agent')
                        .doc(_uid)
                        .collection('Order')
                        .orderBy('timeStamp', descending: _isAscending)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('Agent')
                        .doc(_uid)
                        .collection('Order')
                        .orderBy('timeStamp', descending: _isAscending)
                        .where('Status', isEqualTo: '$_status')
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
                        height: MediaQuery.of(context).size.height / 2,
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
                              'No VPN User found! You can request VPN by '
                              'pressing on + icon',
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
                    String? _vpnEnd = doc['VPN end'];
                    DateTime _dateNow = DateTime.now();

                    DateTime _expiredVPN =
                        DateFormat("dd/MM/yyyy").parse(_vpnEnd.toString());

                    _updateVPN() {
                      if (_expiredVPN.isBefore(_dateNow)) {
                        FirebaseFirestore.instance
                            .collection('Agent')
                            .doc(_uid)
                            .collection('Order')
                            .doc(doc.id)
                            .update({
                          'isPay': false,
                          'Status': 'Expired',
                        });
                      }
                    }

                    if (doc['Status'] == 'Active') {
                      _updateVPN();
                    }

                    return Padding(
                      padding: kPadding,
                      child: Hero(
                        tag: '${doc.id}',
                        child: CardOrder(
                          onPressed: () {
                            messengerKey.currentState!.removeCurrentSnackBar();
                            context.pushTransparentRoute(
                              VpnOverview(
                                uid: doc.id,
                                isPending: doc['isPending'],
                                status: doc['Status'],
                                userName: doc['Username'],
                                price: doc['Harga'],
                                email: doc['Email'],
                                location: doc['serverLocation'],
                                duration: doc['Duration'],
                                remarks: doc['Remarks'],
                                timeStamp: doc['timeStamp'],
                                vpnEnd: doc['VPN end'],
                                agent: doc['Agent']
                              ),
                            );
                          },
                          userName: doc['Username'],
                          status: doc['Status'],
                          isPending: doc['isPending'],
                          serverLocation: doc['serverLocation'],
                          harga: doc['Harga'],
                          duration: doc['Duration'],
                          remarks: doc['Remarks'],
                          timeStamp: doc['timeStamp'],
                          vpnEnd: doc['VPN end'],
                        ),
                      ),
                    );
                  }).toList());
                }),
            SizedBox(height: 60),
          ]),
        ),
      ],
    ));
  }
}
