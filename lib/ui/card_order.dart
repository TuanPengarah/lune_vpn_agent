import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class CardOrder extends StatelessWidget {
  final String? userName;
  final String? status;
  final String? duration;
  final String? serverLocation;
  final int? harga;
  final bool? isPending;
  final String? remarks;
  CardOrder({
    this.userName,
    this.status,
    this.isPending,
    this.duration,
    this.serverLocation,
    this.harga,
    this.remarks,
  });

  IconData? _statusIcon() {
    IconData? icon;
    if (status == 'Done') {
      icon = Icons.done;
    } else if (equals('Error', status)) {
      icon = Icons.error;
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title(),
            SizedBox(height: 5),
            information(Icons.timer, duration.toString()),
            information(Icons.location_on, serverLocation.toString()),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'RM $harga',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            status == 'Pending'
                                ? SizedBox(
                                    height: 12,
                                    width: 12,
                                    child: CircularProgressIndicator(
                                      color: Colors.grey,
                                      strokeWidth: 1,
                                    ),
                                  )
                                : Icon(
                                    _statusIcon(),
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                            SizedBox(width: 5),
                            Text(
                              status.toString(),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.person),
        SizedBox(width: 10),
        Text(
          userName.toString(),
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Padding information(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey,
            size: 14,
          ),
          SizedBox(width: 5),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
