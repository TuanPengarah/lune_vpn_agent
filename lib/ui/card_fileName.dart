import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/config/firebase_file.dart';
import 'package:lune_vpn_agent/provider/firebase_storage_services.dart';
import 'package:lune_vpn_agent/snackbar/error_snackbar.dart';
import 'package:lune_vpn_agent/snackbar/notif_snackbar.dart';
import 'package:lune_vpn_agent/snackbar/success_snackbar.dart';

class FileInfo extends StatelessWidget {
  const FileInfo({
    Key? key,
    this.file,
  }) : super(key: key);

  final FirebaseFile? file;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ExpandablePanel(
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.vpn_key),
                  SizedBox(width: 10),
                  Text('${file!.name}'),
                ],
              ),
            ],
          ),
          collapsed: Container(),
          expanded: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  print(file!.url);
                },
                icon: Icon(Icons.share),
                label: Text('Share'),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  showNotifSnackBar('Trying to downloading...', 2);
                  FirebaseStorageAPI.launchWeb(file!.url);
                  // await FirebaseStorageAPI.downloadFile(file!.ref).then((s) {
                  //   if (s == 'download-completed') {
                  //     showSuccessSnackBar(
                  //         '${file!.name} has been '
                  //         'downloaded',
                  //         2);
                  //   } else {
                  //     showErrorSnackBar('Aw Snap! An error ocurred: $s', 2);
                  //   }
                  // });
                },
                icon: Icon(Icons.download),
                label: Text('Download'),
              ),
            ],
          ),
          theme: ExpandableThemeData(
            tapBodyToExpand: true,
            tapBodyToCollapse: true,
            tapHeaderToExpand: true,
            iconColor: Theme.of(context).textTheme.bodyText1!.color,
          ),
        ),
      ),
    );
  }
}
