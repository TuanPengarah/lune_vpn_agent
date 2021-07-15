import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class AddVPN extends StatefulWidget {
  const AddVPN({Key? key}) : super(key: key);

  @override
  _AddVPNState createState() => _AddVPNState();
}

class _AddVPNState extends State<AddVPN> {
  final _userNameController = TextEditingController();
  bool _isMobile = false;
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
        return IntroViewsFlutter(
          [
            PageViewModel(
              pageColor: Colors.blue,
              title: Text('Create new username'),
              body: Text('Please create your new username to request VPN'),
              mainImage: Image.asset(
                'assets/images/username.png',
                // width: 280,
                // height: 280,
                alignment: Alignment.center,
              ),
            ),
            PageViewModel(
              pageColor: Colors.blueGrey,
              title: _isMobile == true ? buildTextField() : subtitle(),
              body: _isMobile == true ? subtitle() : buildTextField(),
              mainImage: Image.asset(
                'assets/images/points.png',
                // width: 280,
                // height: 280,
                alignment: Alignment.center,
              ),
              titleTextStyle: TextStyle(fontSize: 30),
            ),
          ],
          onTapDoneButton: () {
            Navigator.of(context).pop();
          },
          showNextButton: true,
          showBackButton: true,
          showSkipButton: false,
        );
      }),
    );
  }

  Text subtitle() {
    return Text(
      'Your points wallet will deducted when your request status is '
      'completed',
      textAlign: TextAlign.center,
    );
  }

  TextField buildTextField() {
    return TextField(
      style: TextStyle(
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: 'Enter your vpn username',
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
