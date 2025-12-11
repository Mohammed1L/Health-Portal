// lib/models/medication.dart

class Medication {
  final String id;
  final String name;          // اسم الدواء
  final String brand;         // الشركة / الماركة
  final String dosage;        // الجرعة (مثلاً: قرص مرتين يوميًا)
  final String timeOfDay;     // وقت الجرعة كنص (مثلاً: "09:00 ص")
  final bool reminderEnabled; // هل التذكير مفعّل

  Medication({
    required this.id,
    required this.name,
    required this.brand,
    required this.dosage,
    required this.timeOfDay,
    required this.reminderEnabled,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      dosage: json['dosage'] as String? ?? '',
      timeOfDay: json['timeOfDay'] as String? ?? '',
      reminderEnabled: json['reminderEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'dosage': dosage,
      'timeOfDay': timeOfDay,
      'reminderEnabled': reminderEnabled,
    };
  }

  Medication copyWith({
    String? id,
    String? name,
    String? brand,
    String? dosage,
    String? timeOfDay,
    bool? reminderEnabled,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      dosage: dosage ?? this.dosage,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    );
  }
}
