import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:lune_vpn_agent/provider/firestore_services.dart';
import 'package:lune_vpn_agent/snackbar/error_snackbar.dart';
import 'package:lune_vpn_agent/snackbar/success_snackbar.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

class AddVPN extends StatefulWidget {
  const AddVPN({Key? key}) : super(key: key);

  @override
  _AddVPNState createState() => _AddVPNState();
}

class _AddVPNState extends State<AddVPN> {
  final _userNameController = TextEditingController();
  bool _isMobile = false;
  bool _errUsername = false;
  User? _user = FirebaseAuth.instance.currentUser;
  int _currentStep = 0;
  // List<ServerLocation> _serverLocation = S
  // List<DropdownMenuItem<ServerLocation>> _dropDownMenuItems;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'fab',
      child: LayoutBuilder(builder: (context, constraint) {
        if (constraint.maxWidth > 800) {
          _isMobile = false;
        } else {
          _isMobile = true;
        }
        return Scaffold(
          backgroundColor: Colors.blue,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Request VPN',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: constraint.maxWidth,
                    height: constraint.minHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Stepper(
                            steps: _myStep(),
                            currentStep: _currentStep,
                            onStepContinue: () {
                              if (_currentStep < _myStep().length - 1) {
                                setState(() {
                                  _currentStep = _currentStep + 1;
                                });
                              } else {
                                //done step
                              }
                            },
                            onStepCancel: () {
                              if (_currentStep > 0) {
                                setState(() {
                                  _currentStep = _currentStep - 1;
                                });
                              } else {
                                _currentStep = 0;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  List<Step> _myStep() {
    List<Step> _step = [
      Step(
        title: Text('Please name your VPN'),
        content: buildTextField(),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('Choose your server location'),
        content: buildTextField(),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('Select your vpn duration'),
        content: buildTextField(),
        isActive: _currentStep >= 2,
      ),
    ];
    return _step;
  }

  TextField buildTextField() {
    return TextField(
      textCapitalization: TextCapitalization.words,
      controller: _userNameController,
      decoration: InputDecoration(
        errorText:
            _errUsername == true ? 'Please enter your vpn username' : null,
        labelText: 'Enter your vpn username',
        border: OutlineInputBorder(),
      ),
    );
  }
}
// IntroViewsFlutter(
// [
// PageViewModel(
// pageColor: Colors.blue,
// title: Text('Create new username'),
// body: Text('Please choose your new username to request VPN'),
// mainImage: Image.asset(
// 'assets/images/username.png',
// // width: 280,
// // height: 280,
// alignment: Alignment.center,
// ),
// ),
// PageViewModel(
// pageColor: Colors.blueGrey,
// title: _isMobile == true ? buildTextField() : subtitle(),
// body: _isMobile == true ? subtitle() : buildTextField(),
// mainImage: Image.asset(
// 'assets/images/points.png',
// alignment: Alignment.center,
// ),
// titleTextStyle: TextStyle(fontSize: 30),
// bodyTextStyle: TextStyle(fontSize: 20),
// ),
// ],
// onTapDoneButton: () async {
// CustomProgressDialog progressDialog =
// CustomProgressDialog(context, blur: 6);
// progressDialog.setLoadingWidget(CircularProgressIndicator());
// progressDialog.show();
// setState(() {
// _errUsername = false;
// });
// if (_userNameController.text.isEmpty) {
// setState(() {
// _errUsername = true;
// });
// progressDialog.dismiss();
// } else {
// await context
//     .read<DatabaseAPI>()
//     .createVPN(
// uid: _user!.uid,
// username: _userNameController.text.trim(),
// email: _user!.email.toString())
//     .then((s) async {
// if (s == 'completed') {
// progressDialog.dismiss();
// Navigator.of(context).pop();
// await Future.delayed(Duration(seconds: 1));
// showSuccessSnackBar('Request Completed', 2);
// } else {
// progressDialog.dismiss();
// Navigator.of(context).pop();
// await Future.delayed(Duration(seconds: 1));
// showErrorSnackBar('Error: ${s.toString()}', 2);
// }
// });
// }
// },
// showNextButton: true,
// showBackButton: true,
// showSkipButton: false,
// );
