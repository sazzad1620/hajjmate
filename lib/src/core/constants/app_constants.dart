class AppConstants {
  AppConstants._();

  static const String appName = 'HajjMate';

  static const String defaultGroupId = 'default';

  static const double minZoneRadiusM = 100;
  static const double defaultZoneRadiusM = 150;
  static const int maxZonesPerGroup = 10;

  static const Duration locationUpdateInterval = Duration(seconds: 30);
}
