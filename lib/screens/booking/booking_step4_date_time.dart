import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../widgets/buttons/app_button.dart';
import '../../core/hijri_calendar_helper.dart';
import '../../core/constants/api_config.dart';


class BookingStep4DateTime extends StatefulWidget {
  final Function(DateTime selectedDate, String selectedTime) onDateTimeSelected;
  final String? selectedClinicId;
  final String? selectedFacilityId;
  final String? selectedDoctorId;

  const BookingStep4DateTime({
    super.key,
    required this.onDateTimeSelected,
    this.selectedClinicId,
    this.selectedFacilityId,
    this.selectedDoctorId,
  });

  @override
  State<BookingStep4DateTime> createState() => _BookingStep4DateTimeState();
}

class _BookingStep4DateTimeState extends State<BookingStep4DateTime> {
  bool _isHijri = false; // false = Gregorian, true = Hijri
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  String? _selectedTime;

  // ربط API للأوقات
  final String _baseUrl = ApiConfig.baseUrl; // TODO: عدّلها حسب السيرفر
  List<String> _availableTimes = [];
  bool _isLoadingTimes = false;
  String? _timesError;

  // الأيام التي يوجد لها مواعيد متاحة (مستخرجة من الـ API)
  Set<DateTime> _availableDates = {};

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

  @override
  void initState() {
    super.initState();
    // لو كل شيء مختار (عيادة + منشأة + طبيب) نقدر نحمّل البيانات
    if (widget.selectedClinicId != null &&
        widget.selectedFacilityId != null &&
        widget.selectedDoctorId != null) {
      _loadAvailableDates(); // نجيب الأيام المتاحة، والأوقات لأول يوم متاح
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'التاريخ والوقت',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          _buildCalendarToggle(),
          const SizedBox(height: 20),
          _buildCalendar(),
          const SizedBox(height: 24),
          _buildAvailableTimes(),
          const SizedBox(height: 24),
          _buildBookButton(),
        ],
      ),
    );
  }

  Widget _buildCalendarToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton('هجري', true),
          ),
          Expanded(
            child: _buildToggleButton('ميلادي', false),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isHijriValue) {
    final isSelected = _isHijri == isHijriValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_isHijri != isHijriValue) {
            if (isHijriValue) {
              // الانتقال لعرض هجري
              final hijriDate = HijriDate.fromGregorian(_currentMonth);
              _currentMonth = hijriDate.toGregorian();
            } else {
              // الرجوع لميلادي (نفس القيمة الحالية كـ Gregorian)
            }
            _isHijri = isHijriValue;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFF00A86B) : Colors.grey[600],
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
    String monthName;
    int year;

    if (_isHijri) {
      final hijriDate = HijriDate.fromGregorian(_currentMonth);
      monthName = _getHijriMonthName(hijriDate.month);
      year = hijriDate.year;
    } else {
      monthName = _getMonthName(_currentMonth.month);
      year = _currentMonth.year;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              if (_isHijri) {
                final hijriDate = HijriDate.fromGregorian(_currentMonth);
                final newHijri = HijriDate(
                  year:
                  hijriDate.month == 1 ? hijriDate.year - 1 : hijriDate.year,
                  month: hijriDate.month == 1 ? 12 : hijriDate.month - 1,
                  day: 1,
                );
                _currentMonth = newHijri.toGregorian();
              } else {
                _currentMonth = DateTime(
                  _currentMonth.year,
                  _currentMonth.month - 1,
                );
              }
            });
          },
        ),
        Text(
          'شهر $monthName $year',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              if (_isHijri) {
                final hijriDate = HijriDate.fromGregorian(_currentMonth);
                final newHijri = HijriDate(
                  year: hijriDate.month == 12
                      ? hijriDate.year + 1
                      : hijriDate.year,
                  month: hijriDate.month == 12 ? 1 : hijriDate.month + 1,
                  day: 1,
                );
                _currentMonth = newHijri.toGregorian();
              } else {
                _currentMonth = DateTime(
                  _currentMonth.year,
                  _currentMonth.month + 1,
                );
              }
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
    List<Widget> dayWidgets = [];

    if (_isHijri) {
      // Hijri calendar
      final hijriDate = HijriDate.fromGregorian(_currentMonth);
      final firstDayOfMonth = HijriDate(
        year: hijriDate.year,
        month: hijriDate.month,
        day: 1,
      );
      final lastDayOfMonth = HijriDate(
        year: hijriDate.year,
        month: hijriDate.month,
        day: hijriDate.lengthOfMonth(),
      );

      final firstDayDate = firstDayOfMonth.toGregorian();
      final firstDayWeekday = firstDayDate.weekday % 7;
      final daysInMonth = lastDayOfMonth.lengthOfMonth();

      // previous month
      final prevMonth = hijriDate.month == 1 ? 12 : hijriDate.month - 1;
      final prevYear =
      hijriDate.month == 1 ? hijriDate.year - 1 : hijriDate.year;
      final prevHijri = HijriDate(year: prevYear, month: prevMonth, day: 1);
      final daysInPreviousMonth = prevHijri.lengthOfMonth();

      // Add previous month's trailing days
      for (int i = firstDayWeekday - 1; i >= 0; i--) {
        final day = daysInPreviousMonth - i;
        dayWidgets.add(
          _buildCalendarDay(
            day,
            isCurrentMonth: false,
          ),
        );
      }

      // Add current month's days
      for (int day = 1; day <= daysInMonth; day++) {
        final hijriDay = HijriDate(
          year: hijriDate.year,
          month: hijriDate.month,
          day: day,
        );
        final date = hijriDay.toGregorian();
        final isSelected = _isSameDay(date, _selectedDate);
        final isToday = _isSameDay(date, DateTime.now());

        final normalized = DateTime(date.year, date.month, date.day);
        final bool isEnabled = _availableDates.isEmpty
            ? false
            : _availableDates.contains(normalized);

        dayWidgets.add(
          _buildCalendarDay(
            day,
            isCurrentMonth: true,
            isSelected: isSelected,
            isToday: isToday,
            date: date,
            isEnabled: isEnabled,
          ),
        );
      }

      // Add next month's leading days
      final remainingDays = 42 - dayWidgets.length;
      for (int day = 1; day <= remainingDays; day++) {
        dayWidgets.add(
          _buildCalendarDay(
            day,
            isCurrentMonth: false,
          ),
        );
      }
    } else {
      // Gregorian calendar
      final firstDayOfMonth =
      DateTime(_currentMonth.year, _currentMonth.month, 1);
      final lastDayOfMonth =
      DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
      final firstDayWeekday = firstDayOfMonth.weekday % 7;
      final daysInMonth = lastDayOfMonth.day;

      final previousMonth =
      DateTime(_currentMonth.year, _currentMonth.month - 1, 0);
      final daysInPreviousMonth = previousMonth.day;

      // Add previous month's trailing days
      for (int i = firstDayWeekday - 1; i >= 0; i--) {
        final day = daysInPreviousMonth - i;
        dayWidgets.add(
          _buildCalendarDay(
            day,
            isCurrentMonth: false,
          ),
        );
      }

      // Add current month's days
      for (int day = 1; day <= daysInMonth; day++) {
        final date = DateTime(_currentMonth.year, _currentMonth.month, day);
        final isSelected = _isSameDay(date, _selectedDate);
        final isToday = _isSameDay(date, DateTime.now());

        final normalized = DateTime(date.year, date.month, date.day);
        final bool isEnabled = _availableDates.isEmpty
            ? false
            : _availableDates.contains(normalized);

        dayWidgets.add(
          _buildCalendarDay(
            day,
            isCurrentMonth: true,
            isSelected: isSelected,
            isToday: isToday,
            date: date,
            isEnabled: isEnabled,
          ),
        );
      }

      // Add next month's leading days
      final remainingDays = 42 - dayWidgets.length;
      for (int day = 1; day <= remainingDays; day++) {
        dayWidgets.add(
          _buildCalendarDay(
            day,
            isCurrentMonth: false,
          ),
        );
      }
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
        bool isEnabled = true,
      }) {
    final bool canTap =
        isCurrentMonth && date != null && isEnabled; // اليوم المسموح الضغط عليه
    final DateTime? selectedDate = canTap ? date : null;

    return GestureDetector(
      onTap: () {
        if (!canTap || selectedDate == null) return;

        setState(() {
          _selectedDate = selectedDate;
          _selectedTime = null; // reset الوقت عند تغيير التاريخ
        });
        _loadAvailableTimes(selectedDate);
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
              color: !isEnabled
                  ? Colors.grey[300] // الأيام المعطّلة (ما فيها مواعيد)
                  : isSelected
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

  Widget _buildAvailableTimes() {
    if (widget.selectedClinicId == null ||
        widget.selectedFacilityId == null ||
        widget.selectedDoctorId == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(
          'الرجاء اختيار العيادة والمنشأة والطبيب أولاً',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Text(
          'الأوقات المتاحة:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        _buildTimeSlots(),
      ],
    );
  }

  Widget _buildTimeSlots() {
    if (_isLoadingTimes) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_timesError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _timesError!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'إعادة المحاولة',
                type: AppButtonType.secondary,
                size: AppButtonSize.medium,
                onPressed: () => _loadAvailableTimes(_selectedDate),
              ),
            ],
          ),
        ),
      );
    }

    if (_availableTimes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'لا توجد أوقات متاحة لهذا التاريخ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _availableTimes.map((time) {
        final isSelected = _selectedTime == time;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedTime = time;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF00A86B).withOpacity(0.1)
                  : Colors.grey[100],
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF00A86B)
                    : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF00A86B)
                    : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBookButton() {
    final canBook = _selectedTime != null &&
        widget.selectedClinicId != null &&
        widget.selectedFacilityId != null &&
        widget.selectedDoctorId != null;

    return AppButton(
      text: 'حجز الموعد',
      type: AppButtonType.primary,
      size: AppButtonSize.large,
      isFullWidth: true,
      backgroundColor: const Color(0xFF00A86B),
      textColor: Theme.of(context).colorScheme.surface,
      onPressed: canBook
          ? () {
        widget.onDateTimeSelected(
          _selectedDate,
          _selectedTime!,
        );
      }
          : null,
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

  String _getHijriMonthName(int month) {
    final months = [
      'محرم',
      'صفر',
      'ربيع الأول',
      'ربيع الثاني',
      'جمادى الأولى',
      'جمادى الآخرة',
      'رجب',
      'شعبان',
      'رمضان',
      'شوال',
      'ذو القعدة',
      'ذو الحجة',
    ];
    return months[month - 1];
  }

  Future<void> _loadAvailableTimes(DateTime date) async {
    // إذا ما فيه بيانات كافية لاختيار الطبيب/المنشأة/العيادة
    if (widget.selectedClinicId == null ||
        widget.selectedFacilityId == null ||
        widget.selectedDoctorId == null) {
      setState(() {
        _availableTimes = [];
        _timesError = 'الرجاء اختيار العيادة والمنشأة والطبيب أولاً';
      });
      return;
    }

    setState(() {
      _isLoadingTimes = true;
      _timesError = null;
      _availableTimes = [];
      _selectedTime = null;
    });

    try {
      // نجيب كل الـ time-slots ثم نفلترها في Flutter
      final uri = Uri.parse('$_baseUrl/time-slots');
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Status code: ${response.statusCode}');
      }

      final List<dynamic> jsonList =
      jsonDecode(response.body) as List<dynamic>;

      final normalizedSelected =
      DateTime(date.year, date.month, date.day);

      final List<String> times = [];

      for (final item in jsonList) {
        if (item is! Map<String, dynamic>) continue;

        // فلترة العيادة والمنشأة والطبيب
        if (item['clinicId']?.toString() != widget.selectedClinicId) continue;
        if (item['facilityId']?.toString() != widget.selectedFacilityId) continue;
        if (item['doctorId']?.toString() != widget.selectedDoctorId) continue;

        final dateStr = item['date']?.toString();
        if (dateStr == null) continue;

        final dt = DateTime.tryParse(dateStr);
        if (dt == null) continue;

        final normalizedSlotDate =
        DateTime(dt.year, dt.month, dt.day);

        // لازم نفس اليوم
        if (!_isSameDay(normalizedSlotDate, normalizedSelected)) continue;

        final timeStr = item['time']?.toString();
        if (timeStr == null || timeStr.isEmpty) continue;

        times.add(timeStr);
      }

      setState(() {
        _availableTimes = times;
      });
    } catch (e) {
      setState(() {
        _timesError =
        'حدث خطأ أثناء جلب الأوقات المتاحة، حاول مرة أخرى.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingTimes = false;
        });
      }
    }
  }

  Future<void> _loadAvailableDates() async {
    // إذا ما فيه بيانات كافية لاختيار الطبيب/المنشأة/العيادة
    if (widget.selectedClinicId == null ||
        widget.selectedFacilityId == null ||
        widget.selectedDoctorId == null) {
      return;
    }

    try {
      final uri = Uri.parse('$_baseUrl/time-slots');
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Status code: ${response.statusCode}');
      }

      final List<dynamic> jsonList =
      jsonDecode(response.body) as List<dynamic>;

      final datesSet = <DateTime>{};

      for (final item in jsonList) {
        if (item is! Map<String, dynamic>) continue;

        // فلترة العيادة والمنشأة والطبيب
        if (item['clinicId']?.toString() != widget.selectedClinicId) continue;
        if (item['facilityId']?.toString() != widget.selectedFacilityId) continue;
        if (item['doctorId']?.toString() != widget.selectedDoctorId) continue;

        final dateStr = item['date']?.toString();
        if (dateStr == null) continue;

        final dt = DateTime.tryParse(dateStr);
        if (dt == null) continue;

        datesSet.add(DateTime(dt.year, dt.month, dt.day));
      }

      setState(() {
        _availableDates = datesSet;

        // لو فيه أيام متاحة، نضبط التاريخ المختار على أقرب يوم متاح
        if (_availableDates.isNotEmpty) {
          final today = DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
          );

          if (!_availableDates.contains(today)) {
            _selectedDate = _availableDates.first;
          }

          // نحمّل الأوقات لأول يوم متاح
          _loadAvailableTimes(_selectedDate);
        } else {
          // ما فيه أي أيام متاحة، نفضّي الأوقات
          _availableTimes = [];
        }
      });
    } catch (e) {
      debugPrint('Error loading available dates: $e');
    }
  }
}
