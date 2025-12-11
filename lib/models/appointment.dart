// lib/models/appointment.dart

class Appointment {
  final String id;
  final String clinic;
  final String doctor;
  final String location;
  final DateTime dateTime;
  final bool isUpcoming;

  Appointment({
    required this.id,
    required this.clinic,
    required this.doctor,
    required this.location,
    required this.dateTime,
    required this.isUpcoming,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id']?.toString() ?? '',
      clinic: json['clinic'] as String? ?? '',
      doctor: json['doctor'] as String? ?? '',
      location: json['location'] as String? ?? '',
      dateTime: DateTime.parse(json['dateTime'] as String),
      isUpcoming: json['isUpcoming'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clinic': clinic,
      'doctor': doctor,
      'location': location,
      'dateTime': dateTime.toIso8601String(),
      'isUpcoming': isUpcoming,
    };
  }
}
