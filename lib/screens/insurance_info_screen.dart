import 'package:flutter/material.dart';
import '../widgets/cards/app_card.dart';
import '../core/responsive.dart';

class InsuranceInfoScreen extends StatelessWidget {
  const InsuranceInfoScreen({super.key});

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
                // Insurance Company Logo/Icon
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A86B).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield,
                      color: Color(0xFF00A86B),
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Cooperative Insurance Card
                _buildCooperativeInsuranceCard(context),
                const SizedBox(height: 24),
                // Insurance Details Card
                _buildInsuranceDetailsCard(context),
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
            'معلومات التأمين',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            // TODO: Navigate to edit insurance or details
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تعديل معلومات التأمين'),
              ),
            );
          },
          color: const Color(0xFF00A86B),
        ),
      ],
    );
  }

  Widget _buildCooperativeInsuranceCard(BuildContext context) {
    return AppCard(
      isOutlined: true,
      padding: const EdgeInsets.all(20),
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF424242) : const Color(0xFFE0E0E0),
        width: 1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'التعاونية للتأمين',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Membership Number Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'رقم العضوية',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'XXXXXXXXXX', // TODO: Replace with actual membership number from user data
                      style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
              // Classification Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التصنيف',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'VVIP', // TODO: Replace with actual classification from user data
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

  Widget _buildInsuranceDetailsCard(BuildContext context) {
    return AppCard(
      isOutlined: true,
      padding: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF424242) : const Color(0xFFE0E0E0),
        width: 1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'تفاصيل التأمين',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
          const Divider(height: 1),
          _buildInfoRow(context,
            label: 'رقم الهاتف',
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
            label: 'تاريخ التجديد',
            value: '31-12-2025', // TODO: Replace with actual renewal date from user data
            icon: Icons.calendar_today_outlined,
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

