import 'package:flutter/material.dart';
import '../widgets/cards/app_card.dart';
import '../core/responsive.dart';

class VaccinationsScreen extends StatelessWidget {
  const VaccinationsScreen({super.key});

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
                // Vaccination List
                _buildVaccinationList(context),
                const SizedBox(height: 80), // Space for bottom navigation
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => Navigator.of(context).pop(),
              color: Theme.of(context).colorScheme.onSurface,
            ),
            Expanded(
              child: Text(
                'التطعيمات',
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
                // TODO: Navigate to add vaccination or details
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('إضافة تطعيم جديد'),
                  ),
                );
              },
              color: const Color(0xFF00A86B),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildVaccinationList(BuildContext context) {
    // TODO: Replace with actual vaccination data from API
    final vaccinations = _getVaccinationList();

    if (vaccinations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'لا توجد تطعيمات مسجلة',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Column(
      children: vaccinations.map((vaccination) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildVaccinationCard(context, vaccination),
        );
      }).toList(),
    );
  }

  Widget _buildVaccinationCard(BuildContext context, Map<String, dynamic> vaccination) {
    final vaccineName = vaccination['name'] as String;
    final date = vaccination['date'] as String;
    final isCompleted = vaccination['isCompleted'] as bool? ?? true;

    return AppCard(
      isOutlined: true,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF424242) : const Color(0xFFE0E0E0),
        width: 1,
      ),
      child: Row(
        children: [
          // Completed Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF00A86B).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.vaccines,
                  color: Color(0xFF00A86B),
                  size: 28,
                ),
                if (isCompleted)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00A86B),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.surface,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Vaccine Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vaccineName,
                  style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TODO: Replace with actual API call to fetch vaccination records
  List<Map<String, dynamic>> _getVaccinationList() {
    return [
      {
        'id': '1',
        'name': 'لقاح فايزر-بيونتك',
        'date': 'الجمعة 31 ديسمبر 2021',
        'isCompleted': true,
      },
      {
        'id': '2',
        'name': 'لقاح فايزر-بيونتك',
        'date': 'الخميس 5 يناير 2022',
        'isCompleted': true,
      },
      {
        'id': '3',
        'name': 'لقاح فايزر-بيونتك',
        'date': 'الخميس 12 يناير 2022',
        'isCompleted': true,
      },
      {
        'id': '4',
        'name': 'لقاح الأنفلونزا',
        'date': 'الأحد 15 أكتوبر 2023',
        'isCompleted': true,
      },
    ];
  }
}

