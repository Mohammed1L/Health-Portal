import 'package:flutter/material.dart';
import '../widgets/cards/app_card.dart';
import '../core/responsive.dart';

class HealthRecordScreen extends StatelessWidget {
  const HealthRecordScreen({super.key});

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
                // Personal Metrics Cards (Top Row)
                _buildPersonalMetricsRow(context),
                const SizedBox(height: 24),
                // Health Measurement Cards
                _buildHealthMeasurementCard(
                  context,
                  label: 'ضغط الدم',
                  value: 'mmHg 127 / 71',
                  icon: Icons.favorite,
                  status: 'طبيعي',
                ),
                const SizedBox(height: 16),
                _buildHealthMeasurementCard(
                  context,
                  label: 'سكر الدم',
                  value: 'mg/dL 120',
                  icon: Icons.water_drop,
                  status: 'طبيعي',
                ),
                const SizedBox(height: 16),
                _buildHealthMeasurementCard(
                  context,
                  label: 'مؤشر كتلة الجسم',
                  value: 'kg/m 22',
                  icon: Icons.person,
                  status: 'طبيعي',
                ),
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
            'السجل الصحي',
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
            // TODO: Navigate to detailed health record or edit
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('صفحة تفاصيل السجل الصحي'),
              ),
            );
          },
          color: const Color(0xFF00A86B),
        ),
      ],
    );
  }

  Widget _buildPersonalMetricsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(context,
            label: 'الطول',
            value: 'XXX.XX', // TODO: Replace with actual height from user data
            icon: Icons.straighten,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(context,
            label: 'الوزن',
            value: 'XX.XX', // TODO: Replace with actual weight from user data
            icon: Icons.monitor_weight,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(context,
            label: 'فصيلة الدم',
            value: 'O+', // TODO: Replace with actual blood type from user data
            icon: Icons.bloodtype,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return AppCard(
      isOutlined: true,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF424242) : const Color(0xFFE0E0E0),
        width: 1,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF00A86B),
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMeasurementCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required String status,
  }) {
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
          Row(
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF00A86B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF00A86B),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Label and Value
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Status Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF00A86B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFF00A86B).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              status,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00A86B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

