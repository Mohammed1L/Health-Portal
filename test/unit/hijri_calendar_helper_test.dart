import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/core/hijri_calendar_helper.dart';

void main() {
  group('HijriDate', () {
    test('should create HijriDate with valid values', () {
      final hijriDate = HijriDate(year: 1445, month: 6, day: 15);
      expect(hijriDate.year, 1445);
      expect(hijriDate.month, 6);
      expect(hijriDate.day, 15);
    });

    test('toGregorian should convert Hijri to Gregorian', () {
      final hijriDate = HijriDate(year: 1445, month: 1, day: 1);
      final gregorian = hijriDate.toGregorian();
      expect(gregorian.year, 2024); // 1445 + 579 = 2024 (approximate)
      expect(gregorian.month, 1);
      expect(gregorian.day, 1);
    });

    test('toGregorian should handle invalid dates gracefully', () {
      final hijriDate = HijriDate(year: 1445, month: 13, day: 35);
      final gregorian = hijriDate.toGregorian();
      expect(gregorian, isA<DateTime>());
    });

    test('lengthOfMonth should return correct length for odd months', () {
      final hijriDate = HijriDate(year: 1445, month: 1, day: 1);
      expect(hijriDate.lengthOfMonth(), 30);
    });

    test('lengthOfMonth should return correct length for even months', () {
      final hijriDate = HijriDate(year: 1445, month: 2, day: 1);
      expect(hijriDate.lengthOfMonth(), 29);
    });

    test('lengthOfMonth should return 30 for month 12', () {
      final hijriDate = HijriDate(year: 1445, month: 12, day: 1);
      expect(hijriDate.lengthOfMonth(), 30);
    });

    test('fromGregorian should convert Gregorian to Hijri', () {
      final gregorian = DateTime(2024, 1, 15);
      final hijriDate = HijriDate.fromGregorian(gregorian);
      expect(hijriDate.year, 1445); // 2024 - 579 = 1445
      expect(hijriDate.month, 1);
      expect(hijriDate.day, 15);
    });

    test('fromGregorian should handle edge cases', () {
      // Day 31 gets normalized to 1 because Hijri months max at 30 days
      final gregorian = DateTime(2024, 12, 31);
      final hijriDate = HijriDate.fromGregorian(gregorian);
      expect(hijriDate.month, 12); // December stays as 12
      expect(hijriDate.day, 1); // Day 31 is normalized to 1 (Hijri max is 30)
    });

    test('fromGregorian should handle negative years', () {
      final gregorian = DateTime(500, 1, 1);
      final hijriDate = HijriDate.fromGregorian(gregorian);
      expect(hijriDate.year, 1); // Should default to 1
    });
  });
}

