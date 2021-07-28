import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/config/routes.dart';
import 'package:lune_vpn_agent/config/theme_data.dart';
import 'package:lune_vpn_agent/provider/auth_services.dart';
import 'package:lune_vpn_agent/provider/current_user.dart';
import 'package:lune_vpn_agent/provider/firestore_services.dart';
import 'package:lune_vpn_agent/provider/vpn_filter_list.dart';
import 'package:lune_vpn_agent/screen/addVPN/add_page.dart';
import 'package:lune_vpn_agent/screen/home/home.dart';
import 'package:lune_vpn_agent/screen/login/login_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// flutter run -d web-server --web-port 8080 --web-hostname 192.168.1.17
///Receive message when app is in background solution for on message
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  if (kIsWeb == false) {
    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        null,
        [
          NotificationChannel(
              channelKey: 'agentVPN',
              channelName: 'Agent VPN',
              channelDescription: 'Notification channel for receiving VPN',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.blue)
        ]);
  }
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(saveThemeMode: savedThemeMode));
}

final messengerKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? saveThemeMode;
  MyApp({this.saveThemeMode});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationServices>(
          create: (context) => AuthenticationServices(FirebaseAuth.instance),
        ),
        Provider<FirebaseFirestoreAPI>(
          create: (context) => FirebaseFirestoreAPI(FirebaseFirestore.instance),
        ),
        Provider<CurrentUser>(create: (context) => CurrentUser()),
        ChangeNotifierProvider<VpnFilterList>(
            create: (context) => VpnFilterList()),
      ],
      child: AdaptiveTheme(
        initial: saveThemeMode ?? AdaptiveThemeMode.light,
        light: MyThemes.lightTheme,
        dark: MyThemes.darkTheme,
        builder: (theme, darktheme) {
          return MaterialApp(
            scaffoldMessengerKey: messengerKey,
            debugShowCheckedModeBanner: false,
            title: 'Lune VPN',
            theme: theme,
            darkTheme: darktheme,
            initialRoute: MyRoutes.login,
            routes: {
              MyRoutes.login: (context) => LoginServices(),
              MyRoutes.add: (context) => AddVPN(),
              MyRoutes.home: (context) => HomePage(),
            },
          );
        },
      ),
    );
  }
}

class LoginServices extends StatefulWidget {
  const LoginServices({Key? key}) : super(key: key);

  @override
  _LoginServicesState createState() => _LoginServicesState();
}

class _LoginServicesState extends State<LoginServices> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('user login');
            Provider.of<CurrentUser>(context, listen: false).checkLogin(true);
            Provider.of<CurrentUser>(context, listen: false)
                .setEmail(_auth.currentUser!.email);
            Provider.of<CurrentUser>(context, listen: false)
                .setUID(_auth.currentUser!.uid);
            Provider.of<CurrentUser>(context, listen: false)
                .setUserName(_auth.currentUser!.displayName);
            return HomePage();
          } else {
            print('user not login');
            return LoginPage();
          }
        });
  }
}
