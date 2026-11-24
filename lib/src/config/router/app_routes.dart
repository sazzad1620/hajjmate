import 'package:hajjmate/src/features/auth/domain/entities/role.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';

  static const String leaderMap = '/leader/map';
  static const String leaderZones = '/leader/zones';
  static const String leaderAlerts = '/leader/alerts';
  static const String leaderMore = '/leader/more';

  static const String hajjiHome = '/hajji/home';
  static const String hajjiMap = '/hajji/map';
  static const String hajjiProfile = '/hajji/profile';

  static String homeFor(Role role) {
    return switch (role) {
      Role.leader => leaderMap,
      Role.hajji => hajjiHome,
    };
  }
}
