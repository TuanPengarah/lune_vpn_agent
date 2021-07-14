import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/ui/textbar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final RoundedLoadingButtonController _loginButton =
      RoundedLoadingButtonController();
  bool? _showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.vpn_key),
        title: Text('Login to Lune VPN'),
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        return Container(
          height: constraint.maxHeight,
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textBar(
                      isPassword: false,
                      context: context,
                      inputType: TextInputType.emailAddress,
                      icon: Icons.person,
                      label: 'Email',
                      hint: 'example@email.com',
                      inputAction: TextInputAction.next),
                  SizedBox(height: 15),
                  textBar(
                    isPassword: _showPassword!,
                    context: context,
                    inputType: TextInputType.visiblePassword,
                    icon: Icons.password,
                    label: 'Password',
                    hint: 'Enter your password',
                    inputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 450,
                    child: Row(
                      children: [
                        Checkbox(
                          value: _showPassword == false,
                          onChanged: (bool? value) {
                            setState(() {
                              _showPassword = value == false;
                            });
                          },
                        ),
                        Text('Show Password'),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  RoundedLoadingButton(
                    controller: _loginButton,
                    onPressed: () {},
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Login',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
}
