import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';

/// Service for fetching home page data
class HomeService {
  HomeService._();
  
  static final HomeService instance = HomeService._();

  /// Fetch home page data
  Future<Map<String, dynamic>> getHomeData() async {
    try {
      final response = await ApiClient.instance.get(
        ApiEndpoints.home,
        requireAuth: true,
      );
      
      // Log home response
      if (kDebugMode) {
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        print('🏠 HOME API RESPONSE');
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        try {
          final prettyJson = const JsonEncoder.withIndent('  ').convert(response);
          print(prettyJson);
        } catch (e) {
          print('Response: $response');
        }
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        
        // Log specific data sections
        if (response['data'] != null) {
          final data = response['data'] as Map<String, dynamic>;
          print('📊 Home Data Summary:');
          print('  - User Summary: ${data['user_summary'] != null ? "✓" : "✗"}');
          print('  - Hero Banner: ${data['hero_banner'] != null ? "✓" : "✗"}');
          print('  - Categories Count: ${(data['categories'] as List?)?.length ?? 0}');
          print('  - Featured Courses Count: ${(data['featured_courses'] as List?)?.length ?? 0}');
          print('  - Popular Courses Count: ${(data['popular_courses'] as List?)?.length ?? 0}');
          print('  - Continue Learning Count: ${(data['continue_learning'] as List?)?.length ?? 0}');
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        }
      }
      
      if (response['success'] == true && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch home data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Home API Error: $e');
      }
      rethrow;
    }
  }
}

