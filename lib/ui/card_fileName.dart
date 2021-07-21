import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/config/constant.dart';
import 'package:lune_vpn_agent/config/firebase_file.dart';
import 'package:lune_vpn_agent/provider/firebase_storage_services.dart';
import 'package:lune_vpn_agent/snackbar/notif_snackbar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FileInfo extends StatelessWidget {
  const FileInfo({
    Key? key,
    this.file,
  }) : super(key: key);

  final FirebaseFile? file;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPadding,
      child: Card(
        child: ExpandablePanel(
          header: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
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
          ),
          collapsed: Container(),
          expanded: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    kIsWeb
                        ? Container()
                        : ElevatedButton.icon(
                            onPressed: () async {
                              await FirebaseStorageAPI.downloadFile(file!.ref);
                            },
                            icon: Icon(Icons.share),
                            label: Text('Share'),
                          ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        showNotifSnackBar('Trying to downloading...', 2);
                        FirebaseStorageAPI.launchWeb(file!.url);
                      },
                      icon: Icon(Icons.download),
                      label: Text('Download'),
                    ),
                  ],
                ),
              ],
            ),
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
