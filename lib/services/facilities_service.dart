// lib/services/facilities_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class FacilitiesService {
  final String baseUrl;

  FacilitiesService({required this.baseUrl});

  /// جلب المنشآت، مع خيار التصفية حسب العيادة
  Future<List<Map<String, dynamic>>> fetchFacilities({
    String? clinicId,
  }) async {
    // نحضّر الـ query parameters
    final queryParams = <String, String>{};
    if (clinicId != null && clinicId.isNotEmpty) {
      queryParams['clinicId'] = clinicId;
    }

    // نبني الـ URI مع الباراميترات
    final uri = Uri.parse('$baseUrl/facilities')
        .replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('فشل في جلب المنشآت (كود: ${response.statusCode})');
    }

    final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

    // نرجّع List<Map<String, dynamic>>
    return jsonList
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }
}
