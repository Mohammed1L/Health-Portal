// lib/services/appointments_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/appointment.dart';

class AppointmentsService {

  final String baseUrl;

  AppointmentsService({required this.baseUrl});


  Future<List<Appointment>> fetchAppointments({
    required bool upcoming,
  }) async {

    // GET /appointments?status=upcoming or previous
    final uri = Uri.parse(
      '$baseUrl/appointments?status=${upcoming ? 'upcoming' : 'previous'}',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('فشل في جلب المواعيد (كود: ${response.statusCode})');
    }

    final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
    return jsonList
        .map((json) => Appointment.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Appointment> createAppointment({
    required Map<String, dynamic> bookingData,
  }) async {
    final uri = Uri.parse('$baseUrl/appointments');


    final clinicMap = bookingData['clinic'] as Map?;
    final facilityMap = bookingData['facility'] as Map?;
    final doctorMap = bookingData['doctor'] as Map?;
    final dateValue = bookingData['date'];
    final timeValue = bookingData['time'];

    final String clinicName = clinicMap?['name'] ?? '';
    final String facilityName = facilityMap?['name'] ?? '';
    final String doctorName = doctorMap?['name'] ?? '';

    final String dateTimeIso = _buildDateTimeIsoString(
      dateValue,
      timeValue,
    );

    if (dateValue is DateTime && doctorName.isNotEmpty) {
      final String dateStr =
          '${dateValue.year.toString().padLeft(4, '0')}-'
          '${dateValue.month.toString().padLeft(2, '0')}-'
          '${dateValue.day.toString().padLeft(2, '0')}';

      final checkUri = Uri.parse(
        '$baseUrl/appointments'
            '?doctor=$doctorName'
            '&dateTime_like=$dateStr',
      );

      final checkResponse = await http.get(checkUri);

      if (checkResponse.statusCode == 200) {
        final List<dynamic> existingAppointments =
        jsonDecode(checkResponse.body) as List<dynamic>;

        final bool alreadyBooked = existingAppointments.any((appt) {
          if (appt is Map<String, dynamic>) {
            return appt['dateTime'] == dateTimeIso;
          }
          return false;
        });

        if (alreadyBooked) {
          throw Exception('هذا الموعد محجوز مسبقًا، اختر وقتًا آخر.');
        }
      }
    }

    // ================== إنشاء الموعد الجديد ==================
    final body = {
      'clinic': clinicName,
      'doctor': doctorName,
      'location': facilityName,
      'dateTime': dateTimeIso,
      'status': 'upcoming',
      'isUpcoming': true,
    };

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('فشل في إنشاء الموعد (كود: ${response.statusCode})');
    }

    final Map<String, dynamic> json =
    jsonDecode(response.body) as Map<String, dynamic>;
    return Appointment.fromJson(json);
  }

  String _buildDateTimeIsoString(dynamic dateValue, dynamic timeValue) {
    if (dateValue is DateTime && timeValue is String) {
      final cleanTime = timeValue.split(' ')[0];
      final parts = cleanTime.split(':');
      final hour = int.tryParse(parts[0]) ?? 9;
      final minute = int.tryParse(
        parts.length > 1
            ? parts[1].replaceAll(RegExp(r'[^0-9]'), '')
            : '',
      ) ??
          0;

      final dt = DateTime(
        dateValue.year,
        dateValue.month,
        dateValue.day,
        hour,
        minute,
      );
      return dt.toIso8601String();
    }

    // fallback:
    return DateTime.now().toIso8601String();
  }
  Future<Appointment?> fetchNearestUpcomingAppointment() async {
    final allUpcoming = await fetchAppointments(upcoming: true);

    final now = DateTime.now();

    final upcoming = allUpcoming
        .where((appt) => appt.dateTime.isAfter(now))
        .toList();

    if (upcoming.isEmpty) {
      return null;
    }

    upcoming.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return upcoming.first;
  }


}
