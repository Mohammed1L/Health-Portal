import 'package:flutter/material.dart';

import '../widgets/inputs/app_text_field.dart';
import '../widgets/buttons/app_button.dart';
import '../widgets/app_bar/theme_toggle_button.dart';
import '../widgets/cards/app_card.dart';

import '../services/health_record_service.dart';
import '../models/health_record.dart';
import '../../core/constants/api_config.dart';

class HealthRecordScreen extends StatefulWidget {
  const HealthRecordScreen({super.key});

  @override
  State<HealthRecordScreen> createState() => _HealthRecordScreenState();
}

class _HealthRecordScreenState extends State<HealthRecordScreen> {
  final _formKey = GlobalKey<FormState>();

  // service
  final HealthRecordService _healthRecordService =
  HealthRecordService(baseUrl: ApiConfig.baseUrl); // Emulator

  HealthRecord? _record;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  // Controllers
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bloodPressureController =
  TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _bloodSugarController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHealthRecord();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _bloodPressureController.dispose();
    _heartRateController.dispose();
    _bloodSugarController.dispose();
    _bmiController.dispose();
    super.dispose();
  }

  Future<void> _loadHealthRecord() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final record = await _healthRecordService.fetchHealthRecord('1');

      if (!mounted) return;

      _record = record;

      _heightController.text = record.heightCm.toString();
      _weightController.text = record.weightKg.toString();
      _bloodPressureController.text = record.bloodPressure;
      _heartRateController.text = record.heartRate.toString();
      _bloodSugarController.text = record.bloodSugar.toString();
      _bmiController.text = record.bmi.toStringAsFixed(1);

      setState(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'حدث خطأ أثناء جلب السجل الصحي، حاول مرة أخرى.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  double _calculateBmi(double heightCm, double weightKg) {
    if (heightCm <= 0) return 0;
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  Future<void> _saveHealthRecord() async {
    if (_record == null) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final height = double.tryParse(_heightController.text) ?? 0;
      final weight = double.tryParse(_weightController.text) ?? 0;
      final bloodPressure = _bloodPressureController.text.trim();
      final heartRate = int.tryParse(_heartRateController.text) ?? 0;
      final bloodSugar = double.tryParse(_bloodSugarController.text) ?? 0;

      final bmi = _calculateBmi(height, weight);
      _bmiController.text = bmi.toStringAsFixed(1);

      final updated = _record!.copyWith(
        heightCm: height,
        weightKg: weight,
        bloodPressure: bloodPressure,
        heartRate: heartRate,
        bloodSugar: bloodSugar,
        bmi: bmi,
        updatedAt: DateTime.now(),
      );

      final result =
      await _healthRecordService.updateHealthRecord(updated);

      if (!mounted) return;

      setState(() {
        _record = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ السجل الصحي بنجاح'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل حفظ السجل الصحي، حاول مرة أخرى'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'السجل الصحي',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const ThemeToggleButton(),
                  ],
                ),
              ),

              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _errorMessage!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.red[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            AppButton(
              text: 'إعادة المحاولة',
              type: AppButtonType.primary,
              size: AppButtonSize.medium,
              onPressed: _loadHealthRecord,
            ),
          ],
        ),
      );
    }

    if (_record == null) {
      return const Center(
        child: Text('لا يوجد سجل صحي متاح'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppCard(
              isOutlined: true,
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF424242)
                    : const Color(0xFFE0E0E0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('القياسات الأساسية'),
                  const SizedBox(height: 12),
                  _buildNumberField(
                    label: 'الطول (سم)',
                    controller: _heightController,
                  ),
                  const SizedBox(height: 12),
                  _buildNumberField(
                    label: 'الوزن (كجم)',
                    controller: _weightController,
                  ),
                  const SizedBox(height: 12),
                  _buildReadOnlyField(
                    label: 'مؤشر كتلة الجسم (BMI)',
                    controller: _bmiController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              isOutlined: true,
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF424242)
                    : const Color(0xFFE0E0E0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('المؤشرات الحيوية'),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _bloodPressureController,
                    hintText: 'مثال: 120/80',
                    labelText: 'ضغط الدم',
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء إدخال ضغط الدم';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildNumberField(
                    label: 'معدل نبضات القلب (نبضة/دقيقة)',
                    controller: _heartRateController,
                  ),
                  const SizedBox(height: 12),
                  _buildNumberField(
                    label: 'مستوى السكر في الدم',
                    controller: _bloodSugarController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: _isSaving ? 'جاري الحفظ...' : 'حفظ السجل الصحي',
              type: AppButtonType.primary,
              size: AppButtonSize.large,
              isFullWidth: true,
              backgroundColor: const Color(0xFF00A86B),
              textColor: Theme.of(context).colorScheme.surface,
              onPressed: _isSaving ? null : _saveHealthRecord,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
  }) {
    return AppTextField(
      controller: controller,
      hintText: label,
      labelText: label,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'الرجاء إدخال $label';
        }
        if (double.tryParse(value) == null) {
          return 'الرجاء إدخال رقم صحيح';
        }
        return null;
      },
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required TextEditingController controller,
  }) {
    return AppTextField(
      controller: controller,
      hintText: label,
      labelText: label,
      enabled: false,
    );
  }
}
