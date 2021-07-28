import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FirebaseFirestoreAPI extends ChangeNotifier {
  final FirebaseFirestore _firestore;

  FirebaseFirestoreAPI(this._firestore);

  Future<String?> createVPN({
    required String? customer,
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

    String _uid = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      Map<String, dynamic> data = {
        'Email': email,
        'Agent': customer,
        'Username': username,
        'serverLocation': serverLocation,
        'Duration': duration,
        'Status': 'Pending',
        'VPN end': _tarikh().toString(),
        'isPay': false,
        'vpnUID': _uid,
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
            .doc(_uid)
            .set(data);
      }
      //add to admin collection
      isReport == false
          ? await _firestore
              .collection('Order')
              .doc(_uid)
              .set(data)
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
    await _firestore.collection('Order').doc(vpnIUD).delete();
    await _firestore
        .collection('Agent')
        .doc(userUID)
        .collection('Order')
        .doc(vpnIUD)
        .delete()
        .then((value) => status = 'operation-completed');
    return status;
  }

  Future<String?> renewVPN({
    required String? userUID,
    required String? vpnUID,
    required String? customer,
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

    Map<String, dynamic> data = {
      'Email': email,
      'Agent': customer,
      'Username': username,
      'serverLocation': serverLocation,
      'Duration': duration,
      'Status': 'Pending',
      'VPN end': _tarikh().toString(),
      'isPay': false,
      'vpnUID': vpnUID,
      'Remarks': '',
      'isPending': true,
      'Harga': price,
      'timeStamp': FieldValue.serverTimestamp(),
    };
    await _firestore.collection('Order').doc(vpnUID).set(data);

    Map<String, dynamic> updateData = {
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
        .update(updateData)
        .then((value) => status = 'operation-completed');
    return status;
  }

  Future<void> saveTokenToDatabase(String? token) async {
    // Assume user is logged in for this example
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('Agent').doc(userId).update({
      'tokens': FieldValue.arrayUnion([token]),
    });
  }
}
