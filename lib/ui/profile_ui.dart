import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:lune_vpn_agent/dialog/topup_diaolog.dart';

Container myAccountCard(
    IconData? icon, String title, String subtitle, double? fntSize) {
  return Container(
    width: 450,
    child: Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: fntSize,
          ),
        ),
      ),
    ),
  );
}

Container userCard(BuildContext context, int? money, bool isAgent) {
  return Container(
    width: 450,
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Balance',
            style: TextStyle(
              letterSpacing: 1.1,
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w200,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'RM $money',
            style: TextStyle(
              letterSpacing: 1.1,
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Text(
            isAgent == true ? 'Agent User' : 'Normal User',
            style: TextStyle(
              letterSpacing: 1.1,
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w200,
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  topupDialog(context, money, false);
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white24,
                  ),
                ),
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Buy Credit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Row header(BuildContext context, String? name) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          Text(
            '$name',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      AdvancedAvatar(
        name: '$name',
        size: 50,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    ],
  );
}
