class Validators {
  Validators._();

  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _phone = RegExp(r'^\+?[0-9]{10,15}$');

  static const int minPasswordLength = 6;

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter your name';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || !_phone.hasMatch(value.trim())) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || !_email.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < minPasswordLength) {
      return 'Use at least $minPasswordLength characters';
    }
    return null;
  }
}
