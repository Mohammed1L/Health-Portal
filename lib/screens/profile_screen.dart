import 'package:flutter/material.dart';
import '../widgets/cards/app_card.dart';
import '../core/responsive.dart';
import '../widgets/app_bar/theme_toggle_button.dart';
import 'profile_details_screen.dart';
import 'health_record_screen.dart';
import 'medications_screen.dart';
import 'vaccinations_screen.dart';
import 'insurance_info_screen.dart';
import 'insurance_approvals_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                // Header with theme toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle(context, 'ملفي'),
                    const ThemeToggleButton(),
                  ],
                ),
                const SizedBox(height: 16),
                // My Profile Section
                _buildProfileCard(context),
                const SizedBox(height: 32),
                // Health File Section
                _buildSectionTitle(context, 'الملف الصحي'),
                const SizedBox(height: 16),
                _buildHealthFileCards(context),
                const SizedBox(height: 32),
                // Insurance Section
                _buildSectionTitle(context, 'التأمين'),
                const SizedBox(height: 16),
                _buildInsuranceCards(context),
                const SizedBox(height: 80), // Space for bottom navigation
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
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
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ProfileDetailsScreen(),
          ),
        );
      },
      child: Row(
        children: [
          // Details link
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileDetailsScreen(),
                ),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chevron_left,
                  size: 20,
                  color: Color(0xFF00A86B),
                ),
                SizedBox(width: 4),
                Text(
                  'تفاصيل',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF00A86B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // User name
          Text(
            'عبدالله العمران',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          // Profile icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF00A86B).withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF00A86B),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFF00A86B),
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthFileCards(BuildContext context) {
    return Column(
      children: [
        _buildMenuItemCard(
          context,
          title: 'السجل الصحي',
          icon: Icons.medical_services,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HealthRecordScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItemCard(
          context,
          title: 'الأدوية',
          icon: Icons.medication,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MedicationsScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItemCard(
          context,
          title: 'التطعيمات',
          icon: Icons.vaccines,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const VaccinationsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInsuranceCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildMenuItemCard(
            context,
            title: 'موافقات التأمين',
            icon: Icons.verified_user,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const InsuranceApprovalsScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMenuItemCard(
            context,
            title: 'معلومات التأمين',
            icon: Icons.info_outline,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const InsuranceInfoScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItemCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
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
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF00A86B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF00A86B),
              size: 24,
            ),
          ),
          // Title
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

