import 'package:flutter/material.dart';

import '../widgets/cards/app_card.dart';
import '../core/responsive.dart';
import '../widgets/app_bar/theme_toggle_button.dart';
import '../services/appointments_service.dart';
import '../models/appointment.dart';
import '../core/constants/api_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // service
  final AppointmentsService _appointmentsService =
  AppointmentsService(baseUrl: ApiConfig.baseUrl);
  // لو تشغل على Emulator أندرويد:
  // AppointmentsService(baseUrl: 'http://10.0.2.2:3000');

  Appointment? _nextAppointment;
  bool _isLoadingNext = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNextAppointment();
  }

  Future<void> _loadNextAppointment() async {
    try {
      final appt =
      await _appointmentsService.fetchNearestUpcomingAppointment();

      setState(() {
        _nextAppointment = appt;
        _isLoadingNext = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _nextAppointment = null;
        _isLoadingNext = false;
        _errorMessage = 'حدث خطأ أثناء تحميل الموعد القادم';
      });
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
              mobile:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              tablet:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              desktop:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildNextAppointmentCard(context),
                const SizedBox(height: 32),
                _buildResultsRecordSection(context),
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
        // Logo
        Image.asset(
          'lib/assets/image.png',
          height: 50,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF003366),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.medical_services,
                color: Theme.of(context).colorScheme.surface,
                size: 30,
              ),
            );
          },
        ),
        const SizedBox(width: 12),
        // Greeting
        Expanded(
          child: Text(
            'مرحباً، عبدالله',
            style:
            Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: const Color(0xFF003366),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Theme toggle button
        const ThemeToggleButton(),
      ],
    );
  }

  Widget _buildNextAppointmentCard(BuildContext context) {
    // حالة التحميل
    if (_isLoadingNext) {
      return AppCard(
        isOutlined: true,
        padding: const EdgeInsets.all(20),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF424242)
              : const Color(0xFFE0E0E0),
          width: 1,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('جاري تحميل الموعد القادم...'),
            ],
          ),
        ),
      );
    }

    // حالة الخطأ
    if (_errorMessage != null) {
      return AppCard(
        isOutlined: true,
        padding: const EdgeInsets.all(20),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF424242)
              : const Color(0xFFE0E0E0),
          width: 1,
        ),
        child: Text(
          _errorMessage!,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.red,
          ),
        ),
      );
    }

    // لا يوجد موعد قادم
    if (_nextAppointment == null) {
      return AppCard(
        isOutlined: true,
        padding: const EdgeInsets.all(20),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF424242)
              : const Color(0xFFE0E0E0),
          width: 1,
        ),
        child: Text(
          'لا يوجد موعد قادم مسجل حاليًا',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    final appt = _nextAppointment!;

    return AppCard(
      isOutlined: true,
      padding: const EdgeInsets.all(20),
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF424242)
            : const Color(0xFFE0E0E0),
        width: 1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الموعد القادم',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          _buildAppointmentDetail(
            context,
            icon: Icons.business,
            label: 'اسم العيادة',
            value: appt.clinic,
          ),
          const SizedBox(height: 16),
          _buildAppointmentDetail(
            context,
            icon: Icons.person,
            label: 'اسم الطبيب',
            value: appt.doctor,
          ),
          const SizedBox(height: 16),
          _buildAppointmentDetail(
            context,
            icon: Icons.location_on,
            label: 'موقع المستشفى',
            value: appt.location,
          ),
          const SizedBox(height: 16),
          _buildAppointmentDetail(
            context,
            icon: Icons.access_time,
            label: 'التاريخ والوقت',
            value: _formatDateTime(appt.dateTime),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentDetail(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String value,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFF00A86B),
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value.isEmpty ? '-' : value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dt) {
    // تنسيق بسيط: 2025-12-15 10:00
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');

    return '$y-$m-$d   $h:$min';
  }

  Widget _buildResultsRecordSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'سجل النتائج',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildResultCard(
                context,
                icon: Icons.science,
                title: 'نتائج التحاليل',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildResultCard(
                context,
                icon: Icons.medical_services,
                title: 'نتائج الأشعة',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultCard(
      BuildContext context, {
        required IconData icon,
        required String title,
      }) {
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
      onTap: () {
        // TODO: Navigate to results screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(title),
          ),
        );
      },
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF00A86B),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style:
              Theme.of(context).textTheme.bodyLarge?.copyWith(
                color:
                Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
