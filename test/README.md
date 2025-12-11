# Test Suite Documentation

This directory contains comprehensive test suites for the Health Portal Flutter application.

## Test Structure

```
test/
├── unit/              # Unit tests for business logic
│   ├── theme_provider_test.dart
│   ├── hijri_calendar_helper_test.dart
│   ├── appointment_model_test.dart
│   ├── health_record_model_test.dart
│   ├── responsive_test.dart
│   └── appointments_service_test.dart
├── widget/             # Widget tests for UI components
│   ├── app_button_test.dart
│   ├── app_card_test.dart
│   ├── app_text_field_test.dart
│   ├── theme_toggle_button_test.dart
│   └── login_screen_test.dart
├── integration/       # Integration tests for user flows
│   └── app_test.dart
└── widget_test.dart   # Main widget test file
```

## Running Tests

### Run all tests
```bash
flutter test
```

### Run specific test file
```bash
flutter test test/unit/theme_provider_test.dart
```

### Run all unit tests
```bash
flutter test test/unit/
```

### Run all widget tests
```bash
flutter test test/widget/
```

### Run integration tests
```bash
flutter test integration_test/app_test.dart
```

### Run with coverage
```bash
flutter test --coverage
```

## Test Categories

### Unit Tests
- **ThemeProvider**: Tests theme switching functionality
- **HijriCalendarHelper**: Tests Hijri calendar conversions
- **Models**: Tests data models (Appointment, HealthRecord)
- **Responsive**: Tests responsive design utilities
- **Services**: Tests API service classes

### Widget Tests
- **AppButton**: Tests button widget with different types and sizes
- **AppCard**: Tests card widget with various configurations
- **AppTextField**: Tests text input field widget
- **ThemeToggleButton**: Tests theme toggle functionality
- **LoginScreen**: Tests login screen UI and interactions

### Integration Tests
- **App Flow**: Tests complete user flows
- **Navigation**: Tests navigation between screens
- **Theme Toggle**: Tests theme switching in real app context

## Writing New Tests

### Unit Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/your_file.dart';

void main() {
  group('YourClass', () {
    test('should do something', () {
      // Arrange
      final instance = YourClass();
      
      // Act
      final result = instance.doSomething();
      
      // Assert
      expect(result, expectedValue);
    });
  });
}
```

### Widget Test Example
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/widgets/your_widget.dart';

void main() {
  testWidgets('should display widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: YourWidget(),
      ),
    );
    
    expect(find.text('Expected Text'), findsOneWidget);
  });
}
```

## Dependencies

The following testing packages are used:
- `flutter_test`: Built-in Flutter testing framework
- `integration_test`: For integration testing
- `mockito`: For mocking (if needed)
- `http_mock_adapter`: For HTTP mocking (if needed)

## Best Practices

1. **Test Coverage**: Aim for at least 80% code coverage
2. **Test Naming**: Use descriptive test names that explain what is being tested
3. **Arrange-Act-Assert**: Structure tests with clear sections
4. **Isolation**: Each test should be independent and not rely on other tests
5. **Mocking**: Use mocks for external dependencies (APIs, databases, etc.)
6. **Edge Cases**: Test both happy paths and error cases

## Continuous Integration

Tests should be run automatically in CI/CD pipelines:
- On every pull request
- Before merging to main branch
- On scheduled basis

