class Saving {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final String currencyCode;
  final String frequency;
  final DateTime createdAt;

  Saving({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.currencyCode,
    required this.frequency,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'currencyCode': currencyCode,
      'frequency': frequency,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Saving.fromMap(Map<String, dynamic> map) {
    return Saving(
      id: map['id'],
      name: map['name'],
      targetAmount: map['targetAmount'],
      currentAmount: map['currentAmount'],
      currencyCode: map['currencyCode'],
      frequency: map['frequency'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Saving copyWith({
    double? currentAmount,
    String? name,
    double? targetAmount,
    String? currencyCode,
    String? frequency,
  }) {
    return Saving(
      id: id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      currencyCode: currencyCode ?? this.currencyCode,
      frequency: frequency ?? this.frequency,
      createdAt: createdAt,
    );
  }
}
