import 'package:flutter/material.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/buttons/app_button.dart';
import '../core/responsive.dart';
import '../widgets/app_bar/theme_toggle_button.dart';
import 'booking/booking_flow_screen.dart';

import '../models/appointment.dart';
import '../services/appointments_service.dart';
import '../../core/constants/api_config.dart';

enum AppointmentTab { upcoming, previous }

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  AppointmentTab _selectedTab = AppointmentTab.upcoming;

  final AppointmentsService _appointmentsService =
  AppointmentsService(baseUrl: ApiConfig.baseUrl);

  List<Appointment> _appointments = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
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
              Padding(
                padding: Responsive.getResponsivePadding(
                  context,
                  mobile: const EdgeInsets.all(16),
                  tablet: const EdgeInsets.all(24),
                  desktop: const EdgeInsets.all(32),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'مواعيدي',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                              Theme.of(context).colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const ThemeToggleButton(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildTabBar(),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: Responsive.getResponsivePadding(
                    context,
                    mobile: const EdgeInsets.symmetric(horizontal: 16),
                    tablet: const EdgeInsets.symmetric(horizontal: 24),
                    desktop: const EdgeInsets.symmetric(horizontal: 32),
                  ),
                  child: Column(
                    children: [
                      _buildAppointmentList(),
                      const SizedBox(height: 24),
                      _buildBookNewAppointmentButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              'القادمة',
              AppointmentTab.upcoming,
            ),
          ),
          Expanded(
            child: _buildTabButton(
              'السابقة',
              AppointmentTab.previous,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, AppointmentTab tab) {
    final isSelected = _selectedTab == tab;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = tab;
        });
        _loadAppointments();
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

  Widget _buildAppointmentList() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            _errorMessage!,
            style: TextStyle(
              fontSize: 16,
              color: Colors.red[600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final appointments = _getAppointments();

    if (appointments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            _selectedTab == AppointmentTab.upcoming
                ? 'لا توجد مواعيد قادمة'
                : 'لا توجد مواعيد سابقة',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Column(
      children: appointments.map((appointment) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildAppointmentCard(appointment),
        );
      }).toList(),
    );
  }

  Widget _buildAppointmentCard(Map<String, String> appointment) {
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
          _buildAppointmentDetail(
            icon: Icons.business,
            label: 'اسم العيادة',
            value: appointment['clinic'] ?? '',
          ),
          const SizedBox(height: 16),
          _buildAppointmentDetail(
            icon: Icons.person,
            label: 'اسم الطبيب',
            value: appointment['doctor'] ?? '',
          ),
          const SizedBox(height: 16),
          _buildAppointmentDetail(
            icon: Icons.location_on,
            label: 'موقع المستشفى',
            value: appointment['location'] ?? '',
          ),
          const SizedBox(height: 16),
          _buildAppointmentDetail(
            icon: Icons.access_time,
            label: 'التاريخ والوقت',
            value: appointment['dateTime'] ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
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
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value.isEmpty ? label : value,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookNewAppointmentButton() {
    return AppButton(
      text: 'حجز موعد جديد',
      type: AppButtonType.primary,
      size: AppButtonSize.large,
      isFullWidth: true,
      backgroundColor: const Color(0xFF00A86B),
      textColor: Theme.of(context).colorScheme.surface,
      onPressed: () async {
        final result = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (context) => const BookingFlowScreen(),
          ),
        );

        if (result == true) {
          _loadAppointments();
        }
      },
    );
  }

  List<Map<String, String>> _getAppointments() {
    return _appointments.map((appointment) {
      return {
        'clinic': appointment.clinic,
        'doctor': appointment.doctor,
        'location': appointment.location,
        'dateTime': _formatAppointmentDateTime(appointment.dateTime),
      };
    }).toList();
  }

  String _formatAppointmentDateTime(DateTime dateTime) {
    final date =
        '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)}';
    final time =
        '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}';
    return '$date $time';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  Future<void> _loadAppointments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _appointmentsService.fetchAppointments(
        upcoming: _selectedTab == AppointmentTab.upcoming,
      );

      if (!mounted) return;

      setState(() {
        _appointments = result;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'حدث خطأ أثناء جلب المواعيد، حاول مرة أخرى.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
