import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

Future<bool?> showCancelRequest(BuildContext context, String status) async {
  bool? isCancel = false;
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    title: Text('Confirmation'),
    content: Text(status),
    actions: [
      TextButton(
        child: Text(
          'No',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        onPressed: () {
          isCancel = false;
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: Text(
          'Yes',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        onPressed: () {
          isCancel = true;
          Navigator.of(context).pop();
        },
      ),
    ],
  );
  await DialogBackground(
    blur: 6,
    dialog: alert,
  ).show(context);
  return isCancel;
}
