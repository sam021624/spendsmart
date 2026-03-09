// Ensure this is in your providers file
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/models/bill_model.dart';
import 'package:spendsmart/services/bill_service.dart';

final billServiceProvider = Provider<BillService?>((ref) {
  final authState = ref.watch(authStateProvider);
  // Return the service only if we have a valid UID
  return authState.maybeWhen(
    data: (user) => user != null ? BillService(user.uid) : null,
    orElse: () => null,
  );
});

// Add .family here
final billsStreamProvider = StreamProvider.family<List<BillModel>, String>((
  ref,
  envelopeId,
) {
  final service = ref.watch(billServiceProvider);
  if (service == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(service.uid)
      .collection('bills')
      .where('envelopeId', isEqualTo: envelopeId)
      .orderBy('dueDate')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => BillModel.fromMap(doc.data(), doc.id))
            .toList(),
      );
});

final allBillsStreamProvider = StreamProvider<List<BillModel>>((ref) {
  final service = ref.watch(billServiceProvider);
  if (service == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(service.uid)
      .collection('bills')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => BillModel.fromMap(doc.data(), doc.id))
            .toList(),
      );
});
