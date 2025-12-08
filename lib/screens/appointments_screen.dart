import 'package:flutter/material.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/buttons/app_button.dart';
import '../core/responsive.dart';
import '../widgets/app_bar/theme_toggle_button.dart';
import 'booking/booking_flow_screen.dart';

enum AppointmentTab { upcoming, previous }

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  AppointmentTab _selectedTab = AppointmentTab.upcoming;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Header with title and tabs
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
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
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
              // Content area
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
        // TODO: Filter appointments based on selected tab
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
    // TODO: Replace with actual appointment data based on selected tab
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
                style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
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
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const BookingFlowScreen(),
          ),
        );
      },
    );
  }

  // TODO: Replace with actual data fetching logic
  List<Map<String, String>> _getAppointments() {
    // This is placeholder data - replace with actual API call or state management
    if (_selectedTab == AppointmentTab.upcoming) {
      // Return upcoming appointments
      return [
        {
          'clinic': 'عيادة القلب',
          'doctor': 'د. أحمد محمد',
          'location': 'مستشفى الملك فهد',
          'dateTime': '2024-01-15 - 10:00 صباحاً',
        },
      ];
    } else {
      // Return previous appointments
      return [];
    }
  }

  // TODO: Implement actual data loading logic
  void _loadAppointments() {
    // This method will be called when tab changes
    // Implement your data fetching logic here
    setState(() {
      // Refresh the appointment list
    });
  }
}

