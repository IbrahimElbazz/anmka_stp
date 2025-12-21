import 'package:flutter/foundation.dart';
import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';

/// Service for courses, categories, and enrollments
class CoursesService {
  CoursesService._();
  
  static final CoursesService instance = CoursesService._();

  /// Get all courses with filters
  Future<Map<String, dynamic>> getCourses({
    int page = 1,
    int perPage = 20,
    String? search,
    String? categoryId,
    String? subcategoryId,
    String? instructorId,
    String price = 'all', // all, free, paid
    String level = 'all', // all, beginner, intermediate, advanced
    String sort = 'newest', // newest, popular, rating, price_low, price_high
    String duration = 'all', // all, short, medium, long
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'per_page': perPage.toString(),
        'price': price,
        'level': level,
        'sort': sort,
        'duration': duration,
      };

      // Add optional parameters only if they have non-empty values
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }

      if (categoryId != null && categoryId.trim().isNotEmpty) {
        queryParams['category_id'] = categoryId.trim();
      }

      if (subcategoryId != null && subcategoryId.trim().isNotEmpty) {
        queryParams['subcategory_id'] = subcategoryId.trim();
      }

      if (instructorId != null && instructorId.trim().isNotEmpty) {
        queryParams['instructor_id'] = instructorId.trim();
      }

      // Build URL manually to match API expectations
      // API expects search and category_id even if empty
      final baseUrl = ApiEndpoints.courses;
      final queryParts = <String>[];
      
      queryParts.add('page=${page.toString()}');
      queryParts.add('per_page=${perPage.toString()}');
      queryParts.add('search=${search != null && search.trim().isNotEmpty ? Uri.encodeComponent(search.trim()) : ''}');
      queryParts.add('category_id=${categoryId != null && categoryId.trim().isNotEmpty ? Uri.encodeComponent(categoryId.trim()) : ''}');
      
      if (subcategoryId != null && subcategoryId.trim().isNotEmpty) {
        queryParts.add('subcategory_id=${Uri.encodeComponent(subcategoryId.trim())}');
      }
      
      if (instructorId != null && instructorId.trim().isNotEmpty) {
        queryParts.add('instructor_id=${Uri.encodeComponent(instructorId.trim())}');
      }
      
      queryParts.add('price=$price');
      queryParts.add('level=$level');
      queryParts.add('sort=$sort');
      queryParts.add('duration=$duration');
      
      final finalUrl = '$baseUrl?${queryParts.join('&')}';

      if (kDebugMode) {
        print('🔍 Courses API Request:');
        print('  URL: $finalUrl');
        print('  Query Params: $queryParams');
      }

      final response = await ApiClient.instance.get(
        finalUrl,
        requireAuth: false,
      );
      
      if (response['success'] == true) {
        return response;
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch courses');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get course details
  Future<Map<String, dynamic>> getCourseDetails(String courseId) async {
    try {
      final response = await ApiClient.instance.get(
        ApiEndpoints.course(courseId),
        requireAuth: false,
      );
      
      if (response['success'] == true && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch course details');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get lesson details
  Future<Map<String, dynamic>> getLessonDetails(
    String courseId,
    String lessonId,
  ) async {
    try {
      final response = await ApiClient.instance.get(
        ApiEndpoints.courseLesson(courseId, lessonId),
        requireAuth: true,
      );
      
      if (response['success'] == true && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch lesson details');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Update lesson progress
  Future<Map<String, dynamic>> updateLessonProgress(
    String courseId,
    String lessonId, {
    required int watchedSeconds,
    required bool isCompleted,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        ApiEndpoints.courseLessonProgress(courseId, lessonId),
        body: {
          'watched_seconds': watchedSeconds,
          'is_completed': isCompleted,
        },
        requireAuth: true,
      );
      
      if (response['success'] == true) {
        return response['data'] as Map<String, dynamic>;
      } else {
        throw Exception(response['message'] ?? 'Failed to update lesson progress');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get all categories
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await ApiClient.instance.get(
        ApiEndpoints.categories,
        requireAuth: false,
      );
      
      if (response['success'] == true && response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data'] as List);
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch categories');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get category courses
  Future<Map<String, dynamic>> getCategoryCourses(
    String categoryId, {
    int page = 1,
    int perPage = 20,
    String sort = 'newest',
    String price = 'all',
    String level = 'all',
    String? subcategoryId,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'per_page': perPage.toString(),
        'sort': sort,
        'price': price,
        'level': level,
        if (subcategoryId != null && subcategoryId.isNotEmpty) 
          'subcategory_id': subcategoryId,
      };

      final queryString = Uri(queryParameters: queryParams).query;
      final url = '${ApiEndpoints.categoryCourses(categoryId)}?$queryString';

      final response = await ApiClient.instance.get(
        url,
        requireAuth: false,
      );
      
      if (response['success'] == true) {
        return response;
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch category courses');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Enroll in a course
  Future<Map<String, dynamic>> enrollInCourse(String courseId) async {
    try {
      final response = await ApiClient.instance.post(
        ApiEndpoints.enrollCourse(courseId),
        requireAuth: true,
      );
      
      if (response['success'] == true) {
        return response['data'] as Map<String, dynamic>;
      } else {
        throw Exception(response['message'] ?? 'Failed to enroll in course');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get user enrollments
  Future<Map<String, dynamic>> getEnrollments({
    String status = 'all', // all, in_progress, completed
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final queryParams = <String, String>{
        'status': status,
        'page': page.toString(),
        'per_page': perPage.toString(),
      };

      final queryString = Uri(queryParameters: queryParams).query;
      final url = '${ApiEndpoints.enrollments}?$queryString';

      final response = await ApiClient.instance.get(
        url,
        requireAuth: true,
      );
      
      if (response['success'] == true) {
        return response;
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch enrollments');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get course reviews
  Future<Map<String, dynamic>> getCourseReviews(
    String courseId, {
    int page = 1,
    int perPage = 20,
    int? rating,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'per_page': perPage.toString(),
        if (rating != null) 'rating': rating.toString(),
      };

      final queryString = Uri(queryParameters: queryParams).query;
      final url = '${ApiEndpoints.courseReviews(courseId)}?$queryString';

      final response = await ApiClient.instance.get(
        url,
        requireAuth: false,
      );
      
      if (response['success'] == true) {
        return response;
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch reviews');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Add course review
  Future<Map<String, dynamic>> addCourseReview(
    String courseId, {
    required int rating,
    required String title,
    required String comment,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        ApiEndpoints.courseReviews(courseId),
        body: {
          'rating': rating,
          'title': title,
          'comment': comment,
        },
        requireAuth: true,
      );
      
      if (response['success'] == true) {
        return response['data'] as Map<String, dynamic>;
      } else {
        throw Exception(response['message'] ?? 'Failed to add review');
      }
    } catch (e) {
      rethrow;
    }
  }
}

