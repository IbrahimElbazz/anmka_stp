import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';

/// Service for exams
class ExamsService {
  ExamsService._();
  
  static final ExamsService instance = ExamsService._();

  /// Get exam details
  Future<Map<String, dynamic>> getExamDetails(String examId) async {
    try {
      final response = await ApiClient.instance.get(
        ApiEndpoints.exam(examId),
        requireAuth: true,
      );
      
      if (response['success'] == true && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch exam details');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Start exam
  Future<Map<String, dynamic>> startExam(String examId) async {
    try {
      final response = await ApiClient.instance.post(
        ApiEndpoints.startExam(examId),
        requireAuth: true,
      );
      
      if (response['success'] == true && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      } else {
        throw Exception(response['message'] ?? 'Failed to start exam');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Submit exam
  Future<Map<String, dynamic>> submitExam(
    String examId, {
    required String attemptId,
    required List<Map<String, dynamic>> answers,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        ApiEndpoints.submitExam(examId),
        body: {
          'attempt_id': attemptId,
          'answers': answers,
        },
        requireAuth: true,
      );
      
      if (response['success'] == true && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      } else {
        throw Exception(response['message'] ?? 'Failed to submit exam');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get user exams
  Future<Map<String, dynamic>> getMyExams() async {
    try {
      final response = await ApiClient.instance.get(
        ApiEndpoints.exams,
        requireAuth: true,
      );
      
      if (response['success'] == true && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch exams');
      }
    } catch (e) {
      rethrow;
    }
  }
}

