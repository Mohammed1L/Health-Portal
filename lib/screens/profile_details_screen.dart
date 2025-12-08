import 'package:flutter/material.dart';
import '../widgets/cards/app_card.dart';
import '../core/responsive.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

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
                // Profile Icon
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF00A86B),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF00A86B),
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Upper Card - Name, ID, Date of Birth
                _buildUpperCard(context),
                const SizedBox(height: 32),
                // Lower Card - Personal Data
                _buildSectionTitle(context, 'بياناتي الشخصية'),
                const SizedBox(height: 16),
                _buildLowerCard(context),
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
            'بياناتي الشخصية',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
        const SizedBox(width: 48), // Balance the back button
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }

  Widget _buildUpperCard(BuildContext context) {
    return AppCard(
      isOutlined: true,
      padding: const EdgeInsets.all(20),
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF424242) : const Color(0xFFE0E0E0),
        width: 1,
      ),
      child: Column(
        children: [
          // Name
          Text(
            'عبدالله العمران',
            style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 20),
          // Divider
          const Divider(),
          const SizedBox(height: 20),
          // ID and Date of Birth Row
          Row(
            children: [
              // ID/Residency Number Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'رقم الهوية/الإقامة',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'XXXXXXXXXX', // TODO: Replace with actual ID from user data
                      style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
              // Vertical Divider
              Container(
                width: 1,
                height: 50,
                color: Colors.grey[300],
              ),
              const SizedBox(width: 20),
              // Date of Birth Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تاريخ الميلاد',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'XX-XX-XXXX', // TODO: Replace with actual date of birth from user data
                      style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLowerCard(BuildContext context) {
    return AppCard(
      isOutlined: true,
      padding: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF424242) : const Color(0xFFE0E0E0),
        width: 1,
      ),
      child: Column(
        children: [
          _buildInfoRow(context,
            label: 'رقم الجوال',
            value: '+966 XXX XXX XXX', // TODO: Replace with actual phone from user data
            icon: Icons.phone_outlined,
          ),
          const Divider(height: 1),
          _buildInfoRow(context,
            label: 'البريد الإلكتروني',
            value: 'XXXXXX@XXXX.com', // TODO: Replace with actual email from user data
            icon: Icons.email_outlined,
          ),
          const Divider(height: 1),
          _buildInfoRow(context,
            label: 'العنوان',
            value: 'جلمودة، الجبيل', // TODO: Replace with actual address from user data
            icon: Icons.home_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Value on the left
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          const SizedBox(width: 16),
          // Label and Icon on the right
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF00A86B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF00A86B),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

