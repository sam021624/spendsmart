import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/models/envelope_model.dart';
import 'package:spendsmart/models/transaction_model.dart';
import '../services/envelope_service.dart';

final envelopeServiceProvider = Provider<EnvelopeService?>((ref) {
  final authState = ref.watch(authStateProvider);

  final user = authState.value;

  if (user == null) return null;
  return EnvelopeService(user.uid);
});

final envelopesStreamProvider = StreamProvider<List<EnvelopeModel>>((ref) {
  final service = ref.watch(envelopeServiceProvider);

  if (service == null) return Stream.value([]);

  return service.getEnvelopes();
});

final transactionsStreamProvider =
    StreamProvider.family<List<TransactionModel>, String>((ref, envelopeId) {
      final service = ref.watch(envelopeServiceProvider);
      if (service == null) return Stream.value([]);

      return FirebaseFirestore.instance
          .collection('users')
          .doc(service.uid)
          .collection('transactions')
          .where('envelopeId', isEqualTo: envelopeId)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => TransactionModel.fromMap(doc.data()))
                .toList(),
          );
    });

final allTransactionsStreamProvider = StreamProvider<List<TransactionModel>>((
  ref,
) {
  final service = ref.watch(envelopeServiceProvider);
  if (service == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(service.uid)
      .collection('transactions')
      .orderBy('timestamp', descending: true)
      .limit(20)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromMap(doc.data()))
            .toList(),
      );
});
