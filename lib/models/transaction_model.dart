import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String productName;
  final double amount;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.productName,
    required this.amount,
    required this.date,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      productName: map['productName'] ?? 'Unknown',
      amount: (map['amount'] ?? 0.0).toDouble(),
      date: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
