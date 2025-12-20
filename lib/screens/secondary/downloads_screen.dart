import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_text_styles.dart';
import '../../core/design/app_radius.dart';

/// Downloads Screen - Pixel-perfect match to React version
/// Matches: components/screens/downloads-screen.tsx
class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  // Static data matching React exactly
  static const _downloadedCourses = [
    {
      'id': 1,
      'title': 'أساسيات تصميم واجهات المستخدم',
      'lessons': 22,
      'downloadedLessons': 22,
      'size': '1.2 GB',
      'status': 'complete',
      'image': 'assets/images/motion-graphics-course-in-mumbai.png',
    },
    {
      'id': 2,
      'title': 'البرمجة بلغة بايثون',
      'lessons': 30,
      'downloadedLessons': 18,
      'size': '850 MB',
      'status': 'partial',
      'image': 'assets/images/motion-pro-thumbnail.jpg',
    },
    {
      'id': 3,
      'title': 'الفيزياء الحديثة',
      'lessons': 15,
      'downloadedLessons': 15,
      'size': '650 MB',
      'status': 'complete',
      'image': 'assets/images/Full_HD_Cover_2d_to_3d.png',
    },
  ];

  static const double _totalStorage = 5; // GB
  static const double _usedStorage = 2.7; // GB

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header - Purple gradient like Home
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
                ),
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
                        'التحميلات',
                        style: AppTextStyles.h3(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // mb-4
                  // Download count - matches React: gap-2
                  Row(
                    children: [
                      Icon(
                        Icons.download,
                        size: 20, // w-5 h-5
                        color: Colors.white.withOpacity(0.7), // white/70
                      ),
                      const SizedBox(width: 8), // gap-2
                      Text(
                        '${_downloadedCourses.length} دورات محملة',
                        style: AppTextStyles.bodyMedium(
                          color: Colors.white.withOpacity(0.7), // white/70
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content - matches React: px-4 -mt-4 space-y-4
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -16), // -mt-4
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16), // px-4
                  child: Column(
                    children: [
                      // Storage Card - matches React: bg-white rounded-3xl p-5 shadow-lg
                      Container(
                        margin: const EdgeInsets.only(bottom: 16), // space-y-4
                        padding: const EdgeInsets.all(20), // p-5
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(24), // rounded-3xl
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Storage icon and info - matches React: gap-3 mb-4
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 16), // mb-4
                              child: Row(
                                children: [
                                  Container(
                                    width: 48, // w-12
                                    height: 48, // h-12
                                    decoration: BoxDecoration(
                                      color: AppColors.purple.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(
                                          12), // rounded-xl
                                    ),
                                    child: const Icon(
                                      Icons.storage,
                                      size: 24, // w-6 h-6
                                      color: AppColors.purple,
                                    ),
                                  ),
                                  const SizedBox(width: 12), // gap-3
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'مساحة التخزين',
                                          style: AppTextStyles.bodyMedium(
                                            color: AppColors.foreground,
                                          ).copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '$_usedStorage GB من $_totalStorage GB مستخدم',
                                          style: AppTextStyles.bodySmall(
                                            color: AppColors.mutedForeground,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Progress bar - matches React: h-3 bg-gray-100 rounded-full
                            Container(
                              height: 12, // h-3
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius:
                                    BorderRadius.circular(999), // rounded-full
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerRight,
                                widthFactor: _usedStorage / _totalStorage,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.purple,
                                        AppColors.orange
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Downloaded Courses List
                      ..._downloadedCourses.asMap().entries.map((entry) {
                        final index = entry.key;
                        final course = entry.value;
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 400 + (index * 100)),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(
                                opacity: value,
                                child: child,
                              ),
                            );
                          },
                          child: _buildDownloadCard(course),
                        );
                      }),

                      // Empty state
                      if (_downloadedCourses.isEmpty) _buildEmptyState(),

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

  Widget _buildDownloadCard(Map<String, dynamic> course) {
    final isComplete = course['status'] == 'complete';
    final lessons = course['lessons'] as int;
    final downloadedLessons = course['downloadedLessons'] as int;
    final progress = downloadedLessons / lessons;

    return Container(
      margin: const EdgeInsets.only(bottom: 12), // space-y-3
      padding: const EdgeInsets.all(16), // p-4
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // rounded-2xl
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
          // Course info row - matches React: flex items-center gap-4
          Row(
            children: [
              // Course image - matches React: w-16 h-16 rounded-xl
              Container(
                width: 64, // w-16
                height: 64, // h-16
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), // rounded-xl
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    course['image'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.purple.withOpacity(0.1),
                      child: const Icon(
                        Icons.image,
                        color: AppColors.purple,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16), // gap-4

              // Course info - matches React: flex-1
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'] as String,
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.foreground,
                      ).copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4), // mb-1
                    Row(
                      children: [
                        Text(
                          '$downloadedLessons/$lessons درس',
                          style: AppTextStyles.labelSmall(
                            color: AppColors.mutedForeground,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: AppTextStyles.labelSmall(
                            color: AppColors.mutedForeground,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          course['size'] as String,
                          style: AppTextStyles.labelSmall(
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                    // Partial download progress bar
                    if (!isComplete) ...[
                      const SizedBox(height: 8), // mt-2
                      Container(
                        height: 6, // h-1.5
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerRight,
                          widthFactor: progress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.orange,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Action buttons - matches React: flex flex-col gap-2
              Column(
                children: [
                  // Status/Download button - matches React: w-10 h-10 rounded-xl
                  if (isComplete)
                    Container(
                      width: 40, // w-10
                      height: 40, // h-10
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12), // rounded-xl
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: 20, // w-5 h-5
                        color: Colors.green[600],
                      ),
                    )
                  else
                    Container(
                      width: 40, // w-10
                      height: 40, // h-10
                      decoration: BoxDecoration(
                        color: AppColors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12), // rounded-xl
                      ),
                      child: const Icon(
                        Icons.download,
                        size: 20, // w-5 h-5
                        color: AppColors.orange,
                      ),
                    ),
                  const SizedBox(height: 8), // gap-2
                  // Delete button - matches React: w-10 h-10 rounded-xl bg-red-50
                  Container(
                    width: 40, // w-10
                    height: 40, // h-10
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12), // rounded-xl
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 20, // w-5 h-5
                      color: Colors.red[500],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12), // mt-3

          // Play button - matches React: w-full py-3 rounded-xl bg-[var(--purple)]
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12), // py-3
            decoration: BoxDecoration(
              color: AppColors.purple,
              borderRadius: BorderRadius.circular(12), // rounded-xl
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.play_arrow,
                  size: 20, // w-5 h-5
                  color: Colors.white,
                ),
                const SizedBox(width: 8), // gap-2
                Text(
                  'مشاهدة بدون إنترنت',
                  style: AppTextStyles.bodyMedium(
                    color: Colors.white,
                  ).copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96, // w-24
            height: 96, // h-24
            decoration: const BoxDecoration(
              color: AppColors.lavenderLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.download,
              size: 48, // w-12 h-12
              color: AppColors.purple,
            ),
          ),
          const SizedBox(height: 16), // mb-4
          Text(
            'لا توجد تحميلات',
            style: AppTextStyles.h4(
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 8), // mb-2
          Text(
            'حمّل الدورات لمشاهدتها بدون إنترنت',
            style: AppTextStyles.bodyMedium(
              color: AppColors.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
