import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseAPI extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  DatabaseAPI(this._firestore);

  Future<String?> createVPN({
    required String uid,
    required String username,
    required String email,
    required String? serverLocation,
    required String? duration,
    required int? price,
  }) async {
    String? status;
    try {
      Map<String, dynamic> data = {
        'Email': email,
        'Agent': 'User',
        'Username': username,
        'serverLocation': serverLocation,
        'Duration': duration,
        'Status': 'Pending',
        'isPay': false,
        'Remarks': '',
        'isPending': true,
        'Harga': price,
        'timeStamp': FieldValue.serverTimestamp(),
      };
      //add to agent collection
      await _firestore
          .collection('Agent')
          .doc(uid)
          .collection('Order')
          .add(data);
      //add to admin collection
      await _firestore
          .collection('Order')
          .add(data)
          .then((value) => status = 'completed');
    } on FirebaseException catch (e) {
      status = e.toString();
    }
    return status;
  }
}
