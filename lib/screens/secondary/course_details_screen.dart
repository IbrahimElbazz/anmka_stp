import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pod_player/pod_player.dart';
import '../../core/design/app_colors.dart';
import '../../core/navigation/route_names.dart';

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
  bool _isDescriptionExpanded = false;
  bool _isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final lessons = widget.course?['lessons'] as List?;
    final videoId = lessons?.isNotEmpty == true
        ? (lessons![0]['youtubeVideoId'] ?? 'AevtORdu4pc')
        : 'AevtORdu4pc';

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

  void _playLesson(int index, String videoId) async {
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
    final course = widget.course;
    final isFree = course?['isFree'] == true;
    final price = (course?['price'] ?? 0.0);

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
                      _buildCourseHeader(course, isFree, price),

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
      bottomNavigationBar: _buildBottomBar(course, isFree),
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
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.bookmark_border_rounded,
                        color: Colors.white,
                        size: 20,
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
      Map<String, dynamic>? course, bool isFree, dynamic price) {
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
                  course?['category'] ?? 'التصميم',
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
                  isFree ? 'مجاني' : '${price.toStringAsFixed(0)} ج.م',
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
            course?['title'] ?? 'عنوان الدورة',
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
                course?['instructor'] ?? 'المدرب',
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
              _buildStatChip(Icons.star_rounded, '${course?['rating'] ?? 4.8}',
                  Colors.amber),
              const SizedBox(width: 12),
              _buildStatChip(Icons.people_rounded,
                  '${course?['students'] ?? 500}', AppColors.purple),
              const SizedBox(width: 12),
              _buildStatChip(Icons.access_time_rounded,
                  '${course?['hours'] ?? 48}س', const Color(0xFF10B981)),
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

  Widget _buildLessonsTab() {
    final lessons = widget.course?['lessons'] as List? ?? [];

    if (lessons.isEmpty) {
      return _buildEmptyState('لا توجد دروس متاحة', Icons.play_lesson_rounded);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        final isLocked = lesson['locked'] == true;
        final isCompleted = lesson['completed'] == true;
        final isSelected = index == _selectedLessonIndex;

        return GestureDetector(
          onTap: isLocked
              ? null
              : () {
                  final videoId = lesson['youtubeVideoId'] ?? 'AevtORdu4pc';
                  _playLesson(index, videoId);
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
                        lesson['title'] ?? 'الدرس',
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
                            lesson['duration'] ?? '10 دقائق',
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

  Widget _buildAboutTab(Map<String, dynamic>? course) {
    final description = course?['description'] ??
        'هذه الدورة مصممة خصيصاً لمساعدتك على تعلم المهارات الأساسية والمتقدمة في المجال. '
            'ستتعلم من خلال دروس عملية ومشاريع حقيقية تساعدك على تطبيق ما تعلمته بشكل فعال. '
            'الدورة مناسبة للمبتدئين والمحترفين على حد سواء.';

    final features = [
      {'icon': Icons.check_circle_outline, 'text': 'شهادة معتمدة عند الإكمال'},
      {'icon': Icons.access_time, 'text': 'وصول مدى الحياة للمحتوى'},
      {'icon': Icons.phone_android, 'text': 'متاح على جميع الأجهزة'},
      {'icon': Icons.download_rounded, 'text': 'ملفات للتحميل'},
    ];

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
                  'امتحان تجريبي',
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'اختبر معلوماتك قبل البدء في الدورة',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => _startTrialExam(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow_rounded,
                            color: AppColors.purple, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'ابدأ الامتحان',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.purple,
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
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.bookmark_border_rounded,
                  color: AppColors.orange, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (isFree) {
                    final lessons = course?['lessons'] as List?;
                    if (lessons != null && lessons.isNotEmpty) {
                      context.push(RouteNames.lessonViewer, extra: lessons[0]);
                    }
                  } else {
                    context.push(RouteNames.checkout, extra: course);
                  }
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isFree
                            ? Icons.play_circle_rounded
                            : Icons.shopping_cart_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isFree ? 'ابدأ التعلم الآن' : 'اشترك في الدورة',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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

  void _startTrialExam() {
    final examQuestions = [
      {
        'question': 'ما هو المفهوم الأساسي الذي يعتمد عليه هذا المجال؟',
        'options': [
          'الإبداع والتصميم',
          'البرمجة فقط',
          'الرياضيات المتقدمة',
          'لا شيء مما سبق'
        ],
        'correctAnswer': 0,
      },
      {
        'question': 'أي من الأدوات التالية تستخدم بشكل أساسي؟',
        'options': [
          'برنامج Excel',
          'برنامج Word',
          'أدوات التصميم المتخصصة',
          'الآلة الحاسبة'
        ],
        'correctAnswer': 2,
      },
      {
        'question': 'ما هي أهم مهارة يجب تطويرها؟',
        'options': [
          'السرعة في الكتابة',
          'التفكير الإبداعي',
          'حفظ المعلومات',
          'القراءة السريعة'
        ],
        'correctAnswer': 1,
      },
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrialExamScreen(
          courseName: widget.course?['title'] ?? 'الدورة',
          questions: examQuestions,
        ),
      ),
    );
  }
}

/// Trial Exam Screen
class TrialExamScreen extends StatefulWidget {
  final String courseName;
  final List<Map<String, dynamic>> questions;

  const TrialExamScreen({
    super.key,
    required this.courseName,
    required this.questions,
  });

  @override
  State<TrialExamScreen> createState() => _TrialExamScreenState();
}

class _TrialExamScreenState extends State<TrialExamScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswer;
  final List<int?> _answers = [];
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _answers.addAll(List.filled(widget.questions.length, null));
  }

  void _selectAnswer(int index) {
    setState(() {
      _selectedAnswer = index;
      _answers[_currentQuestionIndex] = index;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = _answers[_currentQuestionIndex];
      });
    } else {
      setState(() => _showResult = true);
    }
  }

  int get _correctAnswersCount {
    int count = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (_answers[i] == widget.questions[i]['correctAnswer']) {
        count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    if (_showResult) {
      return _buildResultScreen();
    }

    final question = widget.questions[_currentQuestionIndex];
    final options = question['options'] as List;

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
                '${_currentQuestionIndex + 1}/${widget.questions.length}',
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
                    question['question'] as String,
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
              final isSelected = _selectedAnswer == index;
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
                            child: Text(
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
                            options[index] as String,
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
              onTap: _selectedAnswer != null ? _nextQuestion : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: _selectedAnswer != null
                      ? const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)])
                      : null,
                  color: _selectedAnswer == null ? Colors.grey[300] : null,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    _currentQuestionIndex == widget.questions.length - 1
                        ? 'إنهاء الامتحان'
                        : 'التالي',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedAnswer != null
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
    final score =
        (_correctAnswersCount / widget.questions.length * 100).round();
    final passed = score >= 70;

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
                  passed ? 'أحسنت! 🎉' : 'حاول مرة أخرى',
                  style: GoogleFonts.cairo(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
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
                  '$_correctAnswersCount من ${widget.questions.length} إجابات صحيحة',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: AppColors.mutedForeground,
                  ),
                ),
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
