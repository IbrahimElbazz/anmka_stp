import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pod_player/pod_player.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../core/design/app_colors.dart';
import '../../core/navigation/route_names.dart';
import '../../services/courses_service.dart';
import '../../services/exams_service.dart';
import '../../services/wishlist_service.dart';

/// Modern Course Details Screen with Beautiful UI
class CourseDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? course;

  const CourseDetailsScreen({super.key, this.course});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  PodPlayerController? _podController;
  int _selectedLessonIndex = 0;
  bool _isVideoLoading = true;
  bool _isLoading = false;
  bool _isEnrolling = false;
  bool _isEnrolled = false;
  Map<String, dynamic>? _courseData;
  Map<String, dynamic>? _trialExamData;
  bool _isLoadingExam = false;
  bool _isInWishlist = false;
  bool _isTogglingWishlist = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCourseDetails();
    _checkWishlistStatus();
  }

  Future<void> _loadCourseDetails() async {
    // If course data is already provided, use it
    if (widget.course != null && widget.course!['id'] != null) {
      final courseId = widget.course!['id']?.toString();
      if (courseId != null && courseId.isNotEmpty) {
        setState(() => _isLoading = true);
        try {
          final courseDetails =
              await CoursesService.instance.getCourseDetails(courseId);
          setState(() {
            _courseData = courseDetails;
            _isEnrolled = courseDetails['is_enrolled'] == true;
            _isInWishlist = courseDetails['is_in_wishlist'] == true;
            _isLoading = false;
          });
          _initializeVideo();
          _loadTrialExam();
          _checkWishlistStatus();
        } catch (e) {
          if (kDebugMode) {
            print('❌ Error loading course details: $e');
          }
          setState(() {
            _courseData = widget.course; // Fallback to provided course
            _isLoading = false;
          });
          _initializeVideo();
        }
      } else {
        setState(() {
          _courseData = widget.course;
        });
        _initializeVideo();
      }
    } else {
      setState(() {
        _courseData = widget.course;
      });
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    final course = _courseData ?? widget.course;
    final curriculum = course?['curriculum'] as List?;
    final lessons = course?['lessons'] as List?;

    // Try to get video from curriculum first, then lessons
    String? videoId;
    if (curriculum != null && curriculum.isNotEmpty) {
      final firstLesson = curriculum[0];
      if (firstLesson is Map) {
        videoId = firstLesson['video']?['youtube_id']?.toString() ??
            firstLesson['youtubeVideoId']?.toString();
      }
    }

    if (videoId == null && lessons != null && lessons.isNotEmpty) {
      final firstLesson = lessons[0];
      if (firstLesson is Map) {
        videoId = firstLesson['video']?['youtube_id']?.toString() ??
            firstLesson['youtubeVideoId']?.toString();
      }
    }

    videoId = videoId ?? 'AevtORdu4pc';

    try {
      _podController = PodPlayerController(
        playVideoFrom:
            PlayVideoFrom.youtube('https://www.youtube.com/watch?v=$videoId'),
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: false,
          isLooping: false,
        ),
      )..initialise().then((_) {
          if (mounted) {
            setState(() => _isVideoLoading = false);
          }
        });
    } catch (e) {
      if (mounted) {
        setState(() => _isVideoLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _podController?.dispose();
    super.dispose();
  }

  void _playLesson(int index, Map<String, dynamic> lesson) async {
    // Extract video ID from lesson
    String? videoId;
    if (lesson['video'] is Map) {
      videoId = lesson['video']?['youtube_id']?.toString();
    }
    videoId = videoId ?? lesson['youtubeVideoId']?.toString() ?? 'AevtORdu4pc';
    setState(() {
      _selectedLessonIndex = index;
      _isVideoLoading = true;
    });

    _podController?.dispose();

    try {
      _podController = PodPlayerController(
        playVideoFrom:
            PlayVideoFrom.youtube('https://www.youtube.com/watch?v=$videoId'),
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: true,
          isLooping: false,
        ),
      )..initialise().then((_) {
          if (mounted) {
            setState(() => _isVideoLoading = false);
          }
        });
    } catch (e) {
      if (mounted) {
        setState(() => _isVideoLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = _courseData ?? widget.course;

    if (_isLoading && _courseData == null) {
      return Scaffold(
        backgroundColor: AppColors.beige,
        body: _buildSkeleton(),
      );
    }

    if (course == null) {
      return Scaffold(
        backgroundColor: AppColors.beige,
        appBar: AppBar(
          title: const Text('تفاصيل الدورة'),
        ),
        body: Center(
          child: Text(
            'لا توجد بيانات للدورة',
            style: GoogleFonts.cairo(),
          ),
        ),
      );
    }

    final isFree = course['is_free'] == true || course['isFree'] == true;

    // Safely parse price
    num priceValue = 0.0;
    if (course['price'] != null) {
      if (course['price'] is num) {
        priceValue = course['price'] as num;
      } else if (course['price'] is String) {
        priceValue = num.tryParse(course['price'] as String) ?? 0.0;
      }
    }
    final isFreeFromPrice = priceValue == 0;
    final finalIsFree = isFree || isFreeFromPrice;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        child: Column(
          children: [
            // Video Player Section
            _buildVideoSection(),

            // Content Section - Scrollable
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Course Info Header
                      _buildCourseHeader(course, finalIsFree, priceValue),

                      // Tabs
                      _buildTabs(),

                      // Tab Content
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildLessonsTab(),
                            _buildAboutTab(course),
                            _buildTrialExamTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Action Button
      bottomNavigationBar: _buildBottomBar(course, finalIsFree),
    );
  }

  Widget _buildVideoSection() {
    return Container(
      height: 220,
      color: Colors.black,
      child: Stack(
        children: [
          // Video Player
          if (_podController != null && !_isVideoLoading)
            PodVideoPlayer(
              controller: _podController!,
              videoAspectRatio: 16 / 9,
              podProgressBarConfig: const PodProgressBarConfig(
                playingBarColor: AppColors.purple,
                circleHandlerColor: AppColors.purple,
                bufferedBarColor: Colors.white30,
              ),
            )
          else
            Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.purple,
                ),
              ),
            ),

          // Top Bar
          Positioned(
            top: 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _isTogglingWishlist ? null : _toggleWishlist,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _isTogglingWishlist
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Icon(
                                _isInWishlist
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_border_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.share_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseHeader(
      Map<String, dynamic>? course, bool isFree, num price) {
    if (course == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Badge & Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  course['category'] is Map
                      ? (course['category'] as Map)['name']?.toString() ??
                          'التصميم'
                      : course['category']?.toString() ?? 'التصميم',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.purple,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isFree
                        ? [const Color(0xFF10B981), const Color(0xFF059669)]
                        : [const Color(0xFFF97316), const Color(0xFFEA580C)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isFree ? 'مجاني' : '${price.toInt()} ج.م',
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            course['title']?.toString() ?? 'عنوان الدورة',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 8),

          // Instructor
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.person, size: 16, color: AppColors.purple),
              ),
              const SizedBox(width: 8),
              Text(
                course['instructor'] is Map
                    ? (course['instructor'] as Map)['name']?.toString() ??
                        'المدرب'
                    : course['instructor']?.toString() ?? 'المدرب',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: AppColors.purple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Stats Row
          Row(
            children: [
              _buildStatChip(
                Icons.star_rounded,
                _safeParseRating(course['rating']),
                Colors.amber,
              ),
              const SizedBox(width: 12),
              _buildStatChip(
                Icons.people_rounded,
                _safeParseCount(course['students_count'] ?? course['students']),
                AppColors.purple,
              ),
              const SizedBox(width: 12),
              _buildStatChip(
                Icons.access_time_rounded,
                '${_safeParseHours(course['duration_hours'] ?? course['hours'])}س',
                const Color(0xFF10B981),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.mutedForeground,
        labelStyle:
            GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.cairo(fontSize: 13),
        padding: const EdgeInsets.all(4),
        tabs: const [
          Tab(text: 'الدروس'),
          Tab(text: 'نبذة'),
          Tab(text: 'امتحان تجريبي'),
        ],
      ),
    );
  }

  String _safeParseRating(dynamic rating) {
    if (rating == null) return '0.0';
    if (rating is num) return rating.toStringAsFixed(1);
    if (rating is String) {
      final parsed = num.tryParse(rating);
      return parsed?.toStringAsFixed(1) ?? '0.0';
    }
    return '0.0';
  }

  String _safeParseCount(dynamic count) {
    if (count == null) return '0';
    if (count is int) return count.toString();
    if (count is num) return count.toInt().toString();
    if (count is String) {
      final parsed = int.tryParse(count);
      return parsed?.toString() ?? '0';
    }
    return '0';
  }

  int _safeParseHours(dynamic hours) {
    if (hours == null) return 0;
    if (hours is int) return hours;
    if (hours is num) return hours.toInt();
    if (hours is String) {
      final parsed = int.tryParse(hours);
      return parsed ?? 0;
    }
    return 0;
  }

  Widget _buildLessonsTab() {
    final course = _courseData ?? widget.course;
    // Try curriculum first, then lessons
    final curriculum = course?['curriculum'] as List?;
    final lessons = course?['lessons'] as List?;
    final lessonsList = curriculum ?? lessons ?? [];

    if (lessonsList.isEmpty) {
      return _buildEmptyState('لا توجد دروس متاحة', Icons.play_lesson_rounded);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: lessonsList.length,
      itemBuilder: (context, index) {
        final lesson = lessonsList[index];
        if (lesson is! Map<String, dynamic>) {
          return const SizedBox.shrink();
        }

        final isLocked =
            lesson['is_locked'] == true || lesson['locked'] == true;
        final isCompleted =
            lesson['is_completed'] == true || lesson['completed'] == true;
        final isSelected = index == _selectedLessonIndex;

        return GestureDetector(
          onTap: isLocked
              ? null
              : () {
                  _playLesson(index, lesson);
                },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.purple.withOpacity(0.08)
                  : isLocked
                      ? Colors.grey[50]
                      : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.purple
                    : isCompleted
                        ? const Color(0xFF10B981)
                        : Colors.grey.withOpacity(0.15),
                width: isSelected || isCompleted ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Index/Status Circle
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
                          )
                        : isCompleted
                            ? const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF059669)],
                              )
                            : null,
                    color: isLocked ? Colors.grey[200] : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isLocked
                      ? Icon(Icons.lock_rounded,
                          color: Colors.grey[400], size: 20)
                      : isCompleted
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 20)
                          : isSelected
                              ? const Icon(Icons.play_arrow_rounded,
                                  color: Colors.white, size: 22)
                              : Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: GoogleFonts.cairo(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.purple,
                                    ),
                                  ),
                                ),
                ),
                const SizedBox(width: 14),

                // Lesson Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson['title']?.toString() ?? 'الدرس',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isLocked
                              ? Colors.grey[500]
                              : AppColors.foreground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDuration(lesson),
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Play Icon
                if (!isLocked)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : AppColors.purple.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSelected
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: AppColors.purple,
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(Map<String, dynamic> lesson) {
    // Try duration_minutes first, then duration
    if (lesson['duration_minutes'] != null) {
      final minutes = lesson['duration_minutes'];
      if (minutes is int) {
        return '$minutes دقيقة';
      } else if (minutes is num) {
        return '${minutes.toInt()} دقيقة';
      } else if (minutes is String) {
        final parsed = int.tryParse(minutes);
        if (parsed != null) return '$parsed دقيقة';
      }
    }
    return lesson['duration']?.toString() ?? '10 دقائق';
  }

  Widget _buildAboutTab(Map<String, dynamic>? course) {
    final courseData = _courseData ?? course;
    final description = courseData?['description']?.toString() ??
        'هذه الدورة مصممة خصيصاً لمساعدتك على تعلم المهارات الأساسية والمتقدمة في المجال. '
            'ستتعلم من خلال دروس عملية ومشاريع حقيقية تساعدك على تطبيق ما تعلمته بشكل فعال. '
            'الدورة مناسبة للمبتدئين والمحترفين على حد سواء.';

    // Get what_you_learn from API
    final whatYouLearn = courseData?['what_you_learn'] as List?;
    final features = <Map<String, dynamic>>[];

    if (whatYouLearn != null && whatYouLearn.isNotEmpty) {
      for (var item in whatYouLearn) {
        if (item is String) {
          features.add({'icon': Icons.check_circle_outline, 'text': item});
        } else if (item is Map) {
          features.add({
            'icon': Icons.check_circle_outline,
            'text': item['text']?.toString() ?? item.toString()
          });
        }
      }
    }

    // Add default features if empty
    if (features.isEmpty) {
      features.addAll([
        {
          'icon': Icons.check_circle_outline,
          'text': 'شهادة معتمدة عند الإكمال'
        },
        {'icon': Icons.access_time, 'text': 'وصول مدى الحياة للمحتوى'},
        {'icon': Icons.phone_android, 'text': 'متاح على جميع الأجهزة'},
        {'icon': Icons.download_rounded, 'text': 'ملفات للتحميل'},
      ]);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'وصف الدورة',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              description,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: AppColors.mutedForeground,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'ماذا ستحصل عليه',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 12),
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        feature['icon'] as IconData,
                        size: 18,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      feature['text'] as String,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: AppColors.foreground,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTrialExamTab() {
    if (_isLoadingExam) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppColors.purple,
            ),
            const SizedBox(height: 16),
            Text(
              'جاري تحميل الامتحان...',
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      );
    }

    if (_trialExamData == null) {
      return _buildEmptyState('لا يوجد امتحان تجريبي متاح', Icons.quiz_rounded);
    }

    final canStart = _trialExamData!['can_start'] == true;
    final isPassed = _trialExamData!['is_passed'] == true;
    final bestScore = _trialExamData!['best_score'];
    final questionsCount = _trialExamData!['questions_count'] ?? 0;
    final durationMinutes = _trialExamData!['duration_minutes'] ?? 15;
    final passingScore = _trialExamData!['passing_score'] ?? 70;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Exam Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.quiz_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _trialExamData!['title']?.toString() ?? 'امتحان تجريبي',
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _trialExamData!['description']?.toString() ??
                      'اختبر معلوماتك قبل البدء في الدورة',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Exam Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildExamInfoChip(
                      Icons.help_outline,
                      '$questionsCount سؤال',
                      Colors.white.withOpacity(0.3),
                    ),
                    const SizedBox(width: 12),
                    _buildExamInfoChip(
                      Icons.access_time,
                      '$durationMinutes دقيقة',
                      Colors.white.withOpacity(0.3),
                    ),
                    const SizedBox(width: 12),
                    _buildExamInfoChip(
                      Icons.star,
                      '$passingScore% للنجاح',
                      Colors.white.withOpacity(0.3),
                    ),
                  ],
                ),
                if (bestScore != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isPassed
                          ? Colors.green.withOpacity(0.3)
                          : Colors.orange.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isPassed
                          ? 'أفضل نتيجة: $bestScore% ✓'
                          : 'أفضل نتيجة: $bestScore%',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: canStart ? () => _startTrialExam() : null,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: canStart
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          color: canStart ? AppColors.purple : Colors.grey,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          canStart ? 'ابدأ الامتحان' : 'غير متاح',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: canStart ? AppColors.purple : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamInfoChip(IconData icon, String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.purple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: AppColors.purple),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(Map<String, dynamic>? course, bool isFree) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: _isTogglingWishlist ? null : _toggleWishlist,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _isTogglingWishlist
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.orange),
                        ),
                      )
                    : Icon(
                        _isInWishlist
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: AppColors.orange,
                        size: 24,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: _isEnrolling
                    ? null
                    : () async {
                        final courseData = _courseData ?? course;

                        // If already enrolled, go to first lesson
                        if (_isEnrolled) {
                          final curriculum = courseData?['curriculum'] as List?;
                          final lessons = courseData?['lessons'] as List?;
                          final lessonsList = curriculum ?? lessons ?? [];
                          if (lessonsList.isNotEmpty) {
                            context.push(RouteNames.lessonViewer,
                                extra: lessonsList[0]);
                          }
                          return;
                        }

                        // If free course, enroll directly
                        if (isFree) {
                          await _enrollInCourse();
                        } else {
                          // If paid course, go to checkout
                          context.push(RouteNames.checkout, extra: courseData);
                        }
                      },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: _isEnrolling
                        ? null
                        : const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
                          ),
                    color: _isEnrolling ? Colors.grey[300] : null,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isEnrolling)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.grey),
                          ),
                        )
                      else
                        Icon(
                          _isEnrolled
                              ? Icons.play_circle_rounded
                              : isFree
                                  ? Icons.play_circle_rounded
                                  : Icons.shopping_cart_rounded,
                          color: _isEnrolling ? Colors.grey : Colors.white,
                          size: 22,
                        ),
                      const SizedBox(width: 10),
                      Text(
                        _isEnrolling
                            ? 'جاري الاشتراك...'
                            : _isEnrolled
                                ? 'ابدأ التعلم الآن'
                                : isFree
                                    ? 'اشترك مجاناً'
                                    : 'اشترك في الدورة',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isEnrolling ? Colors.grey[600] : Colors.white,
                        ),
                      ),
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

  Future<void> _enrollInCourse() async {
    final course = _courseData ?? widget.course;
    if (course == null || course['id'] == null) return;

    final courseId = course['id']?.toString();
    if (courseId == null || courseId.isEmpty) return;

    setState(() => _isEnrolling = true);

    try {
      final enrollment = await CoursesService.instance.enrollInCourse(courseId);
      if (kDebugMode) {
        print('✅ Successfully enrolled in course: $enrollment');
      }

      setState(() {
        _isEnrolled = true;
        _isEnrolling = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم الاشتراك في الدورة بنجاح',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }

      // Navigate to first lesson if available
      final curriculum = course['curriculum'] as List?;
      final lessons = course['lessons'] as List?;
      final lessonsList = curriculum ?? lessons ?? [];
      if (lessonsList.isNotEmpty && mounted) {
        context.push(RouteNames.lessonViewer, extra: lessonsList[0]);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error enrolling in course: $e');
      }

      setState(() => _isEnrolling = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().contains('401') ||
                      e.toString().contains('Unauthorized')
                  ? 'يجب تسجيل الدخول أولاً'
                  : 'حدث خطأ أثناء الاشتراك في الدورة',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _loadTrialExam() async {
    final course = _courseData ?? widget.course;
    if (course == null || course['id'] == null) return;

    // Try to get exam_id from course data
    final examId =
        course['trial_exam_id']?.toString() ?? course['exam_id']?.toString();

    if (examId == null || examId.isEmpty) {
      // Try to find trial exam from course exams list
      final exams = course['exams'] as List?;
      if (exams != null && exams.isNotEmpty) {
        for (var exam in exams) {
          if (exam is Map &&
              (exam['type'] == 'trial' || exam['type'] == 'trial_exam')) {
            try {
              final examDetails = await ExamsService.instance
                  .getExamDetails(exam['id']?.toString() ?? '');
              setState(() {
                _trialExamData = examDetails;
              });
              return;
            } catch (e) {
              if (kDebugMode) {
                print('❌ Error loading trial exam: $e');
              }
            }
          }
        }
      }
      return;
    }

    setState(() => _isLoadingExam = true);

    try {
      final examDetails = await ExamsService.instance.getExamDetails(examId);
      setState(() {
        _trialExamData = examDetails;
        _isLoadingExam = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading trial exam: $e');
      }
      setState(() => _isLoadingExam = false);
    }
  }

  Future<void> _checkWishlistStatus() async {
    final course = _courseData ?? widget.course;
    if (course == null || course['id'] == null) return;

    final courseId = course['id']?.toString();
    if (courseId == null || courseId.isEmpty) return;

    try {
      final wishlist = await WishlistService.instance.getWishlist();
      final items = wishlist['data'] as List?;

      if (items != null) {
        final isInWishlist = items.any((item) {
          final itemCourse = item['course'] as Map<String, dynamic>?;
          final itemCourseId =
              itemCourse?['id']?.toString() ?? item['course_id']?.toString();
          return itemCourseId == courseId;
        });

        if (mounted) {
          setState(() {
            _isInWishlist = isInWishlist;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking wishlist status: $e');
      }
      // Don't update state on error, keep current state
    }
  }

  Future<void> _toggleWishlist() async {
    final course = _courseData ?? widget.course;
    if (course == null || course['id'] == null) return;

    final courseId = course['id']?.toString();
    if (courseId == null || courseId.isEmpty) return;

    setState(() => _isTogglingWishlist = true);

    try {
      if (_isInWishlist) {
        await WishlistService.instance.removeFromWishlist(courseId);
        if (kDebugMode) {
          print('✅ Removed from wishlist');
        }
      } else {
        await WishlistService.instance.addToWishlist(courseId);
        if (kDebugMode) {
          print('✅ Added to wishlist');
        }
      }

      setState(() {
        _isInWishlist = !_isInWishlist;
        _isTogglingWishlist = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isInWishlist
                  ? 'تمت الإضافة إلى قائمة الرغبات'
                  : 'تمت الإزالة من قائمة الرغبات',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error toggling wishlist: $e');
      }

      setState(() => _isTogglingWishlist = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().contains('401') ||
                      e.toString().contains('Unauthorized')
                  ? 'يجب تسجيل الدخول أولاً'
                  : 'حدث خطأ أثناء ${_isInWishlist ? 'الإزالة من' : 'الإضافة إلى'} قائمة الرغبات',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _startTrialExam() async {
    if (_trialExamData == null) {
      // Try to load exam first
      await _loadTrialExam();
      if (_trialExamData == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'لا يوجد امتحان تجريبي متاح',
                style: GoogleFonts.cairo(),
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
        return;
      }
    }

    final examId = _trialExamData!['id']?.toString();
    if (examId == null || examId.isEmpty) return;

    try {
      // Start exam via API
      final examSession = await ExamsService.instance.startExam(examId);

      if (kDebugMode) {
        print('✅ Exam started: $examSession');
      }

      final questions = examSession['questions'] as List?;
      final attemptId = examSession['attempt_id']?.toString();

      if (questions == null || questions.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'لا توجد أسئلة متاحة في الامتحان',
                style: GoogleFonts.cairo(),
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
        return;
      }

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrialExamScreen(
              examId: examId,
              attemptId: attemptId,
              courseName:
                  (_courseData ?? widget.course)?['title']?.toString() ??
                      'الدورة',
              examData: _trialExamData,
              examSession: examSession,
            ),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error starting exam: $e');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().contains('401') ||
                      e.toString().contains('Unauthorized')
                  ? 'يجب تسجيل الدخول أولاً'
                  : 'حدث خطأ أثناء بدء الامتحان',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Widget _buildSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: Scaffold(
        backgroundColor: AppColors.beige,
        body: SafeArea(
          child: Column(
            children: [
              // Video skeleton
              Container(
                height: 220,
                color: Colors.black,
              ),
              // Content skeleton
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header skeleton
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 24,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 24,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 60,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 60,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Tabs skeleton
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Lessons skeleton
                          ...List.generate(5, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Trial Exam Screen
class TrialExamScreen extends StatefulWidget {
  final String examId;
  final String? attemptId;
  final String courseName;
  final Map<String, dynamic>? examData;
  final Map<String, dynamic>? examSession;
  final List<Map<String, dynamic>>? questions; // Fallback for static questions

  const TrialExamScreen({
    super.key,
    required this.examId,
    this.attemptId,
    required this.courseName,
    this.examData,
    this.examSession,
    this.questions,
  });

  @override
  State<TrialExamScreen> createState() => _TrialExamScreenState();
}

class _TrialExamScreenState extends State<TrialExamScreen> {
  int _currentQuestionIndex = 0;
  final Map<int, List<String>> _selectedAnswers =
      {}; // For multiple choice questions
  final Map<int, String?> _singleAnswers = {}; // For single choice questions
  bool _showResult = false;
  bool _isSubmitting = false;
  Map<String, dynamic>? _examResult;
  List<Map<String, dynamic>> _questions = [];
  String? _attemptId;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    // Get questions from exam session or use fallback
    if (widget.examSession != null &&
        widget.examSession!['questions'] != null) {
      final questions = widget.examSession!['questions'] as List;
      _questions = questions.map((q) => q as Map<String, dynamic>).toList();
      _attemptId =
          widget.examSession!['attempt_id']?.toString() ?? widget.attemptId;
    } else if (widget.questions != null) {
      _questions = List<Map<String, dynamic>>.from(widget.questions!);
    }

    // Initialize answers
    for (int i = 0; i < _questions.length; i++) {
      _singleAnswers[i] = null;
      _selectedAnswers[i] = [];
    }
  }

  void _selectAnswer(int optionIndex) {
    setState(() {
      final question = _questions[_currentQuestionIndex];

      // Check if multiple choice
      final isMultiple = question['is_multiple'] == true ||
          question['type'] == 'multiple_choice';

      if (isMultiple) {
        final selected = _selectedAnswers[_currentQuestionIndex] ?? [];
        final optionId = question['options']?[optionIndex]?['id']?.toString() ??
            question['options']?[optionIndex]?['option_id']?.toString();

        if (selected.contains(optionId)) {
          selected.remove(optionId);
        } else {
          selected.add(optionId ?? optionIndex.toString());
        }
        _selectedAnswers[_currentQuestionIndex] = selected;
      } else {
        // Single choice
        final optionId = question['options']?[optionIndex]?['id']?.toString() ??
            question['options']?[optionIndex]?['option_id']?.toString();
        _singleAnswers[_currentQuestionIndex] =
            optionId ?? optionIndex.toString();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _submitExam();
    }
  }

  bool get _hasSelectedAnswer {
    final question = _questions[_currentQuestionIndex];
    final isMultiple = question['is_multiple'] == true ||
        question['type'] == 'multiple_choice';

    if (isMultiple) {
      final selected = _selectedAnswers[_currentQuestionIndex] ?? [];
      return selected.isNotEmpty;
    } else {
      return _singleAnswers[_currentQuestionIndex] != null;
    }
  }

  Future<void> _submitExam() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      // Prepare answers in API format
      final answers = <Map<String, dynamic>>[];

      for (int i = 0; i < _questions.length; i++) {
        final question = _questions[i];
        final questionId = question['id']?.toString() ??
            question['question_id']?.toString() ??
            'q_$i';

        final isMultiple = question['is_multiple'] == true ||
            question['type'] == 'multiple_choice';

        if (isMultiple) {
          final selected = _selectedAnswers[i] ?? [];
          answers.add({
            'question_id': questionId,
            'selected_options': selected,
          });
        } else {
          final selected = _singleAnswers[i];
          if (selected != null) {
            answers.add({
              'question_id': questionId,
              'selected_options': [selected],
            });
          }
        }
      }

      if (_attemptId == null || _attemptId!.isEmpty) {
        throw Exception('Attempt ID is missing');
      }

      final result = await ExamsService.instance.submitExam(
        widget.examId,
        attemptId: _attemptId!,
        answers: answers,
      );

      if (kDebugMode) {
        print('✅ Exam submitted: $result');
      }

      setState(() {
        _examResult = result;
        _showResult = true;
        _isSubmitting = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error submitting exam: $e');
      }

      setState(() => _isSubmitting = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().contains('401') ||
                      e.toString().contains('Unauthorized')
                  ? 'يجب تسجيل الدخول أولاً'
                  : 'حدث خطأ أثناء تقديم الامتحان',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.beige,
        appBar: AppBar(
          backgroundColor: AppColors.purple,
          title: Text(
            'الامتحان التجريبي',
            style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: AppColors.purple,
              ),
              const SizedBox(height: 16),
              Text(
                'جاري تحميل الأسئلة...',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_showResult) {
      return _buildResultScreen();
    }

    final question = _questions[_currentQuestionIndex];
    final options = question['options'] as List? ?? [];
    final isMultiple = question['is_multiple'] == true ||
        question['type'] == 'multiple_choice';

    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        title: Text(
          'الامتحان التجريبي',
          style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Center(
              child: Text(
                '${_currentQuestionIndex + 1}/${_questions.length}',
                style: GoogleFonts.cairo(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'السؤال ${_currentQuestionIndex + 1}',
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.purple,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    question['question']?.toString() ??
                        question['text']?.toString() ??
                        'السؤال',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Options
            ...List.generate(options.length, (index) {
              final option = options[index];
              final optionId = option['id']?.toString() ??
                  option['option_id']?.toString() ??
                  index.toString();

              bool isSelected = false;
              if (isMultiple) {
                final selected = _selectedAnswers[_currentQuestionIndex] ?? [];
                isSelected = selected.contains(optionId);
              } else {
                isSelected = _singleAnswers[_currentQuestionIndex] == optionId;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => _selectAnswer(index),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.purple.withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.purple
                            : Colors.grey.withOpacity(0.2),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.purple
                                : Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: isSelected && isMultiple
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : Text(
                                    String.fromCharCode(1571 + index),
                                    style: GoogleFonts.cairo(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.mutedForeground,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            option['text']?.toString() ??
                                option['option']?.toString() ??
                                option.toString(),
                            style: GoogleFonts.cairo(
                              fontSize: 15,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.purple
                                  : AppColors.foreground,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Next Button
            GestureDetector(
              onTap:
                  (_hasSelectedAnswer && !_isSubmitting) ? _nextQuestion : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: (_hasSelectedAnswer && !_isSubmitting)
                      ? const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)])
                      : null,
                  color: (!_hasSelectedAnswer || _isSubmitting)
                      ? Colors.grey[300]
                      : null,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.grey),
                          ),
                        )
                      : Text(
                          _currentQuestionIndex == _questions.length - 1
                              ? 'إنهاء الامتحان'
                              : 'التالي',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _hasSelectedAnswer
                                ? Colors.white
                                : Colors.grey[500],
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    int score = 0;
    bool passed = false;
    int correctAnswers = 0;
    int totalQuestions = _questions.length;
    String? message;

    if (_examResult != null) {
      score = (_examResult!['score'] as num?)?.toInt() ?? 0;
      passed = _examResult!['is_passed'] == true;
      correctAnswers = _examResult!['correct_answers'] as int? ?? 0;
      totalQuestions =
          _examResult!['total_questions'] as int? ?? _questions.length;
      message = _examResult!['message']?.toString();
    } else {
      // Fallback calculation (should not happen if API works)
      score = 0;
      passed = false;
    }

    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: passed
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF97316),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    passed ? Icons.emoji_events_rounded : Icons.refresh_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  message ?? (passed ? 'أحسنت! 🎉' : 'حاول مرة أخرى'),
                  style: GoogleFonts.cairo(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'نتيجتك: $score%',
                  style: GoogleFonts.cairo(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: passed
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF97316),
                  ),
                ),
                Text(
                  '$correctAnswers من $totalQuestions إجابات صحيحة',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: AppColors.mutedForeground,
                  ),
                ),
                if (_examResult != null &&
                    _examResult!['time_taken_minutes'] != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'الوقت المستغرق: ${_examResult!['time_taken_minutes']} دقيقة',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'إنهاء',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
