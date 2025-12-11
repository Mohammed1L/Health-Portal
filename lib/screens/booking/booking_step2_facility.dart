import 'package:flutter/material.dart';

import '../../widgets/inputs/app_text_field.dart';
import '../../widgets/cards/app_card.dart';
import '../../widgets/buttons/app_button.dart';

// NEW: استدعاء الـ service
import '../../services/facilities_service.dart';
import '../../core/constants/api_config.dart';

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

  // NEW: service + state
  final FacilitiesService _facilitiesService =
  FacilitiesService(baseUrl: ApiConfig.baseUrl); // عدّلها إذا احتجت

  List<Map<String, dynamic>> _allFacilities = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFacilities();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFacilities() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _allFacilities = [];
      _selectedFacilityId = null;
    });

    try {
      final facilities = await _facilitiesService.fetchFacilities(
        clinicId: widget.selectedClinicId,
      );

      if (!mounted) return;

      setState(() {
        _allFacilities = facilities;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
        'حدث خطأ أثناء جلب المنشآت. حاول مرة أخرى.';
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
      },
    );
  }

  Widget _buildFacilityList() {
    // NEW: حالات التحميل والخطأ
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
                color: Colors.red[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            AppButton(
              text: 'إعادة المحاولة',
              type: AppButtonType.secondary,
              size: AppButtonSize.medium,
              onPressed: _loadFacilities,
            ),
          ],
        ),
      );
    }

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
        final isSelected = _selectedFacilityId == facility['id'].toString();

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildFacilityCard(facility, isSelected),
        );
      },
    );
  }

  Widget _buildFacilityCard(Map<String, dynamic> facility, bool isSelected) {
    final name = facility['name'] as String? ?? '';
    final location = facility['location'] as String? ?? '';
    final distance = facility['distance']?.toString() ?? '';
    final rating = (facility['rating'] as num?)?.toDouble() ?? 0.0;

    return AppCard(
      isOutlined: true,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: isSelected ? const Color(0xFF00A86B) : Colors.grey[300]!,
        width: isSelected ? 2 : 1,
      ),
      onTap: () {
        setState(() {
          _selectedFacilityId = facility['id'].toString();
        });
        widget.onFacilitySelected(facility);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                _selectedFacilityId =
                value == true ? facility['id'].toString() : null;
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
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
          return const Icon(
            Icons.star,
            color: Color(0xFF00A86B),
            size: 16,
          );
        } else if (index < rating) {
          return const Icon(
            Icons.star,
            color: Color(0xFF00A86B),
            size: 16,
          );
        } else {
          return Icon(
            Icons.star_border,
            color: Colors.grey[400],
            size: 16,
          );
        }
      }),
    );
  }

  // فلترة المنشآت حسب البحث
  List<Map<String, dynamic>> _getFilteredFacilities() {
    if (_searchQuery.isEmpty) {
      return _allFacilities;
    }

    final query = _searchQuery.toLowerCase();

    return _allFacilities.where((facility) {
      final name = (facility['name'] ?? '').toString().toLowerCase();
      final location = (facility['location'] ?? '').toString().toLowerCase();
      return name.contains(query) || location.contains(query);
    }).toList();
  }
}
