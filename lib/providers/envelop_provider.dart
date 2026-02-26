import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/models/envelope_model.dart';
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
