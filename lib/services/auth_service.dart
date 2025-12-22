import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';
import '../models/auth_response.dart';
import 'token_storage_service.dart';

/// Authentication Service
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  /// Check if input is email or phone
  bool _isEmail(String input) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(input);
  }

  /// Login user with email or phone
  Future<AuthResponse> login({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      // Determine if input is email or phone
      final isEmail = _isEmail(emailOrPhone.trim());

      // Build request body with appropriate key
      final Map<String, dynamic> requestBody = {
        'password': password,
      };

      if (isEmail) {
        requestBody['email'] = emailOrPhone.trim();
      } else {
        requestBody['phone'] = emailOrPhone.trim();
      }

      final response = await ApiClient.instance.post(
        ApiEndpoints.login,
        body: requestBody,
        requireAuth: false, // Login doesn't need auth
      );

      if (response['success'] == true) {
        // Debug: Print raw response to see structure
        if (kDebugMode) {
          print('🔍 Raw Login Response:');
          print('  response keys: ${response.keys.toList()}');
          if (response['data'] != null) {
            final data = response['data'] as Map<String, dynamic>;
            print('  data keys: ${data.keys.toList()}');
            print('  token in data: ${data.containsKey('token')}');
            final tokenStr = data['token']?.toString() ?? 'NULL';
            final tokenPreview = tokenStr != 'NULL' && tokenStr.length > 20
                ? '${tokenStr.substring(0, 20)}...'
                : tokenStr;
            print('  token value: $tokenPreview');
            print(
                '  refresh_token in data: ${data.containsKey('refresh_token')}');
          }
        }

        final authResponse = AuthResponse.fromJson(response);

        print('🔐 Login successful - Parsing tokens...');
        print(
            '  Token from model: ${authResponse.token.isNotEmpty ? "${authResponse.token.substring(0, authResponse.token.length > 20 ? 20 : authResponse.token.length)}..." : "EMPTY"}');
        print('  Token length: ${authResponse.token.length}');
        print('  Refresh token length: ${authResponse.refreshToken.length}');

        if (authResponse.token.isEmpty) {
          print('❌ ERROR: Token is EMPTY after parsing!');
          print('💡 Check if API response contains token in data.token');
          throw Exception('Token is empty in response');
        }

        // Save tokens to cache (like Dio setTokenIntoHeaderAfterLogin)
        print('💾 Saving tokens to cache...');
        await TokenStorageService.instance.saveTokens(
          accessToken: authResponse.token,
          refreshToken: authResponse.refreshToken,
        );

        // Verify token was saved to cache
        print('🔍 Verifying token was saved to cache...');
        final savedToken = await TokenStorageService.instance.getAccessToken();
        if (savedToken != null && savedToken.isNotEmpty) {
          if (savedToken == authResponse.token) {
            print('✅ Token cached successfully');
            print('  Cached token length: ${savedToken.length}');
            print('  💡 Token is now available for all API requests');
          } else {
            print('❌ Token mismatch in cache!');
            print(
                '  Original: ${authResponse.token.substring(0, authResponse.token.length > 20 ? 20 : authResponse.token.length)}...');
            print(
                '  Cached: ${savedToken.substring(0, savedToken.length > 20 ? 20 : savedToken.length)}...');
          }
        } else {
          print('❌ Token cache verification failed');
          print('  savedToken is null: ${savedToken == null}');
          print('  savedToken is empty: ${savedToken?.isEmpty ?? true}');
          throw Exception('Failed to cache token after login');
        }

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
            final message =
                errorJson['message'] ?? errorJson['error'] ?? 'Login failed';
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
        requireAuth: false, // Register doesn't need auth
      );

      if (response['success'] == true) {
        final authResponse = AuthResponse.fromJson(response);

        print('🔐 Registration successful - Saving tokens...');
        print('  Token length: ${authResponse.token.length}');
        print('  Refresh token length: ${authResponse.refreshToken.length}');

        // Save tokens to cache
        print('💾 Saving tokens to cache...');
        await TokenStorageService.instance.saveTokens(
          accessToken: authResponse.token,
          refreshToken: authResponse.refreshToken,
        );

        // Verify token was cached
        final savedToken = await TokenStorageService.instance.getAccessToken();
        if (savedToken != null &&
            savedToken.isNotEmpty &&
            savedToken == authResponse.token) {
          print('✅ Token cached successfully (length: ${savedToken.length})');
        } else {
          print('❌ Token cache verification failed');
          throw Exception('Failed to cache token after registration');
        }

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
            final message = errorJson['message'] ??
                errorJson['error'] ??
                'Registration failed';
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
      // Use requireAuth: true to automatically add token from cache
      await ApiClient.instance.post(
        ApiEndpoints.logout,
        requireAuth: true,
      );
    } catch (e) {
      // Even if API call fails, clear cached tokens
      print('Logout API error: $e');
    } finally {
      // Always clear cached tokens (like _handleTokenExpiry)
      print('🗑️ Clearing cached tokens...');
      await TokenStorageService.instance.clearTokens();
      print('✅ Cached tokens cleared');
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
        requireAuth: false, // Forgot password doesn't need auth
      );

      if (response['success'] != true) {
        throw Exception(
            response['message'] ?? 'فشل إرسال رابط إعادة تعيين كلمة المرور');
      }
    } catch (e) {
      if (e is ApiException) {
        // Try to parse error message from response body
        try {
          final errorBody = e.message;
          final match = RegExp(r'\{.*\}').firstMatch(errorBody);
          if (match != null) {
            final errorJson = jsonDecode(match.group(0)!);
            final message = errorJson['message'] ??
                errorJson['error'] ??
                'فشل إرسال رابط إعادة تعيين كلمة المرور';
            throw Exception(message);
          }
        } catch (_) {}
        throw Exception(
            'فشل إرسال رابط إعادة تعيين كلمة المرور. يرجى المحاولة مرة أخرى');
      }
      rethrow;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await TokenStorageService.instance.isLoggedIn();
  }
}
