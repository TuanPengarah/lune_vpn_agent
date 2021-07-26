import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:lune_vpn_agent/config/constant.dart';
import 'package:lune_vpn_agent/provider/current_user.dart';
import 'package:lune_vpn_agent/snackbar/error_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class PaymentWebView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? _username = context.watch<CurrentUser>().username;
    return Builder(builder: (context) {
      return IntroViewsFlutter(
        [
          PageViewModel(
            pageColor: Colors.orange,
            title: Text('Let\'s make payments'),
            body: Text.rich(
              TextSpan(
                text: 'Firstly please ',
                children: [
                  TextSpan(
                    text: 'click this link',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final url = "$kPaymentUrl";
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          showErrorSnackBar('Error cannot open link', 2);
                        }
                      },
                    style: TextStyle(
                      backgroundColor: Colors.blue,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(text: ' to make purchase'),
                ],
              ),
            ),
            mainImage: Image.asset(
              'assets/images/username.png',
              scale: 0.5,
            ),
          ),
          PageViewModel(
            pageColor: Colors.blueGrey,
            title: Text('Enter your information'),
            body: Text('Enter the amount of credit and make payment via FPX'),
            mainImage: Image.asset('assets/images/form.png'),
          ),
          PageViewModel(
            pageColor: Colors.lightGreen,
            title: Text('Screenshots'),
            body: Text.rich(
              TextSpan(
                text: 'Take a screenshots your payments status and ',
                children: [
                  TextSpan(
                    text: 'click here to send to our admin',
                    style: TextStyle(
                      backgroundColor: Colors.blue,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final url = "$kWhatsappLink$_username";
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          showErrorSnackBar('Error cannot open link', 2);
                        }
                      },
                  ),
                ],
              ),
            ),
            mainImage: Image.asset('assets/images/points.png'),
          ),
          PageViewModel(
            pageColor: Colors.teal,
            title: Text('Wait for confirmation'),
            body: Text(
              'We will update your credit as soon as posible',
            ),
            mainImage: Image.asset('assets/images/server.png'),
          ),
        ],
        showSkipButton: false,
        showBackButton: true,
        showNextButton: true,
        onTapDoneButton: () {
          Navigator.of(context).pop();
        },
      );
    });
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
