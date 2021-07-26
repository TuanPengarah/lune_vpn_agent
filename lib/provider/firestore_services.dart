import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FirebaseFirestoreAPI extends ChangeNotifier {
  final FirebaseFirestore _firestore;

  FirebaseFirestoreAPI(this._firestore);

  Future<String?> createVPN({
    required String uid,
    required String username,
    required String? email,
    required String? serverLocation,
    required String? duration,
    required int? price,
    required bool isReport,
  }) async {
    String? status;
    _tarikh() {
      var now = new DateTime.now();
      var formatter = new DateFormat('dd/MM/yyyy');
      return formatter.format(now);
    }

    try {
      Map<String, dynamic> data = {
        'Email': email,
        'Agent': 'User',
        'Username': username,
        'serverLocation': serverLocation,
        'Duration': duration,
        'Status': 'Pending',
        'VPN end': _tarikh().toString(),
        'isPay': false,
        'Remarks': '',
        'isPending': true,
        'Harga': price,
        'timeStamp': FieldValue.serverTimestamp(),
      };
      //add to agent collection
      if (isReport == false) {
        await _firestore
            .collection('Agent')
            .doc(uid)
            .collection('Order')
            .add(data);
      }
      //add to admin collection
      isReport == false
          ? await _firestore
              .collection('Order')
              .add(data)
              .then((value) => status = 'completed')
          : await _firestore
              .collection('userReport')
              .add(data)
              .then((value) => status = 'completed');
    } on FirebaseException catch (e) {
      status = e.toString();
    }
    return status;
  }

  Future<String?> deletingVPN(String userUID, String vpnIUD) async {
    String? status;
    await _firestore
        .collection('Agent')
        .doc(userUID)
        .collection('Order')
        .doc(vpnIUD)
        .delete()
        .then((value) => status = 'operation-completed');
    return status;
  }

  Future<String?> renewVPN(String userUID, String vpnUID) async {
    String? status;
    Map<String, dynamic> data = {
      'Status': 'Pending',
      'isPay': false,
      'Remarks': '',
      'isPending': true,
      'timeStamp': FieldValue.serverTimestamp(),
    };
    await _firestore
        .collection('Agent')
        .doc(userUID)
        .collection('Order')
        .doc(vpnUID)
        .update(data)
        .then((value) => status = 'operation-completed');
    return status;
  }
}
