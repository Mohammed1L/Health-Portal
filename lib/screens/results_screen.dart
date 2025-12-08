import 'package:flutter/material.dart';
import '../widgets/cards/app_card.dart';
import '../core/responsive.dart';
import '../widgets/app_bar/theme_toggle_button.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

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
                // Page Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'النتائج',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ),
                    ),
                    const ThemeToggleButton(),
                  ],
                ),
                const SizedBox(height: 32),
                // Lab Results Card
                _buildResultsCard(
                  context,
                  title: 'نتائج التحاليل',
                  icon: Icons.science,
                  onTap: () {
                    // TODO: Navigate to lab results detail screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('صفحة نتائج التحاليل'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Radiology Results Card
                _buildResultsCard(
                  context,
                  title: 'نتائج الأشعة',
                  icon: Icons.medical_services,
                  onTap: () {
                    // TODO: Navigate to radiology results detail screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('صفحة نتائج الأشعة'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 80), // Space for bottom navigation
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
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
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              Icon(
                icon,
                color: const Color(0xFF00A86B),
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Empty content area - will be filled with results list
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'لا توجد نتائج متاحة',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

