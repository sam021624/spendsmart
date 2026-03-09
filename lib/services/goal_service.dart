import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/providers/auth_provider.dart';
import '../models/goal_model.dart';

class GoalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid;

  GoalService(this.uid);

  // Stream of Goals
  Stream<List<GoalModel>> getGoals() {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('goals')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => GoalModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Add a new Goal
  Future<void> addGoal(GoalModel goal) async {
    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('goals')
        .doc();
    await docRef.set(goal.toMap()..['id'] = docRef.id);
  }

  Future<void> createGoal({
    required String title,
    required double target,
    required String deadline,
    required int iconCode,
    required Color color,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('goals')
        .doc();

    final newGoal = GoalModel(
      id: docRef.id,
      title: title,
      targetAmount: target,
      currentAmount: 0.0,
      deadline: deadline,
      iconCode: iconCode,
      colorValue: color.value,
    );

    await docRef.set(newGoal.toMap());
  }
}

final goalServiceProvider = Provider<GoalService?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;
  return GoalService(user.uid);
});

final goalsStreamProvider = StreamProvider<List<GoalModel>>((ref) {
  final service = ref.watch(goalServiceProvider);
  return service != null ? service.getGoals() : Stream.value([]);
});
