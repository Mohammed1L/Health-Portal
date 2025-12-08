import 'package:flutter/material.dart';
import '../../widgets/inputs/app_text_field.dart';
import '../../widgets/cards/app_card.dart';

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
        // TODO: Implement search logic
        _performSearch(value);
      },
    );
  }

  Widget _buildDoctorList() {
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
        final isSelected = _selectedDoctorId == doctor['id'];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildDoctorCard(doctor, isSelected),
        );
      },
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor, bool isSelected) {
    final name = doctor['name'] as String;
    final rating = doctor['rating'] as double;

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
          _selectedDoctorId = doctor['id'] as String;
        });
        // Notify parent of selection
        widget.onDoctorSelected(doctor);
      },
      child: Row(
        children: [
          // Profile icon/avatar
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
          // Doctor details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor name
                Text(
                  name,
                  style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
                // Star rating
                _buildStarRating(rating),
              ],
            ),
          ),
          // Checkbox
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                _selectedDoctorId = value! ? doctor['id'] as String : null;
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
          // Filled star
          return const Icon(
            Icons.star,
            color: Color(0xFF00A86B),
            size: 18,
          );
        } else if (index < rating) {
          // Half star (we'll use filled for simplicity)
          return const Icon(
            Icons.star,
            color: Color(0xFF00A86B),
            size: 18,
          );
        } else {
          // Empty star
          return Icon(
            Icons.star_border,
            color: Colors.grey[400],
            size: 18,
          );
        }
      }),
    );
  }

  // TODO: Replace with actual API call to fetch doctors based on selected clinic and facility
  List<Map<String, dynamic>> _getAllDoctors() {
    // This should filter doctors based on widget.selectedClinicId and widget.selectedFacilityId
    return [
      {
        'id': '1',
        'name': 'د. أحمد محمد',
        'rating': 5.0,
        'specialization': 'طب الأسنان',
      },
      {
        'id': '2',
        'name': 'د. فاطمة علي',
        'rating': 4.0,
        'specialization': 'طب الأسرة',
      },
      {
        'id': '3',
        'name': 'د. خالد سعيد',
        'rating': 5.0,
        'specialization': 'الأمراض الجلدية',
      },
      {
        'id': '4',
        'name': 'د. سارة أحمد',
        'rating': 4.5,
        'specialization': 'الأنف والأذن والحنجرة',
      },
      {
        'id': '5',
        'name': 'د. محمد حسن',
        'rating': 5.0,
        'specialization': 'طب العيون',
      },
    ];
  }

  // TODO: Implement actual search/filter logic
  List<Map<String, dynamic>> _getFilteredDoctors() {
    final allDoctors = _getAllDoctors();

    if (_searchQuery.isEmpty) {
      return allDoctors;
    }

    return allDoctors
        .where((doctor) {
          final name = (doctor['name'] as String).toLowerCase();
          final specialization = (doctor['specialization'] as String).toLowerCase();
          final query = _searchQuery.toLowerCase();
          return name.contains(query) || specialization.contains(query);
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

