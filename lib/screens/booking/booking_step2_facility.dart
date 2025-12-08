import 'package:flutter/material.dart';
import '../../widgets/inputs/app_text_field.dart';
import '../../widgets/cards/app_card.dart';

class BookingStep2Facility extends StatefulWidget {
  final Function(Map<String, dynamic>) onFacilitySelected;
  final String? selectedClinicId; // Clinic selected in previous step

  const BookingStep2Facility({
    super.key,
    required this.onFacilitySelected,
    this.selectedClinicId,
  });

  @override
  State<BookingStep2Facility> createState() => _BookingStep2FacilityState();
}

class _BookingStep2FacilityState extends State<BookingStep2Facility> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedFacilityId;

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
            'اختر المنشأة:',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 16),
          _buildSearchBar(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildFacilityList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return AppTextField(
      controller: _searchController,
      hintText: 'البحث عن منشأة',
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

  Widget _buildFacilityList() {
    final facilities = _getFilteredFacilities();

    if (facilities.isEmpty) {
      return Center(
        child: Text(
          'لا توجد منشآت متاحة',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: facilities.length,
      itemBuilder: (context, index) {
        final facility = facilities[index];
        final isSelected = _selectedFacilityId == facility['id'];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildFacilityCard(facility, isSelected),
        );
      },
    );
  }

  Widget _buildFacilityCard(Map<String, dynamic> facility, bool isSelected) {
    final name = facility['name'] as String;
    final location = facility['location'] as String;
    final distance = facility['distance'] as String;
    final rating = facility['rating'] as double;

    return AppCard(
      isOutlined: true,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: isSelected
            ? const Color(0xFF00A86B)
            : Colors.grey[300]!,
        width: isSelected ? 2 : 1,
      ),
      onTap: () {
        setState(() {
          _selectedFacilityId = facility['id'] as String;
        });
        // Notify parent of selection
        widget.onFacilitySelected(facility);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                _selectedFacilityId = value! ? facility['id'] as String : null;
              });
              if (value == true) {
                widget.onFacilitySelected(facility);
              }
            },
            activeColor: const Color(0xFF00A86B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          // Facility details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Facility name
                Text(
                  name,
                  style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 4),
                // Location
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                // Distance and Rating row
                Row(
                  children: [
                    // Distance
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFF00A86B),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          distance,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF00A86B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Rating stars
                    _buildStarRating(rating),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          // Filled star
          return const Icon(
            Icons.star,
            color: Color(0xFF00A86B),
            size: 16,
          );
        } else if (index < rating) {
          // Half star (we'll use filled for simplicity)
          return const Icon(
            Icons.star,
            color: Color(0xFF00A86B),
            size: 16,
          );
        } else {
          // Empty star
          return Icon(
            Icons.star_border,
            color: Colors.grey[400],
            size: 16,
          );
        }
      }),
    );
  }

  // TODO: Replace with actual API call to fetch facilities based on selected clinic
  List<Map<String, dynamic>> _getAllFacilities() {
    // This should filter facilities based on widget.selectedClinicId
    return [
      {
        'id': '1',
        'name': 'حي جلمودة',
        'location': 'الجبيل',
        'distance': '5.23 كم',
        'rating': 5.0,
      },
      {
        'id': '2',
        'name': 'حي أحد',
        'location': 'الدمام',
        'distance': '77.25 كم',
        'rating': 3.0,
      },
      {
        'id': '3',
        'name': 'حي الدوحة الجنوبية',
        'location': 'الظهران',
        'distance': '89.23 كم',
        'rating': 4.0,
      },
      {
        'id': '4',
        'name': 'حي الفيصلية',
        'location': 'الرياض',
        'distance': '120.5 كم',
        'rating': 4.5,
      },
      {
        'id': '5',
        'name': 'حي النور',
        'location': 'جدة',
        'distance': '250.8 كم',
        'rating': 5.0,
      },
    ];
  }

  // TODO: Implement actual search/filter logic
  List<Map<String, dynamic>> _getFilteredFacilities() {
    final allFacilities = _getAllFacilities();

    if (_searchQuery.isEmpty) {
      return allFacilities;
    }

    return allFacilities
        .where((facility) {
          final name = (facility['name'] as String).toLowerCase();
          final location = (facility['location'] as String).toLowerCase();
          final query = _searchQuery.toLowerCase();
          return name.contains(query) || location.contains(query);
        })
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
}

