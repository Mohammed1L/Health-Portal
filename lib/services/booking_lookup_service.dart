// lib/services/booking_lookup_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingLookupService {
  final String baseUrl;

  BookingLookupService({required this.baseUrl});

  Future<List<Map<String, dynamic>>> fetchClinics() async {
    final uri = Uri.parse('$baseUrl/clinics');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('فشل في جلب العيادات (كود: ${response.statusCode})');
    }

    final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
    return jsonList.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchFacilities({
    required String clinicId,
  }) async {
    final uri = Uri.parse('$baseUrl/facilities?clinicId=$clinicId');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('فشل في جلب المنشآت (كود: ${response.statusCode})');
    }

    final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
    return jsonList.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchDoctors({
    required String clinicId,
    required String facilityId,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/doctors?clinicId=$clinicId&facilityId=$facilityId',
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('فشل في جلب الأطباء (كود: ${response.statusCode})');
    }

    final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
    return jsonList.cast<Map<String, dynamic>>();
  }
}
