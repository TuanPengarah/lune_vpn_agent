import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/config/constant.dart';
import 'package:web_browser/web_browser.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({Key? key}) : super(key: key);

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payments',
        ),
      ),
      body: WebBrowser(
        initialUrl: 'https://toyyibpay.com/Lune-VPN-Wallet',
        javascriptEnabled: false,
        interactionSettings: WebBrowserInteractionSettings(
          topBar: SizedBox.shrink(),
          bottomBar: SizedBox.shrink(),
        ),
      ),
    );
  }
}
