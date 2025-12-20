import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_text_styles.dart';
import '../../core/design/app_radius.dart';

/// My Exams Screen - Pixel-perfect match to React version
/// Matches: components/screens/my-exams-screen.tsx
class MyExamsScreen extends StatelessWidget {
  const MyExamsScreen({super.key});

  // Static data matching React exactly
  static const _completedExams = [
    {
      'id': 1,
      'title': 'اختبار تصميم واجهات المستخدم',
      'score': 85,
      'totalQuestions': 20,
      'correctAnswers': 17,
      'passed': true,
      'date': '15 ديسمبر 2024',
    },
    {
      'id': 2,
      'title': 'اختبار أساسيات البرمجة',
      'score': 92,
      'totalQuestions': 25,
      'correctAnswers': 23,
      'passed': true,
      'date': '10 ديسمبر 2024',
    },
    {
      'id': 3,
      'title': 'اختبار الرياضيات المتقدمة',
      'score': 45,
      'totalQuestions': 30,
      'correctAnswers': 14,
      'passed': false,
      'date': '5 ديسمبر 2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final passedCount = _completedExams.where((e) => e['passed'] == true).length;
    final failedCount = _completedExams.where((e) => e['passed'] != true).length;

    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header - matches React: bg-[var(--orange)] rounded-b-[3rem] pt-4 pb-8 px-4
            Container(
              decoration: BoxDecoration(
                color: AppColors.orange, // Orange header!
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppRadius.largeCard),
                  bottomRight: Radius.circular(AppRadius.largeCard),
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16, // pt-4
                bottom: 32, // pb-8
                left: 16, // px-4
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button and title - matches React: gap-4 mb-4
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 40, // w-10
                          height: 40, // h-10
                          decoration: BoxDecoration(
                            color: AppColors.whiteOverlay20, // bg-white/20
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 20, // w-5 h-5
                          ),
                        ),
                      ),
                      const SizedBox(width: 16), // gap-4
                      Text(
                        'اختباراتي',
                        style: AppTextStyles.h2(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // mb-4
                  Text(
                    'عرض جميع الاختبارات المكتملة',
                    style: AppTextStyles.bodyMedium(
                      color: Colors.white.withOpacity(0.7), // white/70
                    ),
                  ),
                ],
              ),
            ),

            // Content - matches React: px-4 -mt-6 mb-6 then space-y-4
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -24), // -mt-6
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16), // px-4
                  child: Column(
                    children: [
                      // Stats Card - matches React: bg-white rounded-3xl p-5 shadow-lg grid grid-cols-3
                      Container(
                        margin: const EdgeInsets.only(bottom: 24), // mb-6
                        padding: const EdgeInsets.all(20), // p-5
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24), // rounded-3xl
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Total exams
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '${_completedExams.length}',
                                    style: AppTextStyles.h2(
                                      color: AppColors.purple,
                                    ),
                                  ),
                                  Text(
                                    'إجمالي الاختبارات',
                                    style: AppTextStyles.labelSmall(
                                      color: AppColors.mutedForeground,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            // Passed
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '$passedCount',
                                    style: AppTextStyles.h2(
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    'ناجح',
                                    style: AppTextStyles.labelSmall(
                                      color: AppColors.mutedForeground,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            // Failed
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '$failedCount',
                                    style: AppTextStyles.h2(
                                      color: Colors.red,
                                    ),
                                  ),
                                  Text(
                                    'راسب',
                                    style: AppTextStyles.labelSmall(
                                      color: AppColors.mutedForeground,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Exams List - matches React: space-y-4
                      ..._completedExams.map((exam) => _buildExamCard(exam)),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamCard(Map<String, dynamic> exam) {
    final passed = exam['passed'] == true;
    final score = exam['score'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 16), // space-y-4
      padding: const EdgeInsets.all(20), // p-5
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // rounded-3xl
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header row - matches React: flex items-start gap-4
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status icon - matches React: w-14 h-14 rounded-2xl
              Container(
                width: 56, // w-14
                height: 56, // h-14
                decoration: BoxDecoration(
                  color: passed ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(16), // rounded-2xl
                ),
                child: Icon(
                  passed ? Icons.check_circle : Icons.cancel,
                  size: 28, // w-7 h-7
                  color: passed ? Colors.green[600] : Colors.red[600],
                ),
              ),
              const SizedBox(width: 16), // gap-4
              // Exam info - matches React: flex-1
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam['title'] as String,
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.foreground,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4), // mb-1
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16, // w-4 h-4
                          color: AppColors.mutedForeground,
                        ),
                        const SizedBox(width: 8), // gap-2
                        Text(
                          exam['date'] as String,
                          style: AppTextStyles.bodySmall(
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Score - matches React: text-left
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$score%',
                    style: AppTextStyles.h2(
                      color: passed ? Colors.green[600] : Colors.red[600],
                    ),
                  ),
                  Text(
                    '${exam['correctAnswers']}/${exam['totalQuestions']}',
                    style: AppTextStyles.labelSmall(
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16), // mt-4

          // Progress bar - matches React: h-2 bg-gray-100 rounded-full
          Container(
            height: 8, // h-2
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(999), // rounded-full
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerRight,
              widthFactor: score / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: passed ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12), // mt-3

          // Status badge - matches React: flex justify-end
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12, // px-3
                vertical: 4, // py-1
              ),
              decoration: BoxDecoration(
                color: passed ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(999), // rounded-full
              ),
              child: Text(
                passed ? 'ناجح' : 'راسب',
                style: AppTextStyles.labelSmall(
                  color: passed ? Colors.green[700] : Colors.red[700],
                ).copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
