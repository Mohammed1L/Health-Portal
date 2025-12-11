// lib/models/health_record.dart

class HealthRecord {
  final String id;
  final double heightCm;
  final double weightKg;
  final String bloodPressure;
  final int heartRate;
  final double bloodSugar;
  final double bmi;
  final DateTime updatedAt;

  HealthRecord({
    required this.id,
    required this.heightCm,
    required this.weightKg,
    required this.bloodPressure,
    required this.heartRate,
    required this.bloodSugar,
    required this.bmi,
    required this.updatedAt,
  });

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      id: json['id']?.toString() ?? '',
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 0,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0,
      bloodPressure: json['bloodPressure'] as String? ?? '',
      heartRate: (json['heartRate'] as num?)?.toInt() ?? 0,
      bloodSugar: (json['bloodSugar'] as num?)?.toDouble() ?? 0,
      bmi: (json['bmi'] as num?)?.toDouble() ?? 0,
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'bloodPressure': bloodPressure,
      'heartRate': heartRate,
      'bloodSugar': bloodSugar,
      'bmi': bmi,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  HealthRecord copyWith({
    double? heightCm,
    double? weightKg,
    String? bloodPressure,
    int? heartRate,
    double? bloodSugar,
    double? bmi,
    DateTime? updatedAt,
  }) {
    return HealthRecord(
      id: id,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      bloodPressure: bloodPressure ?? this.bloodPressure,
      heartRate: heartRate ?? this.heartRate,
      bloodSugar: bloodSugar ?? this.bloodSugar,
      bmi: bmi ?? this.bmi,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
