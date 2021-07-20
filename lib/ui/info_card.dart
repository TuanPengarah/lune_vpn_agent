import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String? title;
  final String? total;

  InfoCard({this.title, this.total});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        height: 115,
        width: 100,
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$title',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    Divider(),
                    Text(
                      total == '0' ? '--' : '$total',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
