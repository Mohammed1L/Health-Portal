import 'package:flutter/material.dart';
import '../widgets/cards/app_card.dart';
import '../core/responsive.dart';
import '../widgets/app_bar/theme_toggle_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
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
            value: '',
          ),
          const SizedBox(height: 16),
          _buildAppointmentDetail(
            context,
            icon: Icons.person,
            label: 'اسم الطبيب',
            value: '',
          ),
          const SizedBox(height: 16),
          _buildAppointmentDetail(
            context,
            icon: Icons.location_on,
            label: 'موقع المستشفى',
            value: '',
          ),
          const SizedBox(height: 16),
          _buildAppointmentDetail(
            context,
            icon: Icons.access_time,
            label: 'التاريخ والوقت',
            value: '',
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
      children: [
        Icon(
          icon,
          color: const Color(0xFF00A86B),
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
      ],
    );
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
        // Navigate to results screen
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
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

