import 'package:flutter/material.dart';
import '../../widgets/buttons/app_button.dart';
import '../../widgets/cards/app_card.dart';

class BookingStep5Review extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  final Function(String step) onChangeStep;
  final VoidCallback onConfirmBooking;

  const BookingStep5Review({
    super.key,
    required this.bookingData,
    required this.onChangeStep,
    required this.onConfirmBooking,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مراجعة تفاصيل الحجز',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 24),
          _buildDetailCard(
            context,
            label: 'العيادة',
            value: _getClinicName(),
            icon: Icons.business,
            onTap: () => onChangeStep('clinic'),
          ),
          const SizedBox(height: 12),
          _buildDetailCard(
            context,
            label: 'المنشأة',
            value: _getFacilityName(),
            icon: Icons.location_city,
            onTap: () => onChangeStep('facility'),
          ),
          const SizedBox(height: 12),
          _buildDetailCard(
            context,
            label: 'الطبيب',
            value: _getDoctorName(),
            icon: Icons.person,
            onTap: () => onChangeStep('doctor'),
          ),
          const SizedBox(height: 12),
          _buildDetailCard(
            context,
            label: 'التاريخ والوقت',
            value: _getDateTime(),
            icon: Icons.calendar_today,
            onTap: () => onChangeStep('date'),
          ),
          const SizedBox(height: 32),
          AppButton(
            text: 'تأكيد الحجز',
            type: AppButtonType.primary,
            size: AppButtonSize.large,
            isFullWidth: true,
            backgroundColor: const Color(0xFF00A86B),
            textColor: Theme.of(context).colorScheme.surface,
            onPressed: onConfirmBooking,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required String label,
    required String value,
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
      child: Row(
        children: [
          // Change button
          GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: Color(0xFF00A86B),
                ),
                const SizedBox(width: 4),
                const Text(
                  'تغيير',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF00A86B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Value and label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
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
        ],
      ),
    );
  }

  String _getClinicName() {
    final clinic = bookingData['clinic'];
    if (clinic != null && clinic is Map) {
      return clinic['name'] as String? ?? 'اسم العيادة';
    }
    return 'اسم العيادة';
  }

  String _getFacilityName() {
    final facility = bookingData['facility'];
    if (facility != null && facility is Map) {
      return facility['name'] as String? ?? 'اسم المنشأة';
    }
    return 'اسم المنشأة';
  }

  String _getDoctorName() {
    final doctor = bookingData['doctor'];
    if (doctor != null && doctor is Map) {
      return doctor['name'] as String? ?? 'اسم الطبيب';
    }
    return 'اسم الطبيب';
  }

  String _getDateTime() {
    final date = bookingData['date'];
    final time = bookingData['time'];
    
    if (date != null && date is DateTime && time != null && time is String) {
      // Format date in Arabic
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
      
      final monthName = months[date.month - 1];
      return '${date.day} $monthName ${date.year}, $time';
    }
    
    return 'التاريخ والوقت';
  }
}

