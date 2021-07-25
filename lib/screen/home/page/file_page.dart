import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/config/firebase_file.dart';
import 'package:lune_vpn_agent/provider/firebase_storage_services.dart';
import 'package:lune_vpn_agent/ui/card_fileName.dart';

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
    super.initState();
    futureFiles = FirebaseStorageAPI.listAll('ovpn/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Vpn Files'),
          actions: [
            IconButton(
              tooltip: 'Refresh',
              onPressed: () async {
                setState(() {
                  futureFiles = FirebaseStorageAPI.listAll('ovpn/');
                });
              },
              icon: Icon(Icons.refresh),
            ),
          ],
        ),
        body: FutureBuilder<List<FirebaseFile>>(
            future: futureFiles,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case (ConnectionState.waiting):
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text('Fetching data from server...')
                      ],
                    ),
                  );
                default:
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_late,
                              color: Colors.grey,
                              size: 100,
                            ),
                            SizedBox(height: 20),
                            Text('Uh Oh! Vpn files not found!'),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  futureFiles =
                                      FirebaseStorageAPI.listAll('ovpn/');
                                });
                              },
                              child: Text('Refresh'),
                            ),
                          ],
                        ),
                      ),
                    );
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
