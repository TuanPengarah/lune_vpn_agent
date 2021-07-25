import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class PaymentWebView extends StatelessWidget {
  final page = [
    PageViewModel(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payments',
        ),
      ),
    );
  }
}

// Padding(
// padding: const EdgeInsets.all(15.0),
// child: Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// Text(
// 'Firstly please enter this link to make purchase',
// textAlign: TextAlign.center,
// style: TextStyle(
// fontSize: 15,
// color: Colors.grey,
// ),
// ),
// SizedBox(height: 5),
// ElevatedButton.icon(
// onPressed: () {},
// icon: Icon(Icons.launch),
// label: Text('Open Link'),
// ),
// SizedBox(height: 10),
// Text(
// 'Enter the amount of credit you want',
// textAlign: TextAlign.center,
// style: TextStyle(
// fontSize: 15,
// color: Colors.grey,
// ),
// ),
// SizedBox(height: 10),
// Text(
// 'And make payment via FPX',
// textAlign: TextAlign.center,
// style: TextStyle(
// fontSize: 15,
// color: Colors.grey,
// ),
// ),
// SizedBox(height: 10),
// Text(
// 'And lastly take a screen shots your payments status and send '
// 'to our admin',
// textAlign: TextAlign.center,
// style: TextStyle(
// fontSize: 15,
// color: Colors.grey,
// ),
// ),
// SizedBox(height: 5),
// ElevatedButton.icon(
// onPressed: () {},
// icon: Icon(Icons.chat),
// label: Text('Send to whatsapp'),
// ),
// ],
// ),
// ),
// ),
