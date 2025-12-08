import 'package:flutter/material.dart';
import 'booking_step1_clinic.dart';
import 'booking_step2_facility.dart';
import 'booking_step3_doctor.dart';
import 'booking_step4_date_time.dart';
import 'booking_step5_review.dart';

enum BookingStep {
  clinic, // Step 1: Choose Clinic
  facility, // Step 2: Choose Facility
  doctor, // Step 3: Choose Doctor
  date, // Step 4: Choose Date/Time
  review, // Step 5: Review and Confirm
}

class BookingFlowScreen extends StatefulWidget {
  const BookingFlowScreen({super.key});

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  BookingStep _currentStep = BookingStep.clinic;
  final int _totalSteps = 5; // Total number of steps (Clinic, Facility, Doctor, Date/Time, Review)

  // Store booking data as user progresses
  final Map<String, dynamic> _bookingData = {};

  void _goToNextStep() {
    setState(() {
      switch (_currentStep) {
        case BookingStep.clinic:
          _currentStep = BookingStep.facility;
          break;
        case BookingStep.facility:
          _currentStep = BookingStep.doctor;
          break;
        case BookingStep.doctor:
          _currentStep = BookingStep.date;
          break;
        case BookingStep.date:
          _currentStep = BookingStep.review;
          break;
        case BookingStep.review:
          // This should not be called, review step handles confirmation
          break;
      }
    });
  }

  void _goToStep(BookingStep step) {
    setState(() {
      _currentStep = step;
    });
  }

  void _goToPreviousStep() {
    setState(() {
      switch (_currentStep) {
        case BookingStep.clinic:
          Navigator.of(context).pop();
          break;
        case BookingStep.facility:
          _currentStep = BookingStep.clinic;
          break;
        case BookingStep.doctor:
          _currentStep = BookingStep.facility;
          break;
        case BookingStep.date:
          _currentStep = BookingStep.doctor;
          break;
        case BookingStep.review:
          _currentStep = BookingStep.date;
          break;
      }
    });
  }

  void _updateBookingData(String key, dynamic value) {
    setState(() {
      _bookingData[key] = value;
    });
  }

  void _submitBooking() {
    // TODO: Implement booking submission logic
    // This will be handled by the backend team
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حجز الموعد بنجاح'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }

  int _getCurrentStepNumber() {
    switch (_currentStep) {
      case BookingStep.clinic:
        return 1;
      case BookingStep.facility:
        return 2;
      case BookingStep.doctor:
        return 3;
      case BookingStep.date:
        return 4;
      case BookingStep.review:
        return 5;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildProgressIndicator(),
              Expanded(
                child: _buildCurrentStep(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _goToPreviousStep,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          Expanded(
            child: Text(
              'حجز موعد',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final currentStepNumber = _getCurrentStepNumber();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'خطوة $currentStepNumber من $_totalSteps',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF00A86B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              _totalSteps,
              (index) => Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(
                    right: index < _totalSteps - 1 ? 4 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: index < currentStepNumber
                        ? const Color(0xFF00A86B)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case BookingStep.clinic:
        return BookingStep1Clinic(
          onClinicSelected: (clinic) {
            _updateBookingData('clinic', clinic);
            _goToNextStep();
          },
        );
      case BookingStep.facility:
        return BookingStep2Facility(
          selectedClinicId: _bookingData['clinic']?['id'] as String?,
          onFacilitySelected: (facility) {
            _updateBookingData('facility', facility);
            // Auto-advance to next step when facility is selected
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                _goToNextStep();
              }
            });
          },
        );
      case BookingStep.doctor:
        return BookingStep3Doctor(
          selectedClinicId: _bookingData['clinic']?['id'] as String?,
          selectedFacilityId: _bookingData['facility']?['id'] as String?,
          onDoctorSelected: (doctor) {
            _updateBookingData('doctor', doctor);
            // Auto-advance to next step when doctor is selected
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                _goToNextStep();
              }
            });
          },
        );
      case BookingStep.date:
        return BookingStep4DateTime(
          selectedClinicId: _bookingData['clinic']?['id'] as String?,
          selectedFacilityId: _bookingData['facility']?['id'] as String?,
          selectedDoctorId: _bookingData['doctor']?['id'] as String?,
          onDateTimeSelected: (date, time) {
            _updateBookingData('date', date);
            _updateBookingData('time', time);
            // Go to review step after date and time selection
            _goToNextStep();
          },
        );
      case BookingStep.review:
        return BookingStep5Review(
          bookingData: _bookingData,
          onChangeStep: (stepName) {
            // Navigate to the step the user wants to change
            switch (stepName) {
              case 'clinic':
                _goToStep(BookingStep.clinic);
                break;
              case 'facility':
                _goToStep(BookingStep.facility);
                break;
              case 'doctor':
                _goToStep(BookingStep.doctor);
                break;
              case 'date':
                _goToStep(BookingStep.date);
                break;
            }
          },
          onConfirmBooking: _submitBooking,
        );
    }
  }

}

