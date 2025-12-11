import 'package:flutter/material.dart';

import '../services/medications_service.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _dosageController = TextEditingController();

  TimeOfDay? _selectedTime;
  bool _reminderEnabled = true;

  final MedicationsService _medicationsService = MedicationsService();

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'ص' : 'م';
    return '$hour:$minute $period';
  }

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار وقت الجرعة')),
      );
      return;
    }

    final timeStr = _formatTime(_selectedTime!);

    try {
      await _medicationsService.createMedication(
        name: _nameController.text.trim(),
        brand: _brandController.text.trim(),
        dosage: _dosageController.text.trim(),
        timeOfDay: timeStr,
        reminderEnabled: _reminderEnabled,
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في إضافة الدواء')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إضافة دواء جديد'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الدواء',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال اسم الدواء';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(
                    labelText: 'الشركة / الماركة',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dosageController,
                  decoration: const InputDecoration(
                    labelText: 'الجرعة (مثال: قرص مرتين يوميًا)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال الجرعة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('وقت الجرعة'),
                  subtitle: Text(
                    _selectedTime == null
                        ? 'لم يتم اختيار وقت بعد'
                        : _formatTime(_selectedTime!),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: _pickTime,
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: const Text('تفعيل التذكير لهذا الدواء'),
                  value: _reminderEnabled,
                  onChanged: (value) {
                    setState(() {
                      _reminderEnabled = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _save,
                    child: const Text('حفظ الدواء'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
