import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/models/envelope_model.dart';
import '../services/envelope_service.dart';

// FIXED: Now we pass the UID into the service
final envelopeServiceProvider = Provider<EnvelopeService?>((ref) {
  // 1. Watch the auth state
  final authState = ref.watch(authStateProvider);

  // 2. Extract the user (using .value because it's an AsyncValue)
  final user = authState.value;

  // 3. If no user, return null; otherwise, pass the UID
  if (user == null) return null;
  return EnvelopeService(user.uid);
});

final envelopesStreamProvider = StreamProvider<List<EnvelopeModel>>((ref) {
  final service = ref.watch(envelopeServiceProvider);

  // If the service is null (user logged out), return an empty list
  if (service == null) return Stream.value([]);

  return service.getEnvelopes();
});
