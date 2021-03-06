import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/dialog/topup_diaolog.dart';
import 'package:lune_vpn_agent/provider/cloud_function.dart';
import 'package:lune_vpn_agent/provider/current_user.dart';
import 'package:lune_vpn_agent/provider/firestore_services.dart';
import 'package:lune_vpn_agent/provider/send_email.dart';
import 'package:lune_vpn_agent/snackbar/error_snackbar.dart';
import 'package:lune_vpn_agent/snackbar/success_snackbar.dart';
import 'package:lune_vpn_agent/ui/circular_loading_dialog.dart';
import 'package:lune_vpn_agent/ui/textbar_addVPN.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

class AddVPN extends StatefulWidget {
  const AddVPN({Key? key}) : super(key: key);

  @override
  _AddVPNState createState() => _AddVPNState();
}

class _AddVPNState extends State<AddVPN> {
  final _userNameController = TextEditingController();
  bool _errUsername = false;
  User? _user = FirebaseAuth.instance.currentUser;
  int _currentStep = 0;
  List<String> _location = ['Malaysia', 'Singapore'];
  String? _selectedLocation = 'Malaysia';
  List<String> _duration = [
    '1 Days Free Trial',
    '15 Days (RM5)',
    '30 Days (RM9)',
    '60 Days (RM16)'
  ];
  List<String> _durationNormal = [
    '15 Days (RM7)',
    '30 Days (RM12)',
    '60 Days (RM18)'
  ];
  String? _currentDuration = '30 Days (RM9)';
  String? _currentNormalDuration = '30 Days (RM12)';
  int? _priceVPN;

  String? _normalPrice() {
    String? status;
    if (_currentNormalDuration == '15 Days (RM7)') {
      status = 'RM: 7';
      _priceVPN = 7;
    } else if (_currentNormalDuration == '30 Days (RM12)') {
      status = 'RM: 12';
      _priceVPN = 12;
    } else if (_currentNormalDuration == '60 Days (RM18)') {
      status = 'RM: 18';
      _priceVPN = 18;
    }
    return status;
  }

  String? _price() {
    String? status;
    if (_currentDuration == '1 Days Free Trial') {
      status = 'Free Trial';
      _priceVPN = 0;
    } else if (_currentDuration == '15 Days (RM5)') {
      status = 'RM: 5';
      _priceVPN = 5;
    } else if (_currentDuration == '30 Days (RM9)') {
      status = 'RM: 9';
      _priceVPN = 9;
    } else if (_currentDuration == '60 Days (RM16)') {
      status = 'RM: 16';
      _priceVPN = 16;
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    bool _isAgent = context.watch<CurrentUser>().isSuperUser;
    int? _myMoney = context.watch<CurrentUser>().myMoney;
    String? _email = context.watch<CurrentUser>().email;
    String? _getCustomer = context.watch<CurrentUser>().username;
    return Hero(
      tag: 'fab',
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Request VPN',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Close',
                          color: Colors.white,
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Fill in the information below to completed your request',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Stepper(
                          physics: BouncingScrollPhysics(),
                          steps: _myStep(_isAgent),
                          currentStep: _currentStep,
                          onStepContinue: () async {
                            if (_currentStep == 0) {
                              //vpn named
                              if (_userNameController.text.isEmpty) {
                                setState(() {
                                  _errUsername = true;
                                });
                              } else {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  _errUsername = false;
                                  _currentStep = _currentStep + 1;
                                });
                              }
                              // setState(() {
                              //   _currentStep = _currentStep + 1;
                              // });
                            } else if (_currentStep == 1) {
                              //server location
                              setState(() {
                                _currentStep = _currentStep + 1;
                              });
                            } else if (_currentStep == 2) {
                              //vpn duration
                              setState(() {
                                _currentStep = _currentStep + 1;
                              });
                            } else if (_currentStep == 3) {
                              if (_myMoney! < _priceVPN!) {
                                topupDialog(context, _myMoney, true);
                              } else {
                                //confirmation
                                CustomProgressDialog progressDialog =
                                    CustomProgressDialog(context,
                                        blur: 6, dismissable: false);
                                progressDialog.setLoadingWidget(
                                    CircularLoadingDialog('Requesting VPN...'));
                                progressDialog.show();
                                await context
                                    .read<FirebaseFirestoreAPI>()
                                    .createVPN(
                                      customer: _getCustomer,
                                      uid: _user!.uid,
                                      username: _userNameController.text,
                                      email: _user!.email.toString(),
                                      serverLocation: _selectedLocation,
                                      duration: _isAgent == true
                                          ? _currentDuration
                                          : _currentNormalDuration,
                                      price: _priceVPN,
                                    )
                                    .then((s) async {
                                  if (s == 'completed') {
                                    await sendEmail(
                                        name: _getCustomer,
                                        email: _email,
                                        emailSendTo: 'lunelabanoon@icloud.com',
                                        subject:
                                            'Hooray! You get new order from $_getCustomer',
                                        message:
                                            'VPN name: ${_userNameController.text}| Server Location: $_selectedLocation| Price: RM$_priceVPN');
                                    await sendNotification();
                                    progressDialog.dismiss();
                                    Navigator.of(context).pop();
                                    await Future.delayed(Duration(seconds: 1));
                                    showSuccessSnackBar('Request Completed', 2);
                                  } else {
                                    progressDialog.dismiss();
                                    Navigator.of(context).pop();
                                    await Future.delayed(Duration(seconds: 1));
                                    showErrorSnackBar(
                                        'Error: ${s.toString()}', 2);
                                  }
                                });
                              }
                            }
                          },
                          onStepCancel: () {
                            if (_currentStep > 0) {
                              setState(() {
                                _currentStep = _currentStep - 1;
                              });
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Step> _myStep(bool isAgent) {
    List<Step> _step = [
      Step(
        title: Text('Please name your VPN'),
        content: buildTextField(_userNameController, _errUsername),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('Choose your server location'),
        content: Container(
          alignment: Alignment.centerLeft,
          child: DropdownButton(
            items: _location.map((String value) {
              return DropdownMenuItem<String>(
                child: Text(
                  value.toString(),
                ),
                value: value,
              );
            }).toList(),
            value: _selectedLocation,
            onChanged: (String? newValue) {
              setState(() {
                _selectedLocation = newValue;
              });
            },
          ),
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('Select your vpn duration'),
        content: Container(
          alignment: Alignment.centerLeft,
          child: isAgent == true
              ? DropdownButton(
                  items: _duration.map((String value) {
                    return DropdownMenuItem<String>(
                      child: Text(
                        value.toString(),
                      ),
                      value: value,
                    );
                  }).toList(),
                  value: _currentDuration,
                  onChanged: (String? newValue) {
                    setState(() {
                      _currentDuration = newValue;
                    });
                  },
                )
              : DropdownButton(
                  items: _durationNormal.map((String value) {
                    return DropdownMenuItem<String>(
                      child: Text(
                        value.toString(),
                      ),
                      value: value,
                    );
                  }).toList(),
                  value: _currentNormalDuration,
                  onChanged: (String? newValue) {
                    setState(() {
                      _currentNormalDuration = newValue;
                    });
                  },
                ),
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Text('Confirmation your selection'),
        content: Wrap(
          children: [
            confirmationWidget(Icons.vpn_key, _userNameController.text),
            confirmationWidget(
                Icons.map, '${_selectedLocation.toString()} Server'),
            confirmationWidget(
              Icons.calendar_today,
              isAgent == true
                  ? _currentDuration.toString()
                  : _currentNormalDuration.toString(),
            ),
            confirmationWidget(
              Icons.price_change,
              isAgent == true ? _price().toString() : _normalPrice().toString(),
            ),
          ],
        ),
        isActive: _currentStep >= 3,
      ),
    ];
    return _step;
  }

  Padding confirmationWidget(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Icon(icon, size: 15),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
            ),
          ),
        ],
      ),
    );
  }
}
