import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/envelope_model.dart';

// --- AUTH PROVIDERS ---
// This solves your "Undefined name authStateProvider" error
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// --- ENVELOPE SERVICE ---
class EnvelopeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid;

  EnvelopeService(this.uid);

  // Stream of Envelopes for the current user
  Stream<List<EnvelopeModel>> getEnvelopes() {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('envelopes')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => EnvelopeModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Add a new Envelope to Firestore
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
      remainingAmount: amount, // Start with full budget
    );

    await docRef.set(newEnvelope.toMap());
  }
}

// --- RIVERPOD PROVIDERS ---

// Provider for the Service (Dependency Injection)
final envelopeServiceProvider = Provider<EnvelopeService?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;
  return EnvelopeService(user.uid);
});

// Provider for the UI to consume (The Data Stream)
final envelopesStreamProvider = StreamProvider<List<EnvelopeModel>>((ref) {
  final service = ref.watch(envelopeServiceProvider);
  if (service == null) return Stream.value([]);
  return service.getEnvelopes();
});
