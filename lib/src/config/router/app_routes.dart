import 'package:hajjmate/src/features/auth/domain/entities/role.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String leaderHome = '/leader';
  static const String hajjiHome = '/hajji';

  static String homeFor(Role role) {
    return switch (role) {
      Role.leader => leaderHome,
      Role.hajji => hajjiHome,
    };
  }
}
