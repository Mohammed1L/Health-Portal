# البوابة الصحية - Health Portal App

A comprehensive Flutter application for managing health appointments, medical records, medications, and vaccinations with a beautiful UI/UX and full light/dark theme support.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Backend Setup](#backend-setup)
- [Running the Project](#running-the-project)
- [Testing](#testing)
- [Project Structure](#project-structure)
- [Dependencies](#dependencies)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Features

- **User Authentication** - Login screen with secure password handling
- **Appointment Management** - Book, view, and manage medical appointments
- **Health Records** - View personal health metrics and measurements
- **Medication Tracking** - Schedule and log medications with calendar view
- **Medication Management** - Manage the list of medications, dosage, and time of day
- **Medication Reminders** - Enable or disable reminders and track remaining daily doses
- **Vaccination Records** - Track vaccination history
- **Results Management** - View lab and radiology results
- **Insurance Information** - Manage insurance details and approvals
- **Light/Dark Theme** - Full theme support with toggle button
- **Responsive Design** - Works on mobile, tablet, and desktop
- **RTL Support** - Right-to-left text direction for Arabic
- **Hijri Calendar** - Support for both Hijri and Gregorian calendars

## Prerequisites

Before you begin, ensure you have the following installed:

### Required Software

1. **Flutter SDK** (latest stable version)
   - Download from: https://flutter.dev/docs/get-started/install
   - Minimum version: Flutter 3.9.2
   - Verify installation: `flutter --version`

2. **Dart SDK** (comes with Flutter)
   - Verify installation: `dart --version`

3. **Node.js and npm** (for backend JSON server)
   - Download from: https://nodejs.org/
   - Verify installation: `node --version` and `npm --version`

4. **Development IDE** (choose one)
   - **Android Studio** with Flutter plugin
   - **VS Code** with Flutter and Dart extensions
   - **IntelliJ IDEA** with Flutter plugin

### Platform-Specific Requirements

#### For Android Development
- Android Studio
- Android SDK (API level 21 or higher)
- Android Emulator or physical device

#### For iOS Development (macOS only)
- Xcode (latest version)
- CocoaPods: `sudo gem install cocoapods`
- iOS Simulator or physical device

#### For Web Development
- Chrome browser (recommended)

#### For Windows Development
- Visual Studio 2019 or later with "Desktop development with C++" workload

#### For Linux Development
- Clang
- CMake
- GTK development headers

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/Mohammed1L/Health-Portal.git
cd Health-Portal
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

This will install all the required packages listed in `pubspec.yaml`.

### 3. Verify Flutter Setup

```bash
flutter doctor
```

Ensure all required components are installed and configured correctly.

### 4. Install JSON Server (for Backend)

```bash
npm install -g json-server
```

This installs the JSON server globally, which is used to run the mock backend API.

## Backend Setup

The application uses a JSON Server backend for development. This provides mock APIs for:
- Clinics
- Facilities
- Doctors
- Available time slots
- Appointments
- Health records
- Medications

### Starting the Backend Server

1. Navigate to the project root directory (where `db.json` is located)

2. Start the JSON server:

```bash
json-server --watch db.json --port 3000
```

The API will be available at:
- **Local/Web**: `http://localhost:3000`
- **Android Emulator**: `http://10.0.2.2:3000` (automatically configured)
- **iOS Simulator**: `http://localhost:3000`

### API Endpoints

The following endpoints are used by the application:

- `GET /clinics` - Get list of clinics
- `GET /facilities?clinicId={id}` - Get facilities for a clinic
- `GET /doctors?clinicId={id}&facilityId={id}` - Get doctors
- `GET /time-slots` - Get available time slots
- `GET /appointments?status={upcoming|previous}` - Get appointments
- `POST /appointments` - Create new appointment
- `GET /health-records` - Get health records
- `GET /medications` - Get medications list (for schedule and log)
- `POST /medications` - Add a new medication
- `PUT /medications/:id` - Update medication reminder and details

### Automatic Platform-Based Base URL

The application automatically adjusts the backend URL based on the platform:

| Platform        | Base URL Used        |
|-----------------|----------------------|
| Web             | http://localhost:3000|
| Windows Desktop | http://localhost:3000|
| macOS Desktop   | http://localhost:3000|
| Linux Desktop   | http://localhost:3000|
| Android Emulator| http://10.0.2.2:3000 |
| iOS Simulator   | http://localhost:3000|
| Physical Device | http://[your-ip]:3000|

This is handled automatically by `lib/core/constants/api_config.dart`.

## Running the Project

### 1. Start the Backend Server

In a terminal, start the JSON server:

```bash
json-server --watch db.json --port 3000
```

Keep this terminal running while developing.

### 2. Run the Flutter App

In a new terminal, run:

```bash
# For default device
flutter run

# For specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

### Platform-Specific Commands

#### Android
```bash
flutter run -d android
# or
flutter run -d <android-emulator-name>
```

#### iOS (macOS only)
```bash
flutter run -d ios
# or
flutter run -d <ios-simulator-name>
```

#### Web
```bash
flutter run -d chrome
# or
flutter run -d web-server
```

#### Windows
```bash
flutter run -d windows
```

#### Linux
```bash
flutter run -d linux
```

#### macOS
```bash
flutter run -d macos
```

### Build Commands

#### Android APK
```bash
flutter build apk
# or for app bundle
flutter build appbundle
```

#### iOS (macOS only)
```bash
flutter build ios
```

#### Web
```bash
flutter build web
```

#### Windows
```bash
flutter build windows
```

#### Linux
```bash
flutter build linux
```

#### macOS
```bash
flutter build macos
```

## Testing

The project includes comprehensive test suites:

### Run All Tests

```bash
flutter test
```

### Run Specific Test Suites

```bash
# Unit tests only
flutter test test/unit/

# Widget tests only
flutter test test/widget/

# Integration tests
flutter test integration_test/
```

### Run Tests with Coverage

```bash
flutter test --coverage
```

### Test Structure

- **Unit Tests** (`test/unit/`) - Business logic, models, services
- **Widget Tests** (`test/widget/`) - UI components and screens
- **Integration Tests** (`test/integration/`) - End-to-end user flows

See `test/README.md` for detailed testing documentation.

## Project Structure

```
lib/
├── assets/              # Images and other assets
│   └── image.png       # App logo
├── core/                # Core utilities
│   ├── constants/      # API configuration
│   ├── accessibility.dart
│   ├── hijri_calendar_helper.dart
│   ├── responsive.dart
│   └── theme_helper.dart
├── models/             # Data models
│   ├── appointment.dart
│   ├── health_record.dart
│   └── medication.dart
├── screens/            # App screens
│   ├── booking/        # Booking flow screens
│   │   ├── booking_flow_screen.dart
│   │   ├── booking_step1_clinic.dart
│   │   ├── booking_step2_facility.dart
│   │   ├── booking_step3_doctor.dart
│   │   ├── booking_step4_date_time.dart
│   │   └── booking_step5_review.dart
│   ├── appointments_screen.dart
│   ├── health_record_screen.dart
│   ├── home_screen.dart
│   ├── insurance_approvals_screen.dart
│   ├── insurance_info_screen.dart
│   ├── login_screen.dart
│   ├── main_navigation_screen.dart
│   ├── medications_screen.dart
│   ├── add_medication_screen.dart
│   ├── more_screen.dart
│   ├── profile_details_screen.dart
│   ├── profile_screen.dart
│   ├── results_screen.dart
│   └── vaccinations_screen.dart
├── services/           # API services
│   ├── appointments_service.dart
│   ├── booking_lookup_service.dart
│   ├── doctors_service.dart
│   ├── facilities_service.dart
│   ├── health_record_service.dart
│   └── medications_service.dart
├── theme/              # Theme configuration
│   ├── app_theme.dart
│   └── theme_provider.dart
├── widgets/            # Reusable widgets
│   ├── app_bar/
│   │   └── theme_toggle_button.dart
│   ├── buttons/
│   │   └── app_button.dart
│   ├── cards/
│   │   └── app_card.dart
│   ├── inputs/
│   │   ├── app_password_field.dart
│   │   └── app_text_field.dart
│   └── navigation/
│       └── bottom_nav_bar.dart
├── firebase_options.dart
└── main.dart           # App entry point
```

## Dependencies

### Main Dependencies

- `flutter` - Flutter SDK
- `provider: ^6.1.2` - State management
- `http: ^1.2.0` - HTTP client for API calls
- `firebase_core: ^3.0.0` - Firebase integration

### Dev Dependencies

- `flutter_test` - Testing framework
- `integration_test` - Integration testing
- `flutter_lints: ^5.0.0` - Linting rules
- `build_runner: ^2.10.4` - Code generation
- `mockito: ^5.4.4` - Mocking for tests (optional)
- `http_mock_adapter: ^0.6.1` - HTTP mocking for tests (optional)

## Configuration

### API Configuration

The API base URL is automatically configured based on the platform. To modify it, edit:

`lib/core/constants/api_config.dart`

### Theme Configuration

Theme settings can be modified in:

`lib/theme/app_theme.dart` - Theme colors and styles
`lib/theme/theme_provider.dart` - Theme state management

### Assets

Add new assets to `pubspec.yaml`:

```yaml
flutter:
  assets:
    - lib/assets/image.png
    - lib/assets/your-new-asset.png
```

Then run:
```bash
flutter pub get
```

## Screens

### Main Screens

1. **Login Screen** - User authentication
2. **Home Screen** - Dashboard with next appointment and results
3. **Appointments Screen** - View and book appointments
4. **Results Screen** - Lab and radiology results
5. **Profile Screen** - User profile and health file
6. **More Screen** - Settings and additional options

### Booking Flow

Multi-step appointment booking process:

1. **Step 1: Select Clinic** - Choose from available clinics
2. **Step 2: Select Facility** - Choose facility within selected clinic
3. **Step 3: Select Doctor** - Choose doctor from facility
4. **Step 4: Select Date & Time** - Choose date (Hijri/Gregorian) and time slot
5. **Step 5: Review & Confirm** - Review selections and confirm booking

### Profile Sub-screens

- **Profile Details** - Personal information
- **Health Record** - Health metrics and measurements
- **Medications** - Medication schedule, daily doses, and reminder toggles
- **Vaccinations** - Vaccination records
- **Insurance Information** - Insurance policy details
- **Insurance Approvals** - Approval requests and status

### Medications and Reminder System

- The medications module allows users to view their medication schedule by day, see remaining doses for the selected date, and review a full medication log.
- Users can enable or disable reminders for each medication using a toggle switch, which updates the backend through MedicationsService.
- New medications can be added via a dedicated form that collects name, brand, dosage, and time of day, then sends them to the backend.
- This module is implemented mainly in:
   - `lib/models/medication.dart`
   - `lib/services/medications_service.dart`
   - `lib/screens/medications_screen.dart`
   - `lib/screens/add_medication_screen.dart`
     and corresponds to the task: Building the medication management and reminder system.

## Theme System

- **Default Theme:** Light mode
- **Theme Toggle:** Available in the upper right corner of all screens
- **Dark Mode Footer:** Dark green navigation bar in dark mode
- **Full Theme Support:** All screens and widgets adapt to theme changes

## Troubleshooting

### Common Issues

#### 1. Platform._operatingSystem Error

**Error:** `Unsupported operation: Platform._operatingSystem`

**Solution:** This has been fixed. The app now uses Flutter's `defaultTargetPlatform` instead of `dart:io`'s `Platform` class.

#### 2. Backend Connection Issues

**Problem:** App can't connect to backend

**Solutions:**
- Ensure JSON server is running: `json-server --watch db.json --port 3000`
- Check if port 3000 is available
- For Android emulator, ensure using `10.0.2.2:3000` (handled automatically)
- For physical devices, use your computer's IP address

#### 3. Flutter Pub Get Fails

**Problem:** `flutter pub get` fails with errors

**Solutions:**
```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Update Flutter
flutter upgrade

# Check Flutter doctor
flutter doctor
```

#### 4. Build Errors

**Problem:** Build fails on specific platform

**Solutions:**
- **Android:** Ensure Android SDK is properly installed
- **iOS:** Run `pod install` in `ios/` directory
- **Web:** Ensure Chrome is installed
- **Windows:** Install Visual Studio with C++ workload
- **Linux:** Install required development packages

#### 5. Tests Failing

**Problem:** Some tests fail

**Solutions:**
- Run `flutter test` to see specific errors
- Some responsive tests may need MediaQuery setup adjustments
- Check `test/README.md` for test documentation

#### 6. Theme Not Working

**Problem:** Theme toggle doesn't work

**Solutions:**
- Ensure `ThemeProvider` is wrapped around `MaterialApp`
- Check `lib/main.dart` for proper setup
- Verify `ChangeNotifierProvider` is used

### Development Workflow

#### 1. Start Development

```bash
# Terminal 1: Start backend
json-server --watch db.json --port 3000

# Terminal 2: Run Flutter app
flutter run
```

#### 2. Hot Reload

While the app is running:
- Press `r` in the terminal for hot reload
- Press `R` for hot restart
- Press `q` to quit

#### 3. Code Formatting

```bash
# Format all Dart files
dart format .

# Or use Flutter format
flutter format .
```

#### 4. Analyze Code

```bash
flutter analyze
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style

- Follow Dart style guide: https://dart.dev/guides/language/effective-dart/style
- Run `flutter analyze` before committing
- Write tests for new features
- Update documentation as needed

## License

This project is open source and available for use.

## Support

For issues and questions:
- Open an issue on GitHub: https://github.com/Mohammed1L/Health-Portal/issues
- Check the documentation in `test/README.md` for testing
- Review `test/TEST_SUMMARY.md` for test coverage

## Acknowledgments

- Flutter team for the amazing framework
- All contributors and testers

---

**Note:** TNote: This app uses JSON Server as the backend during development.
Ensure that the JSON mock server (db.json) is running for appointments, health records, and medications to load correctly.