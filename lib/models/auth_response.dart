import 'user.dart';

/// Authentication Response Model
class AuthResponse {
  final bool success;
  final String? message;
  final User user;
  final String token;
  final String refreshToken;
  final String? expiresAt;

  AuthResponse({
    required this.success,
    this.message,
    required this.user,
    required this.token,
    required this.refreshToken,
    this.expiresAt,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final userData = data['user'] as Map<String, dynamic>? ?? {};

    return AuthResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      user: User.fromJson(userData),
      token: data['token'] as String? ?? '',
      refreshToken: data['refresh_token'] as String? ?? '',
      expiresAt: data['expires_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'user': user.toJson(),
        'token': token,
        'refresh_token': refreshToken,
        'expires_at': expiresAt,
      },
    };
  }
}

