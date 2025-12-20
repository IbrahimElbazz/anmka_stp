/// API Endpoints Configuration
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://stp.anmka.com/v1';

  // App Configuration
  static String get appConfig => '$baseUrl/config/app';

  // Authentication
  static String get login => '$baseUrl/auth/login';
  static String get register => '$baseUrl/auth/register';
  static String get logout => '$baseUrl/auth/logout';
  static String get forgotPassword => '$baseUrl/auth/forgot-password';
  static String get refreshToken => '$baseUrl/auth/refresh';
}
