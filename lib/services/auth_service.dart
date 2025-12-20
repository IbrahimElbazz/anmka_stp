import 'dart:convert';
import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';
import '../models/auth_response.dart';
import 'token_storage_service.dart';

/// Authentication Service
class AuthService {
  AuthService._();
  
  static final AuthService instance = AuthService._();

  /// Login user
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        ApiEndpoints.login,
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response['success'] == true) {
        final authResponse = AuthResponse.fromJson(response);
        
        // Save tokens
        await TokenStorageService.instance.saveTokens(
          accessToken: authResponse.token,
          refreshToken: authResponse.refreshToken,
        );

        return authResponse;
      } else {
        throw Exception(response['message'] ?? 'Login failed');
      }
    } catch (e) {
      if (e is ApiException) {
        // Try to parse error message from response body
        try {
          final errorBody = e.message;
          final match = RegExp(r'\{.*\}').firstMatch(errorBody);
          if (match != null) {
            final errorJson = jsonDecode(match.group(0)!);
            final message = errorJson['message'] ?? errorJson['error'] ?? 'Login failed';
            throw Exception(message);
          }
        } catch (_) {}
        throw Exception('فشل تسجيل الدخول. تحقق من بيانات الاعتماد');
      }
      rethrow;
    }
  }

  /// Register user
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required bool acceptTerms,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        ApiEndpoints.register,
        body: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'accept_terms': acceptTerms,
        },
      );

      if (response['success'] == true) {
        final authResponse = AuthResponse.fromJson(response);
        
        // Save tokens
        await TokenStorageService.instance.saveTokens(
          accessToken: authResponse.token,
          refreshToken: authResponse.refreshToken,
        );

        return authResponse;
      } else {
        throw Exception(response['message'] ?? 'Registration failed');
      }
    } catch (e) {
      if (e is ApiException) {
        // Try to parse error message from response body
        try {
          final errorBody = e.message;
          final match = RegExp(r'\{.*\}').firstMatch(errorBody);
          if (match != null) {
            final errorJson = jsonDecode(match.group(0)!);
            final message = errorJson['message'] ?? errorJson['error'] ?? 'Registration failed';
            throw Exception(message);
          }
        } catch (_) {}
        throw Exception('فشل إنشاء الحساب. يرجى المحاولة مرة أخرى');
      }
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      final token = await TokenStorageService.instance.getAccessToken();
      if (token != null) {
        await ApiClient.instance.post(
          ApiEndpoints.logout,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
      }
    } catch (e) {
      // Even if API call fails, clear local tokens
      print('Logout API error: $e');
    } finally {
      // Always clear local tokens
      await TokenStorageService.instance.clearTokens();
    }
  }

  /// Forgot password - Send reset link to email
  Future<void> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        ApiEndpoints.forgotPassword,
        body: {
          'email': email,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'فشل إرسال رابط إعادة تعيين كلمة المرور');
      }
    } catch (e) {
      if (e is ApiException) {
        // Try to parse error message from response body
        try {
          final errorBody = e.message;
          final match = RegExp(r'\{.*\}').firstMatch(errorBody);
          if (match != null) {
            final errorJson = jsonDecode(match.group(0)!);
            final message = errorJson['message'] ?? errorJson['error'] ?? 'فشل إرسال رابط إعادة تعيين كلمة المرور';
            throw Exception(message);
          }
        } catch (_) {}
        throw Exception('فشل إرسال رابط إعادة تعيين كلمة المرور. يرجى المحاولة مرة أخرى');
      }
      rethrow;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await TokenStorageService.instance.isLoggedIn();
  }
}

