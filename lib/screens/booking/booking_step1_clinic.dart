import 'package:flutter/material.dart';
import '../../widgets/inputs/app_text_field.dart';
import '../../widgets/buttons/app_button.dart';
import '../../widgets/cards/app_card.dart';

// NEW: service
import '../../services/booking_lookup_service.dart';
import '../../core/constants/api_config.dart';

class BookingStep1Clinic extends StatefulWidget {
  final Function(Map<String, dynamic>) onClinicSelected;

  const BookingStep1Clinic({
    super.key,
    required this.onClinicSelected,
  });

  @override
  State<BookingStep1Clinic> createState() => _BookingStep1ClinicState();
}

class _BookingStep1ClinicState extends State<BookingStep1Clinic> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedClinicId;

  // NEW: service + state
  final BookingLookupService _service =
  BookingLookupService(baseUrl: ApiConfig.baseUrl);

  List<Map<String, dynamic>> _clinics = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadClinics();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadClinics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final clinics = await _service.fetchClinics();
      if (!mounted) return;
      setState(() {
        _clinics = clinics;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'حدث خطأ أثناء جلب العيادات. حاول مرة أخرى.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختر العيادة',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildSearchBar(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildClinicList(),
          ),
          const SizedBox(height: 16),
          if (_selectedClinicId != null)
            AppButton(
              text: 'التالي',
              type: AppButtonType.primary,
              size: AppButtonSize.large,
              isFullWidth: true,
              backgroundColor: const Color(0xFF00A86B),
              textColor: Theme.of(context).colorScheme.surface,
              onPressed: () {
                final selectedClinic = _getClinicById(_selectedClinicId!);
                if (selectedClinic != null) {
                  widget.onClinicSelected(selectedClinic);
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);
    return AppTextField(
      controller: _searchController,
      hintText: 'البحث عن العيادة',
      fillColor: theme.colorScheme.surface,
      prefixIcon: Icon(
        Icons.search,
        color: theme.iconTheme.color?.withOpacity(0.7) ?? Colors.grey,
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }

  Widget _buildClinicList() {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _errorMessage!,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            AppButton(
              text: 'إعادة المحاولة',
              type: AppButtonType.secondary,
              size: AppButtonSize.medium,
              onPressed: _loadClinics,
            ),
          ],
        ),
      );
    }

    final clinics = _getFilteredClinics();

    if (clinics.isEmpty) {
      return Center(
        child: Text(
          'لا توجد عيادات متاحة',
          style: TextStyle(
            fontSize: 16,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ??
                Colors.grey[600],
          ),
        ),
      );
    }

    final isDark = theme.brightness == Brightness.dark;

    return ListView.builder(
      itemCount: clinics.length,
      itemBuilder: (context, index) {
        final clinic = clinics[index];
        final isSelected = _selectedClinicId == clinic['id'];

        final Color borderColor = isSelected
            ? const Color(0xFF00A86B)
            : (isDark ? Colors.grey[700]! : Colors.grey[300]!);

        final Color iconColor =
        isDark ? Colors.grey[300]! : Colors.grey[600]!;

        final Color textColor = isSelected
            ? const Color(0xFF00A86B)
            : theme.colorScheme.onSurface;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppCard(
            isOutlined: true,
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            color: theme.colorScheme.surface,
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2 : 1,
            ),
            onTap: () {
              setState(() {
                _selectedClinicId = clinic['id'] as String;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: iconColor,
                  size: 20,
                ),
                Expanded(
                  child: Text(
                    clinic['name'] as String,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getFilteredClinics() {
    if (_searchQuery.isEmpty) {
      return _clinics;
    }

    final query = _searchQuery.toLowerCase();
    return _clinics
        .where((clinic) =>
        (clinic['name'] as String).toLowerCase().contains(query))
        .toList();
  }

  Map<String, dynamic>? _getClinicById(String id) {
    try {
      return _clinics.firstWhere(
            (clinic) => clinic['id'] == id,
      );
    } catch (e) {
      return null;
    }
  }
}
