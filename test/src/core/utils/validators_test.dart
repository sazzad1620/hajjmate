import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/utils/validators.dart';

void main() {
  group('Validators', () {
    test('name rejects empty text', () {
      expect(Validators.name('  '), isNotNull);
      expect(Validators.name('Rahim'), isNull);
    });

    test('phone accepts digits with an optional plus', () {
      expect(Validators.phone('01712345678'), isNull);
      expect(Validators.phone('+966501234567'), isNull);
      expect(Validators.phone('12345'), isNotNull);
      expect(Validators.phone('01712-345678'), isNotNull);
    });

    test('email needs an @ and a domain', () {
      expect(Validators.email('rahim@example.com'), isNull);
      expect(Validators.email('rahim@example'), isNotNull);
      expect(Validators.email(''), isNotNull);
    });

    test('password needs at least 6 characters', () {
      expect(Validators.password('abcdef'), isNull);
      expect(Validators.password('abcde'), isNotNull);
    });
  });
}
