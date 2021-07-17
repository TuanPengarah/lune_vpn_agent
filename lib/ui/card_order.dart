import 'package:flutter/material.dart';

class CardOrder extends StatelessWidget {
  final String? userName;
  final String? status;
  final bool? isPending;
  CardOrder({
    this.userName,
    this.status,
    this.isPending,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.vpn_key),
                SizedBox(width: 10),
                Text(
                  userName.toString(),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
