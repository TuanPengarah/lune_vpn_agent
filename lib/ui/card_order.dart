import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:validators/validators.dart';

class CardOrder extends StatelessWidget {
  final String? userName;
  final String? status;
  final String? duration;
  final String? serverLocation;
  final int? harga;
  final bool? isPending;
  final String? remarks;
  final Function()? onPressed;
  final Timestamp? timeStamp;
  final String? vpnEnd;

  CardOrder({
    this.userName,
    this.status,
    this.isPending,
    this.duration,
    this.serverLocation,
    this.harga,
    this.remarks,
    this.onPressed,
    this.timeStamp,
    this.vpnEnd,
  });

  IconData? _statusIcon() {
    IconData? icon;
    if (equals('Active', status)) {
      icon = Icons.done;
    } else if (equals('Expired', status)) {
      icon = Icons.error;
    } else if (equals('Pending', status)) {
      icon = Icons.pending;
    } else if (equals('Canceled', status)) {
      icon = Icons.cancel_presentation;
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onLongPress: () {},
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title(),
              SizedBox(height: 5),
              information(Icons.timer, duration.toString()),
              status == 'Active'
                  ? information(Icons.date_range,
                      '${DateFormat('d/MM/yyyy').format(timeStamp!.toDate()).toString()} - $vpnEnd')
                  : Container(),
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
                            harga == 0 ? 'Free Trial' : 'RM $harga',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
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
      ),
    );
  }

  Row title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.person),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            userName.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
            ),
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
