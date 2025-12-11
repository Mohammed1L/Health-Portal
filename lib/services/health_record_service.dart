// lib/services/health_record_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/health_record.dart';

class HealthRecordService {
  final String baseUrl;

  HealthRecordService({required this.baseUrl});

  Future<HealthRecord> fetchHealthRecord(String userId) async {

    final uri = Uri.parse('$baseUrl/health-records/$userId');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'فشل في جلب السجل الصحي (كود: ${response.statusCode})',
      );
    }

    final Map<String, dynamic> json =
    jsonDecode(response.body) as Map<String, dynamic>;

    return HealthRecord.fromJson(json);
  }

  Future<HealthRecord> updateHealthRecord(HealthRecord record) async {
    // PUT /health-records/:id
    final uri = Uri.parse('$baseUrl/health-records/${record.id}');

    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode(record.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'فشل في تحديث السجل الصحي (كود: ${response.statusCode})',
      );
    }

    final Map<String, dynamic> json =
    jsonDecode(response.body) as Map<String, dynamic>;

    return HealthRecord.fromJson(json);
  }
}
