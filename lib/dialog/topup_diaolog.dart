import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/screen/payment/payment_webview.dart';
import 'package:ndialog/ndialog.dart';

Future<void> topupDialog(BuildContext context, int? money, bool? isLow) async {
  CustomProgressDialog progressDialog = CustomProgressDialog(
    context,
    blur: 6,
    dismissable: true,
  );
  progressDialog.setLoadingWidget(
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            isLow == true
                ? 'Your account balance is low'
                : 'Your account balance is',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Icon(
            Icons.account_balance_wallet,
            color: Colors.white54,
            size: 70,
          ),
          Text(
            'RM $money',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 25,
            ),
          ),
          SizedBox(height: 15),
          Text(
            isLow == true
                ? 'You must purchase more credit to continue'
                : 'Are you sure want to purchase more credit?',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white12)),
                onPressed: () {
                  progressDialog.dismiss();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => PaymentWebView(),
                    ),
                  );
                },
                child: Text(
                  'Purchase',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  progressDialog.show();
}
