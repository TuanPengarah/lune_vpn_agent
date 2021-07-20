import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/dialog/logout_dialog.dart';
import 'package:lune_vpn_agent/provider/current_user.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          child: Text('Profile Page'),
          onTap: () async {
            await showLogoutDialog(context).then((logout) {
              if (logout == true) {
                Provider.of<CurrentUser>(context, listen: false)
                    .checkLogin(false);
                print('logging out..');
              }
              print(logout);
            });
          },
        ),
      ),
    );
  }
}
