// lib/services/appointments_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/appointment.dart';

class AppointmentsService {
  /// عدّل الـ baseUrl حسب السيرفر عندكم
  /// مثال لو عندك json-server شغّال محلي على 3000:
  ///  http://10.0.2.2:3000  (للـ Emulator)
  final String baseUrl;

  AppointmentsService({required this.baseUrl});

  /// جلب المواعيد (قادمة أو سابقة)
  Future<List<Appointment>> fetchAppointments({
    required bool upcoming,
  }) async {
    // هنا نفترض أن السيرفر عنده endpoint مثل:
    // GET /appointments?status=upcoming أو previous
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

  /// إنشاء موعد جديد من بيانات الـ bookingData القادمة من الـ BookingFlow
  Future<Appointment> createAppointment({
    required Map<String, dynamic> bookingData,
  }) async {
    final uri = Uri.parse('$baseUrl/appointments');

    // bookingData فيها:
    // 'clinic'   → Map فيه name, id
    // 'facility' → Map فيه name, id
    // 'doctor'   → Map فيه name, id
    // 'date'     → DateTime
    // 'time'     → String

    final clinicMap = bookingData['clinic'] as Map?;
    final facilityMap = bookingData['facility'] as Map?;
    final doctorMap = bookingData['doctor'] as Map?;
    final dateValue = bookingData['date'];
    final timeValue = bookingData['time'];

    final String clinicName = clinicMap?['name'] ?? '';
    final String facilityName = facilityMap?['name'] ?? '';
    final String doctorName = doctorMap?['name'] ?? '';

    // نبني قيمة التاريخ+الوقت النهائية بصيغة ISO
    final String dateTimeIso = _buildDateTimeIsoString(
      dateValue,
      timeValue,
    );

    // ====== التحقق من التكرار (نفس الطبيب + نفس التاريخ + نفس الوقت) ======
    if (dateValue is DateTime && doctorName.isNotEmpty) {
      // تاريخ بصيغة YYYY-MM-DD لاستخدامه في dateTime_like
      final String dateStr =
          '${dateValue.year.toString().padLeft(4, '0')}-'
          '${dateValue.month.toString().padLeft(2, '0')}-'
          '${dateValue.day.toString().padLeft(2, '0')}';

      // نبحث عن كل المواعيد لنفس الدكتور وفي نفس اليوم
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
          // نرمي Exception عشان تقدر تعرض رسالة للمستخدم في الـ UI
          throw Exception('هذا الموعد محجوز مسبقًا، اختر وقتًا آخر.');
        }
      }
      // لو الـ status مو 200 نخلي النظام يكمل ونحاول إنشاء الموعد عادي
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
      // نفترض أن timeValue بصيغة تقريبية مثل "10:30" أو "09:10 ص"
      final cleanTime = timeValue.split(' ')[0]; // ناخذ "09:10" من "09:10 ص"
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

    // fallback: الآن
    return DateTime.now().toIso8601String();
  }
}
