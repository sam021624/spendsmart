import 'package:cloud_firestore/cloud_firestore.dart';

class GoalModel {
  final String id;
  final String title;
  final double currentAmount;
  final double targetAmount;
  final String deadline;
  final int iconCode;
  final int colorValue;

  GoalModel({
    required this.id,
    required this.title,
    required this.currentAmount,
    required this.targetAmount,
    required this.deadline,
    required this.iconCode,
    required this.colorValue,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'currentAmount': currentAmount,
    'targetAmount': targetAmount,
    'deadline': deadline,
    'iconCode': iconCode,
    'colorValue': colorValue,
    'createdAt': FieldValue.serverTimestamp(),
  };

  factory GoalModel.fromMap(Map<String, dynamic> map) => GoalModel(
    id: map['id'] ?? '',
    title: map['title'] ?? '',
    currentAmount: (map['currentAmount'] ?? 0).toDouble(),
    targetAmount: (map['targetAmount'] ?? 0).toDouble(),
    deadline: map['deadline'] ?? '',
    iconCode: map['iconCode'] ?? 0xe0b0,
    colorValue: map['colorValue'] ?? 0xFF008080,
  );
}
