import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/envelope_model.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class EnvelopeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid;

  EnvelopeService(this.uid);

  Stream<List<EnvelopeModel>> getEnvelopes() {
    debugPrint("DEBUG: Fetching envelopes for UID: $uid");

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('envelopes')
        .snapshots()
        .map((snapshot) {
          debugPrint(
            "DEBUG: Documents found in Firestore: ${snapshot.docs.length}",
          );

          return snapshot.docs.map((doc) {
            debugPrint("DEBUG: Doc Data: ${doc.data()}");
            return EnvelopeModel.fromMap(doc.data());
          }).toList();
        });
  }

  Future<void> addEnvelope(String name, double amount) async {
    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('envelopes')
        .doc();

    final newEnvelope = EnvelopeModel(
      id: docRef.id,
      name: name,
      budgetAmount: amount,
      remainingAmount: amount,
    );

    await docRef.set(newEnvelope.toMap());
  }
}

final envelopeServiceProvider = Provider<EnvelopeService?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;
  return EnvelopeService(user.uid);
});

final envelopesStreamProvider = StreamProvider<List<EnvelopeModel>>((ref) {
  final service = ref.watch(envelopeServiceProvider);
  if (service == null) return Stream.value([]);
  return service.getEnvelopes();
});
