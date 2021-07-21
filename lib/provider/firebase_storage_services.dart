import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lune_vpn_agent/config/firebase_file.dart';
import 'package:lune_vpn_agent/snackbar/error_snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class FirebaseStorageAPI {
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }

  static Future downloadFile(Reference? ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref!.name}');
    try {
      await ref.writeToFile(file);
      Share.shareFiles(['${dir.path}/${ref.name}']);
    } on FirebaseException catch (e) {
      showErrorSnackBar('Aw Snap, An error occured: ${e.code}', 2);
    }
  }

  static Future launchWeb(String? download) async {
    final url = "$download";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showErrorSnackBar('Error cannot download file', 2);
    }
  }
}
