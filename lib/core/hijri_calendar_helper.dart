// Simple Hijri calendar conversion helper
// This is a basic implementation - for production, use a proper Hijri calendar library

class HijriDate {
  final int year;
  final int month;
  final int day;

  HijriDate({
    required this.year,
    required this.month,
    required this.day,
  });

  DateTime toGregorian() {
    // Approximate conversion (for accurate conversion, use a proper library)
    // This is a simplified version
    final gregorianYear = year + 579;
    final gregorianMonth = month;
    final gregorianDay = day;
    
    try {
      return DateTime(gregorianYear, gregorianMonth, gregorianDay);
    } catch (e) {
      return DateTime.now();
    }
  }

  int lengthOfMonth() {
    // Hijri months alternate between 29 and 30 days
    // Some months have specific lengths
    if (month == 12) {
      // Dhu al-Hijjah can be 29 or 30 days depending on the year
      return 30;
    }
    return (month % 2 == 1) ? 30 : 29;
  }

  static HijriDate fromGregorian(DateTime date) {
    // Approximate conversion
    final hijriYear = date.year - 579;
    final hijriMonth = date.month;
    final hijriDay = date.day;
    
    return HijriDate(
      year: hijriYear > 0 ? hijriYear : 1,
      month: hijriMonth > 0 && hijriMonth <= 12 ? hijriMonth : 1,
      day: hijriDay > 0 && hijriDay <= 30 ? hijriDay : 1,
    );
  }
}

