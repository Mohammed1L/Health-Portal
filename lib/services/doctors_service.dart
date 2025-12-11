// lib/services/doctors_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class DoctorsService {
  final String baseUrl;

  DoctorsService({required this.baseUrl});

  /// جلب الأطباء مع إمكانية التصفية بالعيادة والمنشأة
  Future<List<Map<String, dynamic>>> fetchDoctors({
    String? clinicId,
    String? facilityId,
  }) async {
    final queryParams = <String, String>{};

    if (clinicId != null && clinicId.isNotEmpty) {
      queryParams['clinicId'] = clinicId;
    }
    if (facilityId != null && facilityId.isNotEmpty) {
      queryParams['facilityId'] = facilityId;
    }

    final uri = Uri.parse('$baseUrl/doctors')
        .replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('فشل في جلب الأطباء (كود: ${response.statusCode})');
    }

    final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

    return jsonList
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }
}
