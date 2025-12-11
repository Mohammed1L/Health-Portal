import 'package:flutter/material.dart';

import '../widgets/cards/app_card.dart';
import '../core/responsive.dart';
import '../models/medication.dart';
import '../services/medications_service.dart';
import 'add_medication_screen.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  bool _isLogTab = false; // false = Schedule, true = Log
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();

  // Arabic day names
  final List<String> _dayNames = [
    'أحد',
    'اثنين',
    'ثلاثاء',
    'أربعاء',
    'خميس',
    'جمعة',
    'سبت',
  ];

  // ========== New State for Medications ==========
  final MedicationsService _medicationsService = MedicationsService();

  bool _isLoadingMedications = true;
  String? _medicationsError;
  List<Medication> _allMedications = [];

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    setState(() {
      _isLoadingMedications = true;
      _medicationsError = null;
    });

    try {
      final meds = await _medicationsService.fetchMedications();
      setState(() {
        _allMedications = meds;
        _isLoadingMedications = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMedications = false;
        _medicationsError = 'فشل في تحميل قائمة الأدوية';
      });
    }
  }

  Future<void> _toggleReminder(Medication med, bool value) async {
    final updated = med.copyWith(reminderEnabled: value);

    try {
      await _medicationsService.updateMedication(updated);

      setState(() {
        final index = _allMedications.indexWhere((m) => m.id == med.id);
        if (index != -1) {
          _allMedications[index] = updated;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تحديث حالة التذكير')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: Responsive.getResponsivePadding(
              context,
              mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              desktop: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context),
                const SizedBox(height: 24),
                // Tabs
                _buildTabs(),
                const SizedBox(height: 24),
                // Calendar (only show for Schedule tab)
                if (!_isLogTab) ...[
                  _buildCalendar(),
                  const SizedBox(height: 24),
                ],
                // Remaining Doses Section
                if (!_isLogTab) _buildRemainingDosesSection(context),
                // Medication Log Content (if Log tab is selected)
                if (_isLogTab) _buildMedicationLogContent(context),
                const SizedBox(height: 80), // Space for bottom navigation
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.onSurface,
        ),
        Expanded(
          child: Text(
            'الأدوية',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () async {
            // فتح شاشة إضافة دواء جديد
            final added = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AddMedicationScreen(),
              ),
            );

            // إذا رجعنا بقيمة true نعيد تحميل قائمة الأدوية
            if (added == true) {
              _loadMedications();
            }
          },
          color: const Color(0xFF00A86B),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton('سجل الأدوية', true),
          ),
          Expanded(
            child: _buildTabButton('جدول الأدوية', false),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, bool isLogTab) {
    final isSelected = _isLogTab == isLogTab;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isLogTab = isLogTab;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00A86B) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Column(
      children: [
        _buildMonthHeader(),
        const SizedBox(height: 16),
        _buildDayNames(),
        const SizedBox(height: 8),
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildMonthHeader() {
    final monthName = _getMonthName(_currentMonth.month);
    final year = _currentMonth.year;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(
                _currentMonth.year,
                _currentMonth.month - 1,
              );
            });
          },
        ),
        Text(
          'شهر $monthName $year',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(
                _currentMonth.year,
                _currentMonth.month + 1,
              );
            });
          },
        ),
      ],
    );
  }

  Widget _buildDayNames() {
    return Row(
      children: _dayNames.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth =
    DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth =
    DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    final previousMonth =
    DateTime(_currentMonth.year, _currentMonth.month - 1, 0);
    final daysInPreviousMonth = previousMonth.day;

    List<Widget> dayWidgets = [];

    // Add previous month's trailing days
    for (int i = firstDayWeekday - 1; i >= 0; i--) {
      final day = daysInPreviousMonth - i;
      dayWidgets.add(_buildCalendarDay(day, isCurrentMonth: false));
    }

    // Add current month's days
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isSelected = _isSameDay(date, _selectedDate);
      final isToday = _isSameDay(date, DateTime.now());
      dayWidgets.add(
        _buildCalendarDay(
          day,
          isCurrentMonth: true,
          isSelected: isSelected,
          isToday: isToday,
          date: date,
        ),
      );
    }

    // Add next month's leading days
    final remainingDays = 42 - dayWidgets.length;
    for (int day = 1; day <= remainingDays; day++) {
      dayWidgets.add(_buildCalendarDay(day, isCurrentMonth: false));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: dayWidgets.length,
      itemBuilder: (context, index) => dayWidgets[index],
    );
  }

  Widget _buildCalendarDay(
      int day, {
        required bool isCurrentMonth,
        bool isSelected = false,
        bool isToday = false,
        DateTime? date,
      }) {
    return GestureDetector(
      onTap: () {
        if (isCurrentMonth && date != null) {
          setState(() {
            _selectedDate = date;
          });
          // هنا ممكن مستقبلاً تربط الأدوية بتاريخ معين
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00A86B)
              : isToday
              ? Colors.grey[100]
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Colors.white
                  : isCurrentMonth
                  ? Colors.black87
                  : Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }

  // ========== Remaining Doses Section (from API) ==========
  Widget _buildRemainingDosesSection(BuildContext context) {
    if (_isLoadingMedications) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_medicationsError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          _medicationsError!,
          style: TextStyle(color: Colors.redAccent[700]),
        ),
      );
    }

    // نعتبر أن جرعات اليوم المتبقية = الأدوية اللي التذكير لها مفعّل
    final todayMeds = _allMedications.where((m) => m.reminderEnabled).toList();

    if (todayMeds.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'لا توجد جرعات متبقية لليوم',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'جرعات اليوم المتبقية',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        ...todayMeds.map((med) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildMedicationCardFromModel(med),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildMedicationCardFromModel(Medication med) {
    return AppCard(
      isOutlined: true,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF424242)
            : const Color(0xFFE0E0E0),
        width: 1,
      ),
      child: Row(
        children: [
          // Medication Image Placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF424242)
                    : const Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.medication,
              color: Color(0xFF00A86B),
              size: 40,
            ),
          ),
          const SizedBox(width: 16),
          // Medication Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  med.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  med.brand,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${med.dosage} - ${med.timeOfDay}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: med.reminderEnabled,
            onChanged: (value) => _toggleReminder(med, value),
          ),
        ],
      ),
    );
  }

  // ========== Medication Log Content (from API) ==========
  Widget _buildMedicationLogContent(BuildContext context) {
    if (_isLoadingMedications) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_medicationsError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          _medicationsError!,
          style: TextStyle(color: Colors.redAccent[700]),
        ),
      );
    }

    if (_allMedications.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'لا توجد أدوية مسجلة',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Column(
      children: _allMedications.map((med) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildMedicationLogCardFromModel(med),
        );
      }).toList(),
    );
  }

  Widget _buildMedicationLogCardFromModel(Medication med) {
    return AppCard(
      isOutlined: true,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF424242)
            : const Color(0xFFE0E0E0),
        width: 1,
      ),
      child: Row(
        children: [
          // Medication Image
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF424242)
                    : const Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.medication,
              color: Color(0xFF00A86B),
              size: 40,
            ),
          ),
          const SizedBox(width: 16),
          // Medication Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  med.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  med.brand,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${med.dosage} - ${med.timeOfDay}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getMonthName(int month) {
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return months[month - 1];
  }
}
