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

- **Default Theme:** Light mode
- **Theme Toggle:** Available in the upper right corner of all screens
- **Dark Mode Footer:** Dark green navigation bar in dark mode
- **Full Theme Support:** All screens and widgets adapt to theme changes

## Project Structure

lib/
├── core/ # Core utilities (responsive, accessibility, theme helpers)
├── screens/ # All app screens
│ ├── booking/ # Appointment booking flow screens
│ └── ...
├── theme/ # Theme configuration
├── widgets/ # Reusable widgets
│ ├── app_bar/ # App bar components
│ ├── buttons/ # Button widgets
│ ├── cards/ # Card widgets
│ ├── inputs/ # Input field widgets
│ └── navigation/ # Navigation components
└── main.dart # App entry point

markdown
Copy code

## Dependencies

- `provider: ^6.1.2` - State management
- `hijri_calendar: ^1.0.0` - Hijri calendar conversion
- `http` - REST API communication

---

# Backend Setup (for Appointment Booking & Health Records)

Some features in the application require dynamic backend data, including:

- Clinics
- Facilities
- Doctors
- Available time slots
- Appointments
- Health records

A lightweight JSON Server backend is used during development to provide these APIs.

## 1. Installing JSON Server

npm install -g json-server

markdown
Copy code

## 2. Starting the Backend

From the folder containing `db.json`, run:

json-server --watch db.json --port 3000

arduino
Copy code

The API will run at:

http://localhost:3000

csharp
Copy code

## 3. Automatic Platform-Based Base URL

The application adjusts the backend URL automatically depending on the platform:

| Platform        | Base URL Used        |
|-----------------|-----------------------|
| Windows Desktop | http://localhost:3000 |
| Android Emulator | http://10.0.2.2:3000  |

This behavior is managed through:

ApiConfig.baseUrl

csharp
Copy code

No manual modification is required when running on different devices.

## 4. API Endpoints Used by Appointment & Health Records Modules

GET /clinics
GET /facilities?clinicId={id}
GET /doctors?clinicId={id}&facilityId={id}
GET /time-slots
GET /appointments
POST /appointments
GET /health-records

yaml
Copy code

---

# Appointment and Data Features (Implementation Details)

The following components were implemented as part of the appointment and health-data workflow:

## Appointment Booking System

- Complete multi-step booking interface
- Dynamic filtering of clinics, facilities, and doctors
- Hijri/Gregorian calendar integration
- Automatic disabling of non-available days
- Internal filtering of time slots based on clinic, facility, doctor, and selected date
- Loading, empty, and error states for network operations
- Final appointment creation and submission to backend

## Forms and Data Validation

- Custom form inputs following the app’s design system
- Field validation for all data-entry steps
- Error messages and user-friendly form behavior

## Backend Communication Layer

A reusable service layer was developed to handle:

- Fetching clinics, facilities, and doctors
- Fetching available dates and time slots
- Creating appointments
- Retrieving and updating health records

This layer includes error handling, JSON parsing, and platform-adaptive API routing.

## Health Records Module

- Viewing and displaying health metrics (BMI, blood pressure, heart rate, height, weight, sugar level)
- Editing and updating health record values
- Full visual adaptation to light and dark themes

---

# Notes for Reviewers

The appointment booking and health-record modules require the backend server to be running.  
If the backend is not active, these features will show empty states or controlled error messages.

To run the backend and application:

json-server --watch db.json --port 3000
flutter run

yaml
Copy code

---

# Requirements

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio or VS Code with Flutter extensions installed

---

# License

This project is open source and available for use.