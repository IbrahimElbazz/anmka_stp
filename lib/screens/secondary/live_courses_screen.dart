import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_text_styles.dart';
import '../../core/design/app_radius.dart';

/// Live Courses Screen - Pixel-perfect match to React version
/// Matches: components/screens/live-courses-screen.tsx
class LiveCoursesScreen extends StatelessWidget {
  const LiveCoursesScreen({super.key});

  // Static data matching React exactly
  static const _liveCourses = [
    {
      'id': 1,
      'title': 'ورشة عمل: تصميم التطبيقات',
      'instructor': 'أحمد محمد',
      'date': '2025-12-20T14:00:00',
      'duration': '2 ساعة',
      'participants': 156,
      'status': 'upcoming',
      'image': 'assets/images/motion-graphics-course-in-mumbai.png',
    },
    {
      'id': 2,
      'title': 'مراجعة: أساسيات البرمجة',
      'instructor': 'سارة أحمد',
      'date': '2025-12-19T18:30:00',
      'duration': '1.5 ساعة',
      'participants': 89,
      'status': 'live',
      'image': 'assets/images/motion-pro-thumbnail.jpg',
    },
    {
      'id': 3,
      'title': 'جلسة أسئلة وأجوبة: الذكاء الاصطناعي',
      'instructor': 'محمد علي',
      'date': '2025-12-21T10:00:00',
      'duration': '1 ساعة',
      'participants': 234,
      'status': 'upcoming',
      'image': 'assets/images/Full_HD_Cover_2d_to_3d.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header - Orange gradient like exams page
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF97316), Color(0xFFEA580C)],
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
                        'الكورسات اللايف',
                        style: AppTextStyles.h3(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // mb-4
                  // Sessions count - matches React: gap-2
                  Row(
                    children: [
                      Icon(
                        Icons.videocam,
                        size: 20, // w-5 h-5
                        color: Colors.white.withOpacity(0.7), // white/70
                      ),
                      const SizedBox(width: 8), // gap-2
                      Text(
                        '${_liveCourses.length} جلسات قادمة',
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
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16), // px-4
                  itemCount: _liveCourses.length,
                  itemBuilder: (context, index) {
                    final course = _liveCourses[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 500 + (index * 100)),
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
                      child: _LiveCourseCard(course: course),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveCourseCard extends StatelessWidget {
  final Map<String, dynamic> course;

  const _LiveCourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final isLive = course['status'] == 'live';
    final isUpcoming = course['status'] == 'upcoming';

    return Container(
      margin: const EdgeInsets.only(bottom: 16), // space-y-4
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
          // Course Image - matches React: relative h-40
          Stack(
            children: [
              Container(
                height: 160, // h-40
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: Image.asset(
                    course['image'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.purple.withOpacity(0.1),
                      child: const Icon(
                        Icons.video_library,
                        size: 48,
                        color: AppColors.purple,
                      ),
                    ),
                  ),
                ),
              ),
              // Status badge - matches React
              if (isLive)
                Positioned(
                  top: 12, // top-3
                  right: 12, // right-3
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, // px-3
                      vertical: 4, // py-1
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(999), // rounded-full
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8, // w-2
                          height: 8, // h-2
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4), // gap-1
                        Text(
                          'مباشر الآن',
                          style: AppTextStyles.bodySmall(
                            color: Colors.white,
                          ).copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                )
              else if (isUpcoming)
                Positioned(
                  top: 12, // top-3
                  right: 12, // right-3
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, // px-3
                      vertical: 4, // py-1
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(999), // rounded-full
                    ),
                    child: Text(
                      'قريباً',
                      style: AppTextStyles.bodySmall(
                        color: Colors.white,
                      ).copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
            ],
          ),

          // Course Info - matches React: p-4
          Padding(
            padding: const EdgeInsets.all(16), // p-4
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course['title'] as String,
                  style: AppTextStyles.bodyMedium(
                    color: AppColors.foreground,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8), // mb-2
                Text(
                  course['instructor'] as String,
                  style: AppTextStyles.bodySmall(
                    color: AppColors.purple,
                  ),
                ),
                const SizedBox(height: 12), // mb-3

                // Info row - matches React: gap-4 text-xs mb-4
                Padding(
                  padding: const EdgeInsets.only(bottom: 16), // mb-4
                  child: Row(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16, // w-4 h-4
                            color: AppColors.mutedForeground,
                          ),
                          const SizedBox(width: 4), // gap-1
                          Text(
                            _formatDate(course['date'] as String),
                            style: AppTextStyles.labelSmall(
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16), // gap-4
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16, // w-4 h-4
                            color: AppColors.mutedForeground,
                          ),
                          const SizedBox(width: 4), // gap-1
                          Text(
                            course['duration'] as String,
                            style: AppTextStyles.labelSmall(
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16), // gap-4
                      Row(
                        children: [
                          const Icon(
                            Icons.people,
                            size: 16, // w-4 h-4
                            color: AppColors.mutedForeground,
                          ),
                          const SizedBox(width: 4), // gap-1
                          Text(
                            '${course['participants']}',
                            style: AppTextStyles.labelSmall(
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Countdown or Join button
                if (isUpcoming) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16), // mb-4
                    child: Column(
                      children: [
                        Text(
                          'يبدأ خلال',
                          style: AppTextStyles.labelSmall(
                            color: AppColors.mutedForeground,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8), // mb-2
                        _CountdownTimer(targetDate: course['date'] as String),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12), // py-3
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(16), // rounded-2xl
                    ),
                    child: Center(
                      child: Text(
                        'تذكيري',
                        style: AppTextStyles.bodyMedium(
                          color: Colors.white,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12), // py-3
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16), // rounded-2xl
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
                          'انضم الآن',
                          style: AppTextStyles.bodyMedium(
                            color: Colors.white,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final weekdays = [
        'الأحد',
        'الإثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت'
      ];
      final months = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];
      return '${weekdays[date.weekday % 7]}، ${date.day} ${months[date.month - 1]}';
    } catch (e) {
      return dateStr;
    }
  }
}

class _CountdownTimer extends StatefulWidget {
  final String targetDate;

  const _CountdownTimer({required this.targetDate});

  @override
  State<_CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<_CountdownTimer> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTimeLeft();
    });
  }

  void _updateTimeLeft() {
    try {
      final target = DateTime.parse(widget.targetDate);
      final now = DateTime.now();
      final difference = target.difference(now);
      if (mounted) {
        setState(() {
          _timeLeft = difference.isNegative ? Duration.zero : difference;
        });
      }
    } catch (e) {
      // Ignore parse errors
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours.remainder(24);
    final minutes = _timeLeft.inMinutes.remainder(60);
    final seconds = _timeLeft.inSeconds.remainder(60);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeUnit(days, 'يوم'),
        const SizedBox(width: 8), // gap-2
        _buildTimeUnit(hours, 'ساعة'),
        const SizedBox(width: 8), // gap-2
        _buildTimeUnit(minutes, 'دقيقة'),
        const SizedBox(width: 8), // gap-2
        _buildTimeUnit(seconds, 'ثانية'),
      ],
    );
  }

  Widget _buildTimeUnit(int value, String label) {
    return Container(
      width: 50, // min-w-[50px]
      padding: const EdgeInsets.all(8), // p-2
      decoration: BoxDecoration(
        color: AppColors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12), // rounded-xl
      ),
      child: Column(
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: AppTextStyles.h4(
              color: AppColors.purple,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.labelSmall(
              color: AppColors.mutedForeground,
            ).copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
