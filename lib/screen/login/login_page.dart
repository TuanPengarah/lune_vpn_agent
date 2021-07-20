import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/provider/auth_services.dart';
import 'package:lune_vpn_agent/snackbar/error_snackbar.dart';
import 'package:lune_vpn_agent/snackbar/success_snackbar.dart';
import 'package:lune_vpn_agent/ui/textbar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:validators/validators.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final RoundedLoadingButtonController _loginButton =
      RoundedLoadingButtonController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool? _showPassword = true;
  bool _errEmail = false;
  bool _errPass = false;
  bool _isMobile = false;

  void _checkLogin() {
    if (!isEmail(_emailController.text)) {
      setState(() {
        _errEmail = true;
      });
      _errorButton();
    }
    if (_passwordController.text.isEmpty) {
      setState(() {
        _errPass = true;
      });
      _errorButton();
    }

    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      _performLoginTask();
    }
  }

  void _performLoginTask() async {
    await context
        .read<AuthenticationServices>()
        .signIn(_emailController.text, _passwordController.text)
        .then((e) async {
      if (e == 'user-not-found') {
        showErrorSnackBar(
            'User not found. Please use registered email '
            'address!',
            2);
        _errorButton();
      } else if (e == 'wrong-password') {
        showErrorSnackBar(
            'Wrong password. Please use your correct '
            'password!',
            2);
        _errorButton();
      } else if (e == 'completed') {
        if (kIsWeb) {
          print('Set auto Auth on Web');
          await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
        }
        _loginButton.success();

        Future.delayed(Duration(seconds: 1), () {
          showSuccessSnackBar('Login Success', 2);
          // Navigator.pushReplacementNamed(context, MyRoutes.home);
        });
      } else {
        showErrorSnackBar('Aw Snap! An error occured: $e', 2);
        _errorButton();
      }
      // showErrorSnackBar(e.toString());
      // _errorButton();
    });
  }

  void _errorButton() async {
    _loginButton.error();
    await Future.delayed(Duration(seconds: 2));
    _loginButton.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.vpn_key),
        title: Text('Login to Lune VPN'),
        actions: [
          IconButton(
            icon: Icon(Icons.dark_mode),
            onPressed: () {
              AdaptiveTheme.of(context).toggleThemeMode();
              // isDarkMode == true
              //     ? mode = ThemeMode.dark
              //     : mode = ThemeMode.light;
              //
              // _isDarkMode == true
              //     ? Provider.of<ThemeNotifier>(context, listen: false)
              //         .toggleTheme(false)
              //     : Provider.of<ThemeNotifier>(context, listen: false)
              //         .toggleTheme(true);
              // print(_isDarkMode);
            },
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        if (constraint.maxWidth >= 800) {
          _isMobile = false;
        } else {
          _isMobile = true;
        }

        return Container(
          height: constraint.maxHeight,
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textBar(
                      textController: _emailController,
                      isPassword: false,
                      context: context,
                      isMobile: _isMobile,
                      inputType: TextInputType.emailAddress,
                      icon: Icons.person,
                      label: 'Email',
                      hint: 'example@email.com',
                      inputAction: TextInputAction.next,
                      error: _errEmail == true
                          ? 'Please enter your correct '
                              'email address'
                          : null,
                    ),
                    SizedBox(height: 15),
                    textBar(
                        textController: _passwordController,
                        isPassword: _showPassword!,
                        context: context,
                        isMobile: _isMobile,
                        inputType: TextInputType.visiblePassword,
                        icon: Icons.password,
                        label: 'Password',
                        hint: 'Enter your password',
                        inputAction: TextInputAction.done,
                        error: _errPass == true
                            ? 'Please enter your password'
                            : null,
                        onEnter: (value) {
                          _loginButton.start();
                        }),
                    SizedBox(height: 10),
                    SizedBox(
                      width: _isMobile == true ? double.infinity : 450,
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
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _errEmail = false;
                          _errPass = false;
                        });
                        _checkLogin();
                      },
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
          ),
        );
      }),
    );
  }
}
