class AppConstants {
  AppConstants._();

  static const String appName = 'HajjMate';
  static const String packageName = 'com.sazzad.hajjmate';

  static const String defaultGroupId = 'default';

  static const double minZoneRadiusM = 100;
  static const double defaultZoneRadiusM = 150;
  static const int maxZonesPerGroup = 10;

  /// With a bad connection the splash screen gives up and shows sign in.
  static const Duration sessionCheckTimeout = Duration(seconds: 10);

  static const Duration locationUpdateInterval = Duration(seconds: 30);

  /// A location older than this is shown as out of date.
  static const Duration staleLocationAfter = Duration(minutes: 2);
}
