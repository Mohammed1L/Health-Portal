import 'package:flutter/material.dart';
import '../widgets/cards/app_card.dart';
import '../core/responsive.dart';

enum ApprovalStatus { approved, rejected, pending }

class InsuranceApprovalsScreen extends StatelessWidget {
  const InsuranceApprovalsScreen({super.key});

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
                // Approval List
                _buildApprovalList(context),
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
            'موافقات التأمين',
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

  Widget _buildApprovalList(BuildContext context) {
    // TODO: Replace with actual approval data from API
    final approvals = _getApprovalList();

    if (approvals.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'لا توجد موافقات متاحة',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Column(
      children: approvals.map((approval) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildApprovalCard(context, approval),
        );
      }).toList(),
    );
  }

  Widget _buildApprovalCard(BuildContext context, Map<String, dynamic> approval) {
    final clinic = approval['clinic'] as String;
    final doctor = approval['doctor'] as String;
    final location = approval['location'] as String;
    final dateTime = approval['dateTime'] as String;
    final status = approval['status'] as ApprovalStatus;

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
              // Status Button
              _buildStatusButton(status),
              const SizedBox(width: 16),
              // Appointment Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(context,
                      icon: Icons.business,
                      label: 'اسم العيادة',
                      value: clinic,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(context,
                      icon: Icons.person,
                      label: 'اسم الطبيب',
                      value: doctor,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(context,
                      icon: Icons.location_on,
                      label: 'موقع المستشفى',
                      value: location,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(context,
                      icon: Icons.access_time,
                      label: 'التاريخ والوقت',
                      value: dateTime,
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

  Widget _buildDetailRow(
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
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusButton(ApprovalStatus status) {
    String statusText;
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case ApprovalStatus.approved:
        statusText = 'تمت الموافقة';
        backgroundColor = const Color(0xFF00A86B).withOpacity(0.1);
        textColor = const Color(0xFF00A86B);
        break;
      case ApprovalStatus.rejected:
        statusText = 'مرفوضة';
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        break;
      case ApprovalStatus.pending:
        statusText = 'بإنتظار الموافقة';
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: textColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  // TODO: Replace with actual API call to fetch insurance approvals
  List<Map<String, dynamic>> _getApprovalList() {
    return [
      {
        'id': '1',
        'clinic': 'عيادة القلب',
        'doctor': 'د. أحمد محمد',
        'location': 'مستشفى الملك فهد',
        'dateTime': '21 أغسطس 2025, 9:10 ص',
        'status': ApprovalStatus.approved,
      },
      {
        'id': '2',
        'clinic': 'عيادة طب الأسنان',
        'doctor': 'د. فاطمة علي',
        'location': 'مستشفى الملك خالد',
        'dateTime': '25 أغسطس 2025, 2:30 م',
        'status': ApprovalStatus.rejected,
      },
      {
        'id': '3',
        'clinic': 'عيادة طب العيون',
        'doctor': 'د. خالد سعيد',
        'location': 'مستشفى الملك سعود',
        'dateTime': '30 أغسطس 2025, 11:00 ص',
        'status': ApprovalStatus.pending,
      },
    ];
  }
}

