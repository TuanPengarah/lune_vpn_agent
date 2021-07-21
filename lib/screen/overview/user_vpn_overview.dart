import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

class VpnOverview extends StatelessWidget {
  final String? uid;
  VpnOverview({this.uid});
  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismiss: () => Navigator.of(context).pop(),
      child: Scaffold(
          body: Hero(
        tag: '$uid',
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
      )),
    );
  }
}
