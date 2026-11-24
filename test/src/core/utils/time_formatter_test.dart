import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/utils/time_formatter.dart';

void main() {
  group('TimeFormatter.ago', () {
    final now = DateTime(2026, 11, 25, 12);

    test('says just now under a minute', () {
      expect(
        TimeFormatter.ago(now.subtract(const Duration(seconds: 40)), now: now),
        'just now',
      );
    });

    test('counts minutes, hours and days', () {
      expect(
        TimeFormatter.ago(now.subtract(const Duration(minutes: 3)), now: now),
        '3 min ago',
      );
      expect(
        TimeFormatter.ago(now.subtract(const Duration(hours: 5)), now: now),
        '5 h ago',
      );
      expect(
        TimeFormatter.ago(now.subtract(const Duration(days: 2)), now: now),
        '2 d ago',
      );
    });
  });
}
