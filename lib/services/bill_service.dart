import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/models/bill_model.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class BillService {
  BillService(this.uid);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid;

  Future<void> addBill({
    required String name,
    required double amount,
    required DateTime dueDate,
    required String envelopeId,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('bills')
        .doc();

    await docRef.set({
      'id': docRef.id,
      'envelopeId': envelopeId,
      'name': name,
      'amount': amount,
      'paidAmount': 0.0,
      'dueDate': dueDate.toIso8601String(),
      'isPaid': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> payBill({required BillModel bill}) async {
    final billRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('bills')
        .doc(bill.id);
    final envRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('envelopes')
        .doc(bill.envelopeId);
    final txRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .doc();

    return _firestore.runTransaction((transaction) async {
      final envSnap = await transaction.get(envRef);
      if (!envSnap.exists) throw Exception("Source envelope not found!");

      double currentRemaining = (envSnap.data()?['remainingAmount'] ?? 0.0)
          .toDouble();

      transaction.update(billRef, {'isPaid': true});

      transaction.update(envRef, {
        'remainingAmount': currentRemaining - bill.amount,
      });

      transaction.set(txRef, {
        'id': txRef.id,
        'envelopeId': bill.envelopeId,
        'amount': bill.amount,
        'productName': "Paid Bill: ${bill.name}",
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'bill_payment',
      });
    });
  }
}
