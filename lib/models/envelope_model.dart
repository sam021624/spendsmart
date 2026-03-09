class EnvelopeModel {
  final String id;
  final String name;
  final double budgetAmount;
  final double remainingAmount;
  final String type; // 'spending' or 'bill'
  final DateTime? dueDate;
  final bool isPaid;

  EnvelopeModel({
    required this.id,
    required this.name,
    required this.budgetAmount,
    required this.remainingAmount,
    this.type = 'spending',
    this.dueDate,
    this.isPaid = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'budgetAmount': budgetAmount,
    'remainingAmount': remainingAmount,
    'type': type,
    'dueDate': dueDate?.toIso8601String(),
    'isPaid': isPaid,
  };

  factory EnvelopeModel.fromMap(Map<String, dynamic> map) => EnvelopeModel(
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    budgetAmount: (map['budgetAmount'] ?? 0).toDouble(),
    remainingAmount: (map['remainingAmount'] ?? 0).toDouble(),
    type: map['type'] ?? 'spending',
    isPaid: map['isPaid'] ?? false,
    dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
  );
}
