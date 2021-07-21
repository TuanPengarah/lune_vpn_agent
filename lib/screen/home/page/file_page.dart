import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/config/firebase_file.dart';
import 'package:lune_vpn_agent/provider/current_user.dart';
import 'package:lune_vpn_agent/provider/firebase_storage_services.dart';
import 'package:lune_vpn_agent/ui/card_fileName.dart';
import 'package:provider/provider.dart';

class FilePage extends StatefulWidget {
  final String? uid;
  FilePage({this.uid});

  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  late Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    futureFiles = FirebaseStorageAPI.listAll('ovpn/${widget.uid}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Vpn Files'),
        ),
        body: FutureBuilder<List<FirebaseFile>>(
            future: futureFiles,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case (ConnectionState.waiting):
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(child: Text('Some error occurred!'));
                  } else {
                    final files = snapshot.data!;
                    return Column(
                      children: [
                        ListTile(
                          tileColor: Theme.of(context).primaryColor,
                          leading: Icon(
                            Icons.text_snippet,
                            color: Colors.white,
                          ),
                          title: Text(
                            '${files.length} files available',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: files.length,
                              itemBuilder: (context, index) {
                                final file = files[index];
                                return FileInfo(file: file);
                              }),
                        ),
                      ],
                    );
                  }
              }
            }));
  }
}
