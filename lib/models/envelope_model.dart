class EnvelopeModel {
  final String id;
  final String name;
  final double budgetAmount;
  final double remainingAmount;

  EnvelopeModel({
    required this.id,
    required this.name,
    required this.budgetAmount,
    required this.remainingAmount,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'budgetAmount': budgetAmount,
    'remainingAmount': remainingAmount,
  };

  factory EnvelopeModel.fromMap(Map<String, dynamic> map) => EnvelopeModel(
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    budgetAmount: (map['budgetAmount'] ?? 0).toDouble(),
    remainingAmount: (map['remainingAmount'] ?? 0).toDouble(),
  );
}
