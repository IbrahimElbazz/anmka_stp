import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_radius.dart';
import '../../core/navigation/route_names.dart';
import '../../widgets/bottom_nav.dart';

/// Enrolled Screen - My Courses with Modern Design
class EnrolledScreen extends StatelessWidget {
  const EnrolledScreen({super.key});

  static final _enrolledCourses = [
    {
      'id': 1,
      'title': 'مقدمة في الجبر',
      'category': 'الرياضيات',
      'progress': 75,
      'lessons': 12,
      'completedLessons': 9,
      'icon': '📐',
      'instructor': 'أحمد محمد',
      'rating': 4.8,
      'hours': 24,
      'image': 'assets/images/motion-graphics-course-in-mumbai.png',
      'lastViewed': 'منذ ساعتين',
      'currentLesson': 'الدرس 9: المعادلات التربيعية',
    },
    {
      'id': 2,
      'title': 'أساسيات البرمجة',
      'category': 'علوم الحاسب',
      'progress': 45,
      'lessons': 20,
      'completedLessons': 9,
      'icon': '💻',
      'instructor': 'سارة أحمد',
      'rating': 4.9,
      'hours': 36,
      'image': 'assets/images/motion-pro-thumbnail.jpg',
      'lastViewed': 'أمس',
      'currentLesson': 'الدرس 9: الحلقات التكرارية',
    },
    {
      'id': 3,
      'title': 'الفيزياء الحديثة',
      'category': 'الفيزياء',
      'progress': 30,
      'lessons': 15,
      'completedLessons': 5,
      'icon': '⚛️',
      'instructor': 'محمد علي',
      'rating': 4.7,
      'hours': 28,
      'image': 'assets/images/Full_HD_Cover_2d_to_3d.png',
      'lastViewed': 'منذ 3 أيام',
      'currentLesson': 'الدرس 5: نظرية النسبية',
    },
  ];

  void _handleOpenCourse(BuildContext context, Map<String, dynamic> course) {
    final courseData = {
      ...course,
      'isFree': true,
      'price': 0.0,
      'students': 500,
      'lessons': [
        {
          'id': 1,
          'title': 'المقدمة',
          'duration': '5 دقائق',
          'completed': true,
          'locked': false,
          'youtubeVideoId': 'AevtORdu4pc'
        },
        {
          'id': 2,
          'title': 'الدرس الأول',
          'duration': '15 دقيقة',
          'completed': true,
          'locked': false,
          'youtubeVideoId': 'AevtORdu4pc'
        },
        {
          'id': 3,
          'title': 'الدرس الثاني',
          'duration': '20 دقيقة',
          'completed': false,
          'locked': false,
          'youtubeVideoId': 'AevtORdu4pc'
        },
        {
          'id': 4,
          'title': 'الدرس الثالث',
          'duration': '18 دقيقة',
          'completed': false,
          'locked': false,
          'youtubeVideoId': 'AevtORdu4pc'
        },
      ],
    };
    context.push(RouteNames.courseDetails, extra: courseData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              _buildHeader(context),

              // Content
              Expanded(
                child: _enrolledCourses.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 140),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _enrolledCourses.length,
                        itemBuilder: (context, index) {
                          final course = _enrolledCourses[index];
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration:
                                Duration(milliseconds: 400 + (index * 100)),
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
                            child: _buildCourseCard(context, course),
                          );
                        },
                      ),
              ),
            ],
          ),
          // Bottom Navigation
          const BottomNav(activeTab: 'enrolled'),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final totalProgress = _enrolledCourses.isEmpty
        ? 0
        : (_enrolledCourses
                    .map((c) => c['progress'] as int)
                    .reduce((a, b) => a + b) /
                _enrolledCourses.length)
            .round();

    return Container(
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
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            children: [
              // Title Row
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'دوراتي',
                          style: GoogleFonts.cairo(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${_enrolledCourses.length} دورات مسجلة',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stats Row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.play_circle_fill_rounded,
                        value: '${_enrolledCourses.length}',
                        label: 'دورات',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.check_circle_rounded,
                        value: '$totalProgress%',
                        label: 'متوسط التقدم',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.emoji_events_rounded,
                        value:
                            '${_enrolledCourses.where((c) => (c['progress'] as int) == 100).length}',
                        label: 'مكتملة',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
      {required IconData icon, required String value, required String label}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 11,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCard(BuildContext context, Map<String, dynamic> course) {
    final progress = course['progress'] as int;
    final progressColor = progress >= 70
        ? const Color(0xFF10B981)
        : progress >= 40
            ? const Color(0xFFF59E0B)
            : AppColors.purple;

    return GestureDetector(
      onTap: () => _handleOpenCourse(context, course),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.purple.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Minimalist Header with gradient overlay
            Container(
              height: 90,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    progressColor.withOpacity(0.15),
                    progressColor.withOpacity(0.05),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Course Icon/Emoji
                  Positioned(
                    right: 20,
                    top: 20,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: progressColor.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          course['icon'] as String? ?? '📚',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  // Progress Circle
                  Positioned(
                    left: 20,
                    top: 15,
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background circle
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(
                              value: progress / 100,
                              strokeWidth: 5,
                              backgroundColor: Colors.white,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(progressColor),
                            ),
                          ),
                          // Progress text
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$progress',
                                style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: progressColor,
                                ),
                              ),
                              Text(
                                '%',
                                style: GoogleFonts.cairo(
                                  fontSize: 10,
                                  color: progressColor.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Category Badge
                  Positioned(
                    left: 90,
                    top: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: progressColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        course['category'] as String,
                        style: GoogleFonts.cairo(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: progressColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Course Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    course['title'] as String,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Instructor & Rating
                  Row(
                    children: [
                      Icon(Icons.person_outline_rounded,
                          size: 14, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        course['instructor'] as String,
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        '${course['rating']}',
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Progress Bar (Slim Design)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerRight,
                            widthFactor: progress / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    progressColor.withOpacity(0.6),
                                    progressColor
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${course['completedLessons']}/${course['lessons']}',
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Current Lesson Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.beige,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                progressColor.withOpacity(0.2),
                                progressColor.withOpacity(0.1)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.play_arrow_rounded,
                              color: progressColor, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'متابعة التعلم',
                                style: GoogleFonts.cairo(
                                  fontSize: 10,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                              Text(
                                course['currentLesson'] as String,
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.foreground,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: progressColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_back_ios_rounded,
                              color: Colors.white, size: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Footer Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniStat(
                          Icons.access_time_rounded, '${course['hours']}س'),
                      _buildMiniStat(Icons.play_lesson_rounded,
                          '${course['lessons']} درس'),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.update_rounded,
                                size: 12, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              course['lastViewed'] as String,
                              style: GoogleFonts.cairo(
                                fontSize: 10,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[400]),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 11,
            color: AppColors.mutedForeground,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.purple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.school_rounded,
                size: 60, color: AppColors.purple),
          ),
          const SizedBox(height: 24),
          Text(
            'لم تشترك في أي دورة بعد',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ رحلة التعلم واشترك في دورتك الأولى',
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => context.go(RouteNames.home),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purple.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'استكشف الدورات',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
