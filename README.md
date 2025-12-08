# البوابة الصحية - Health Portal App

A Flutter application for managing health appointments, medical records, medications, and vaccinations with a beautiful UI/UX and full light/dark theme support.

## Features

- **User Authentication** - Login screen with secure password handling
- **Appointment Management** - Book, view, and manage medical appointments
- **Health Records** - View personal health metrics and measurements
- **Medication Tracking** - Schedule and log medications with calendar view
- **Vaccination Records** - Track vaccination history
- **Results Management** - View lab and radiology results
- **Insurance Information** - Manage insurance details and approvals
- **Light/Dark Theme** - Full theme support with toggle button
- **Responsive Design** - Works on mobile, tablet, and desktop
- **RTL Support** - Right-to-left text direction for Arabic

## Screens

- **Login Screen** - User authentication
- **Home Screen** - Dashboard with next appointment and results
- **Appointments Screen** - View and book appointments
- **Results Screen** - Lab and radiology results
- **Profile Screen** - User profile and health file
- **More Screen** - Settings and additional options

## Booking Flow

Multi-step appointment booking process:
1. Select Clinic
2. Select Facility
3. Select Doctor
4. Select Date & Time (with Hijri calendar support)
5. Review & Confirm

## Theme System

- **Default Theme**: Light mode
- **Theme Toggle**: Available in the upper right corner of all screens
- **Dark Mode Footer**: Dark green navigation bar in dark mode
- **Full Theme Support**: All screens and widgets adapt to theme changes

## Project Structure

```
lib/
├── core/              # Core utilities (responsive, accessibility, theme helpers)
├── screens/           # All app screens
│   ├── booking/       # Appointment booking flow screens
│   └── ...
├── theme/             # Theme configuration
├── widgets/           # Reusable widgets
│   ├── app_bar/       # App bar components
│   ├── buttons/        # Button widgets
│   ├── cards/          # Card widgets
│   ├── inputs/         # Input field widgets
│   └── navigation/     # Navigation components
└── main.dart          # App entry point
```

## Dependencies

- `provider: ^6.1.2` - State management
- `hijri_calendar: ^1.0.0` - Hijri calendar conversion

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Requirements

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

## License

This project is open source and available for use.
