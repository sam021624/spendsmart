class BillModel {
  final String id;
  final String envelopeId; // New field to bind to the envelope
  final String name;
  final double amount;
  final double paidAmount;
  final DateTime dueDate;
  final bool isPaid;

  BillModel({
    required this.id,
    required this.envelopeId,
    required this.name,
    required this.amount,
    this.paidAmount = 0.0,
    required this.dueDate,
    this.isPaid = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'envelopeId': envelopeId,
      'name': name,
      'amount': amount,
      'paidAmount': paidAmount,
      'dueDate': dueDate.toIso8601String(),
      'isPaid': isPaid,
    };
  }

  // 2. Modified fromMap: Accept String docId as an extra parameter
  factory BillModel.fromMap(Map<String, dynamic> map, String docId) {
    return BillModel(
      id: docId, // Use the Firestore Document ID
      envelopeId: map['envelopeId'] ?? '',
      name: map['name'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      paidAmount: (map['paidAmount'] ?? 0.0).toDouble(),
      dueDate: map['dueDate'] != null
          ? DateTime.parse(map['dueDate'])
          : DateTime.now(),
      isPaid: map['isPaid'] ?? false,
    );
  }
}
