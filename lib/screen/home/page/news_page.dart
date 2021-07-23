import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/config/constant.dart';
import 'package:lune_vpn_agent/ui/card_userInfo.dart';

class HomeNewsPage extends StatelessWidget {
  final String? totalUser;
  final String? pending;
  final String? active;
  final String? expired;
  final String? canceled;

  HomeNewsPage(
      {this.totalUser, this.pending, this.active, this.expired, this.canceled});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          title: Text('Dashboard'),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: kPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Your VPN Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      children: [
                        InfoCard(
                          title: 'Total User',
                          total: '$totalUser',
                        ),
                        InfoCard(
                          title: 'Pending',
                          total: '$pending',
                        ),
                        InfoCard(
                          title: 'Active',
                          total: '$active',
                        ),
                        InfoCard(
                          title: 'Expired',
                          total: '$expired',
                        ),
                        InfoCard(
                          title: 'Canceled',
                          total: '$canceled',
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Text(
                      'News Feed',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 30),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('News')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
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
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.feed,
                                    color: Colors.grey,
                                    size: kIconNotFound,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'No news found',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                ],
                              ),
                            );
                          }
                          return Column(
                            children: snapshot.data!.docs.map((doc) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ExpandablePanel(
                                  header: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          doc['Title'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          doc['Tarikh'],
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                  collapsed: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 13.0, vertical: 5),
                                    child: Text(
                                      doc['Subtitle'],
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  expanded: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(doc['Content']),
                                  ),
                                  theme: ExpandableThemeData(
                                    inkWellBorderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    tapBodyToExpand: true,
                                    tapBodyToCollapse: true,
                                    tapHeaderToExpand: true,
                                    iconColor: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
