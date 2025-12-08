import 'package:flutter/material.dart';
import '../../widgets/inputs/app_text_field.dart';
import '../../widgets/buttons/app_button.dart';
import '../../widgets/cards/app_card.dart';

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    return AppTextField(
      controller: _searchController,
      hintText: 'البحث عن العيادة',
      fillColor: Theme.of(context).colorScheme.surface,
      prefixIcon: const Icon(
        Icons.search,
        color: Colors.grey,
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
        // TODO: Implement search logic
        _performSearch(value);
      },
    );
  }

  Widget _buildClinicList() {
    final clinics = _getFilteredClinics();

    if (clinics.isEmpty) {
      return Center(
        child: Text(
          'لا توجد عيادات متاحة',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: clinics.length,
      itemBuilder: (context, index) {
        final clinic = clinics[index];
        final isSelected = _selectedClinicId == clinic['id'];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppCard(
            isOutlined: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF00A86B)
                  : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            onTap: () {
              setState(() {
                _selectedClinicId = clinic['id'] as String;
              });
              // TODO: Load doctors for selected clinic
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey[600],
                  size: 20,
                ),
                Expanded(
                  child: Text(
                    clinic['name'] as String,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF00A86B)
                          : Colors.black87,
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

  // TODO: Replace with actual API call to fetch clinics
  List<Map<String, dynamic>> _getAllClinics() {
    return [
      {
        'id': '1',
        'name': 'عيادة طب الأسنان',
      },
      {
        'id': '2',
        'name': 'عيادة طب الأسرة',
      },
      {
        'id': '3',
        'name': 'عيادة الأمراض الجلدية',
      },
      {
        'id': '4',
        'name': 'عيادة الأنف والأذن والحنجرة',
      },
      {
        'id': '5',
        'name': 'عيادة طب العيون',
      },
      {
        'id': '6',
        'name': 'عيادة القلب',
      },
      {
        'id': '7',
        'name': 'عيادة الأطفال',
      },
      {
        'id': '8',
        'name': 'عيادة النساء والولادة',
      },
    ];
  }

  // TODO: Implement actual search/filter logic
  List<Map<String, dynamic>> _getFilteredClinics() {
    final allClinics = _getAllClinics();

    if (_searchQuery.isEmpty) {
      return allClinics;
    }

    return allClinics
        .where((clinic) => (clinic['name'] as String)
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  // TODO: Implement actual search API call
  void _performSearch(String query) {
    // This method will be called when user types in search
    // Implement your search API call here
    setState(() {
      // Update filtered list
    });
  }

  Map<String, dynamic>? _getClinicById(String id) {
    try {
      return _getAllClinics().firstWhere(
        (clinic) => clinic['id'] == id,
      );
    } catch (e) {
      return null;
    }
  }
}

