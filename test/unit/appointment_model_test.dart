import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/models/appointment.dart';

void main() {
  group('Appointment Model', () {
    test('should create Appointment with all required fields', () {
      final appointment = Appointment(
        id: '1',
        clinic: 'Test Clinic',
        doctor: 'Dr. Test',
        location: 'Test Location',
        dateTime: DateTime(2024, 1, 15, 10, 0),
        isUpcoming: true,
      );

      expect(appointment.id, '1');
      expect(appointment.clinic, 'Test Clinic');
      expect(appointment.doctor, 'Dr. Test');
      expect(appointment.location, 'Test Location');
      expect(appointment.dateTime, DateTime(2024, 1, 15, 10, 0));
      expect(appointment.isUpcoming, true);
    });

    test('fromJson should create Appointment from JSON', () {
      final json = {
        'id': '1',
        'clinic': 'Test Clinic',
        'doctor': 'Dr. Test',
        'location': 'Test Location',
        'dateTime': '2024-01-15T10:00:00.000Z',
        'isUpcoming': true,
      };

      final appointment = Appointment.fromJson(json);

      expect(appointment.id, '1');
      expect(appointment.clinic, 'Test Clinic');
      expect(appointment.doctor, 'Dr. Test');
      expect(appointment.location, 'Test Location');
      expect(appointment.isUpcoming, true);
    });

    test('fromJson should handle missing fields with defaults', () {
      final json = {
        'id': '1',
        'dateTime': '2024-01-15T10:00:00.000Z',
      };

      final appointment = Appointment.fromJson(json);

      expect(appointment.id, '1');
      expect(appointment.clinic, '');
      expect(appointment.doctor, '');
      expect(appointment.location, '');
      expect(appointment.isUpcoming, true);
    });

    test('toJson should convert Appointment to JSON', () {
      final appointment = Appointment(
        id: '1',
        clinic: 'Test Clinic',
        doctor: 'Dr. Test',
        location: 'Test Location',
        dateTime: DateTime(2024, 1, 15, 10, 0),
        isUpcoming: true,
      );

      final json = appointment.toJson();

      expect(json['id'], '1');
      expect(json['clinic'], 'Test Clinic');
      expect(json['doctor'], 'Dr. Test');
      expect(json['location'], 'Test Location');
      expect(json['isUpcoming'], true);
      expect(json['dateTime'], isA<String>());
    });

    test('toJson and fromJson should be reversible', () {
      final original = Appointment(
        id: '1',
        clinic: 'Test Clinic',
        doctor: 'Dr. Test',
        location: 'Test Location',
        dateTime: DateTime(2024, 1, 15, 10, 0),
        isUpcoming: true,
      );

      final json = original.toJson();
      final restored = Appointment.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.clinic, original.clinic);
      expect(restored.doctor, original.doctor);
      expect(restored.location, original.location);
      expect(restored.isUpcoming, original.isUpcoming);
    });
  });
}

