import 'package:flutter/material.dart';

import '../../widgets/inputs/app_text_field.dart';
import '../../widgets/cards/app_card.dart';

// NEW: service
import '../../services/doctors_service.dart';
import '../../core/constants/api_config.dart';

class BookingStep3Doctor extends StatefulWidget {
  final Function(Map<String, dynamic>) onDoctorSelected;
  final String? selectedClinicId; // Clinic selected in step 1
  final String? selectedFacilityId; // Facility selected in step 2

  const BookingStep3Doctor({
    super.key,
    required this.onDoctorSelected,
    this.selectedClinicId,
    this.selectedFacilityId,
  });

  @override
  State<BookingStep3Doctor> createState() => _BookingStep3DoctorState();
}

class _BookingStep3DoctorState extends State<BookingStep3Doctor> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedDoctorId;

  // NEW: service + state
  final DoctorsService _doctorsService =
  DoctorsService(baseUrl: ApiConfig.baseUrl); // عدّلها لو احتجت

  List<Map<String, dynamic>> _allDoctors = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctors() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _allDoctors = [];
      _selectedDoctorId = null;
    });

    try {
      final doctors = await _doctorsService.fetchDoctors(
        clinicId: widget.selectedClinicId,
        facilityId: widget.selectedFacilityId,
      );

      if (!mounted) return;

      setState(() {
        _allDoctors = doctors;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'حدث خطأ أثناء جلب الأطباء. حاول مرة أخرى.';
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
            'اختر الطبيب',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildSearchBar(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildDoctorList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return AppTextField(
      controller: _searchController,
      hintText: 'البحث عن طبيب',
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

  Widget _buildDoctorList() {
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
            ElevatedButton(
              onPressed: _loadDoctors,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003C71),
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    final doctors = _getFilteredDoctors();

    if (doctors.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد أطباء متاحون',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        final isSelected = _selectedDoctorId == doctor['id'].toString();

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildDoctorCard(doctor, isSelected),
        );
      },
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor, bool isSelected) {
    final name = doctor['name'] as String? ?? '';
    final rating = (doctor['rating'] as num?)?.toDouble() ?? 0.0;
    final specialization = doctor['specialization'] as String? ?? '';

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
          _selectedDoctorId = doctor['id'].toString();
        });
        widget.onDoctorSelected(doctor);
      },
      child: Row(
        children: [
          // avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF00A86B),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFF00A86B),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          // details
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
                  specialization,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                _buildStarRating(rating),
              ],
            ),
          ),
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                _selectedDoctorId =
                value == true ? doctor['id'].toString() : null;
              });
              if (value == true) {
                widget.onDoctorSelected(doctor);
              }
            },
            activeColor: const Color(0xFF00A86B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
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
            size: 18,
          );
        } else if (index < rating) {
          return const Icon(
            Icons.star,
            color: Color(0xFF00A86B),
            size: 18,
          );
        } else {
          return Icon(
            Icons.star_border,
            color: Colors.grey[400],
            size: 18,
          );
        }
      }),
    );
  }

  List<Map<String, dynamic>> _getFilteredDoctors() {
    if (_searchQuery.isEmpty) {
      return _allDoctors;
    }

    final query = _searchQuery.toLowerCase();

    return _allDoctors.where((doctor) {
      final name = (doctor['name'] ?? '').toString().toLowerCase();
      final specialization =
      (doctor['specialization'] ?? '').toString().toLowerCase();
      return name.contains(query) || specialization.contains(query);
    }).toList();
  }
}
