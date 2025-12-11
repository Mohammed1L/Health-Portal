import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/models/health_record.dart';

void main() {
  group('HealthRecord Model Tests', () {
    test('should create HealthRecord with all fields', () {
      final now = DateTime.now();
      final record = HealthRecord(
        id: '1',
        heightCm: 175.0,
        weightKg: 70.0,
        bloodPressure: '120/80',
        heartRate: 72,
        bloodSugar: 90.0,
        bmi: 22.9,
        updatedAt: now,
      );

      expect(record.id, '1');
      expect(record.heightCm, 175.0);
      expect(record.weightKg, 70.0);
      expect(record.bloodPressure, '120/80');
      expect(record.heartRate, 72);
      expect(record.bloodSugar, 90.0);
      expect(record.bmi, 22.9);
      expect(record.updatedAt, now);
    });

    test('fromJson should create HealthRecord from JSON', () {
      final json = {
        'id': '1',
        'heightCm': 175.0,
        'weightKg': 70.0,
        'bloodPressure': '120/80',
        'heartRate': 72,
        'bloodSugar': 90.0,
        'bmi': 22.9,
        'updatedAt': '2024-01-15T10:00:00.000Z',
      };

      final record = HealthRecord.fromJson(json);

      expect(record.id, '1');
      expect(record.heightCm, 175.0);
      expect(record.weightKg, 70.0);
      expect(record.bloodPressure, '120/80');
      expect(record.heartRate, 72);
      expect(record.bloodSugar, 90.0);
      expect(record.bmi, 22.9);
    });

    test('toJson should convert HealthRecord to JSON', () {
      final now = DateTime.now();
      final record = HealthRecord(
        id: '1',
        heightCm: 175.0,
        weightKg: 70.0,
        bloodPressure: '120/80',
        heartRate: 72,
        bloodSugar: 90.0,
        bmi: 22.9,
        updatedAt: now,
      );

      final json = record.toJson();

      expect(json['id'], '1');
      expect(json['heightCm'], 175.0);
      expect(json['weightKg'], 70.0);
      expect(json['bloodPressure'], '120/80');
      expect(json['heartRate'], 72);
      expect(json['bloodSugar'], 90.0);
      expect(json['bmi'], 22.9);
      expect(json['updatedAt'], isA<String>());
    });

    test('copyWith should create a new instance with updated fields', () {
      final original = HealthRecord(
        id: '1',
        heightCm: 175.0,
        weightKg: 70.0,
        bloodPressure: '120/80',
        heartRate: 72,
        bloodSugar: 90.0,
        bmi: 22.9,
        updatedAt: DateTime.now(),
      );

      final updated = original.copyWith(
        weightKg: 75.0,
        bmi: 24.5,
      );

      expect(updated.id, original.id);
      expect(updated.heightCm, original.heightCm);
      expect(updated.weightKg, 75.0);
      expect(updated.bmi, 24.5);
      expect(updated.bloodPressure, original.bloodPressure);
    });
  });
}

