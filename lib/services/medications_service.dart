// lib/services/medications_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants/api_config.dart';
import '../models/medication.dart';

class MedicationsService {
  final String baseUrl;

  MedicationsService({String? baseUrl})
      : baseUrl = baseUrl ?? ApiConfig.baseUrl;

  Future<List<Medication>> fetchMedications() async {
    final uri = Uri.parse('$baseUrl/medications');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('فشل في جلب الأدوية (كود: ${response.statusCode})');
    }

    final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

    return jsonList
        .map((json) => Medication.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Medication> createMedication({
    required String name,
    required String brand,
    required String dosage,
    required String timeOfDay,
    required bool reminderEnabled,
  }) async {
    final uri = Uri.parse('$baseUrl/medications');

    final body = {
      'name': name,
      'brand': brand,
      'dosage': dosage,
      'timeOfDay': timeOfDay,
      'reminderEnabled': reminderEnabled,
    };

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('فشل في إنشاء الدواء (كود: ${response.statusCode})');
    }

    final Map<String, dynamic> json =
    jsonDecode(response.body) as Map<String, dynamic>;

    return Medication.fromJson(json);
  }

  Future<Medication> updateMedication(Medication medication) async {
    final uri = Uri.parse('$baseUrl/medications/${medication.id}');

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode(medication.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('فشل في تحديث الدواء (كود: ${response.statusCode})');
    }

    final Map<String, dynamic> json =
    jsonDecode(response.body) as Map<String, dynamic>;

    return Medication.fromJson(json);
  }
}
